{
  description = "Example nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, nix-homebrew }:
    let
      configuration = { pkgs, lib, config, ... }: {
        nixpkgs.config.allowUnfree = true;

        system.primaryUser = "zizal";

        system.defaults = {
          WindowManager = {
            StageManagerHideWidgets = true;
            StandardHideWidgets = true;
            StandardHideDesktopIcons = true;
          };

          CustomUserPreferences = {
            "com.apple.symbolichotkeys" = {
              AppleSymbolicHotKeys = {
                # 64: Spotlight Search (Cmd + Space)
                "64" = {
                  enabled = false;
                  value = {
                    parameters = [ 32 49 1048576 ];
                    type = "standard";
                  };
                };
                # 65: Finder Search Window (Option + Cmd + Space)
                "65" = {
                  enabled = false;
                  value = {
                    parameters = [ 32 49 1572864 ];
                    type = "standard";
                  };
                };
              };
            };
          };

          controlcenter = {
            BatteryShowPercentage = true;
            Bluetooth = true;
            NowPlaying = true;
            Sound = true;
          };

          finder = {
            FXRemoveOldTrashItems = true;
            _FXShowPosixPathInTitle = true;
            AppleShowAllFiles = true;
            QuitMenuItem = true;
            ShowPathbar = true;
          };

          NSGlobalDomain = {
            NSAutomaticWindowAnimationsEnabled = false;
            AppleKeyboardUIMode = 3;
          };

          dock = {
            autohide = true;
            expose-group-apps = false;
            show-recents = false;
            orientation = "left";
            tilesize = 48;
            persistent-apps = [
              "/Applications/Arc.app"
              "/Applications/Gemini.app"
              "/Applications/Youtube Music.app"
              "/Applications/Ghostty.app"
              "/Applications/Bruno.app"
              "/Applications/Obsidian.app"
              "/Applications/DataGrip.app"
              "/Applications/Hotspot Shield.app"
            ];
          };
        };

        environment.systemPackages = with pkgs; [
          qmk
        ];

        homebrew = {
          enable = true;
          taps = [
            "dashlane/tap"
            "FelixKratz/formulae"
            "nikitabobko/tap"
          ];

          casks = [
            "arc"
            "ghostty"
            "figma"
            "whatsapp"
            "microsoft-excel"
            "leader-key"
            "discord"
            "android-commandlinetools"
            "orbstack"
            "gitkraken"
            "windows-app"
            "bruno"
            "obsidian"
            "slack"
            "shortcat"
            "datagrip"
            "gcloud-cli"
            "raycast"
            "flutter"
            "nikitabobko/tap/aerospace"
            "crossover"
          ];

          brews = [
            "dashlane/tap/dashlane-cli"     # Explícito
            "FelixKratz/formulae/borders"   # Explícito para borders
            "mole"
            "bat"
            "btop"
            "tldr"
            "mise"
            "coreutils"
            "findutils"
            "wget"
            "usage"
            "gh"
            "infisical"
            "tmux"
            "yazi"
            "lazygit"
            "lazyssh"
            "neovim"
            "starship"
            "zoxide"
            "fzf"
            "eza"
            "ripgrep"
            "fd"
            "jq"
            "pipx"
            "trash-cli"
            "git"
            "mas"
            "cocoapods"
            "fastlane"
            "act"
            "atuin"
            "balena-cli"
            "carapace"
            "direnv"
            "chezmoi"
            "tree-sitter"
            "openvpn"
          ];
          
         masApps = {
            Xcode = 497799835;
            Transporter = 1450874784;
            Hotspot-Shield = 771076721;
          };
          onActivation = { 
            autoUpdate = true; 
            upgrade = true; 
            cleanup = "zap"; 
          };
        };

        nix.settings.experimental-features = "nix-command flakes";
        system.configurationRevision = self.rev or self.dirtyRev or null;
        system.stateVersion = 6;
        nixpkgs.hostPlatform = "aarch64-darwin";
      };
    in
    {
      darwinConfigurations."Cesars-MacBook-Pro" = nix-darwin.lib.darwinSystem {
        modules = [
          configuration
          nix-homebrew.darwinModules.nix-homebrew
          {
            nix-homebrew = {
              enable = true;
              enableRosetta = true;
              user = "zizal";
              autoMigrate = true;
            };
          }
        ];
      };
    };
}
