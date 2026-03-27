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
      username = "zizal";
      hostname = "Cesars-MacBook-Pro";

      configuration = { pkgs, lib, config, ... }: {
        nixpkgs.config.allowUnfree = true;

        system.primaryUser = username;

        system.defaults = {
          WindowManager = {
            StageManagerHideWidgets = true;
            StandardHideWidgets = true;
            StandardHideDesktopIcons = true;
          };

          screencapture = {
            target = "clipboard";
            show-thumbnail = false;
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
              "/Applications/Ghostty.app"
              "/Applications/Bruno.app"
              "/Applications/Antigravity.app"
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
            "go-task/tap"
          ];

          casks = [
            "arc"
            "ghostty"
            "figma"
            "whatsapp"
            "leader-key"
            "discord"
            "android-commandlinetools"
            "orbstack"
            "windows-app"
            "bruno"
            "obsidian"
            "slack"
            "shortcat"
            "datagrip"
            "raycast"
            "flutter"
            "nikitabobko/tap/aerospace"
            "clockify"
            "crossover"
            "google-chrome"
            "gcloud-cli"
            "antigravity"
            "claude-code"
          ];

          brews = [
            "dashlane/tap/dashlane-cli"
            "FelixKratz/formulae/borders"
            "go-task/tap/go-task"
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
            "gemini-cli"
            "worktrunk"
            "ollama"
            "opencode"
            "rtk"
            "fish"
          ];

         masApps = {
            # Xcode = 497799835;
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
      darwinConfigurations.${hostname} = nix-darwin.lib.darwinSystem {
        modules = [
          configuration
          nix-homebrew.darwinModules.nix-homebrew
          {
            nix-homebrew = {
              enable = true;
              enableRosetta = true;
              user = username;
              autoMigrate = true;
            };
          }
        ];
      };
    };
}
