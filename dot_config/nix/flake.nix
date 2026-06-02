{
  description = "Example nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
    brew-src = {
      url = "github:Homebrew/brew/5.1.10";
      flake = false;
    };
    nix-homebrew.inputs.brew-src.follows = "brew-src";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, nix-homebrew, ... }:
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
            AppleSpacesSwitchOnActivate = false;
          };

          trackpad = {
            TrackpadThreeFingerHorizSwipeGesture = 0;
            TrackpadFourFingerHorizSwipeGesture = 0;
          };

          dock = {
            autohide = true;
            expose-group-apps = false;
            mru-spaces = false;
            show-recents = false;
            orientation = "left";
            tilesize = 48;
            persistent-apps = [
              "/Applications/Bruno.app"
              "/Applications/Obsidian.app"
              "/Applications/Hotspot Shield.app"
              "/Applications/WhatsApp.app"
              "/Applications/Brave Browser.app"
              "/Applications/DataGrip.app"
              "/Applications/Claude.app"
              "/Applications/Ghostty.app"
              "/Applications/Microsoft Teams.app"
            ];
          };

          CustomUserPreferences = {
            "com.apple.symbolichotkeys" = {
              AppleSymbolicHotKeys = {
                "36" = { enabled = false; };
                "37" = { enabled = false; };
                "64" = { enabled = false; };
                "65" = { enabled = false; };
                "32" = { enabled = false; };
                "33" = { enabled = false; };
                "79" = { enabled = false; };
                "81" = { enabled = false; };
                "118" = { enabled = false; };
                "119" = { enabled = false; };
                "120" = { enabled = false; };
                "121" = { enabled = false; };
              };
            };
            "com.apple.dock" = {
              workspaces-auto-swoosh = false;
            };
          };
        };

        environment.systemPackages = with pkgs; [
          qmk
        ];

        homebrew = {
          enable = true;
          taps = [
            "nikitabobko/tap"
            "azure/kubelogin"
          ];

          casks = [
            "nikitabobko/tap/aerospace"
            "ghostty"
            "whatsapp"
            "leader-key"
            "discord"
            "android-commandlinetools"
            "orbstack"
            "windows-app"
            "microsoft-teams"
            "bruno"
            "obsidian"
            "slack"
            "datagrip"
            "raycast"
            "flutter"
            "clockify"
            "crossover"
            "google-chrome"
            "google-drive"
            "gcloud-cli"
            "claude-code@latest"
            "claude"
            "redis-insight"
            "lens"
            "brave-browser"
          ];

          brews = [
            "dashlane/tap/dashlane-cli"
            "FelixKratz/formulae/borders"
            "go-task/tap/go-task"
            "Azure/kubelogin/kubelogin"
            "kopecmaciej/vi-mongo/vi-mongo"
            "lazysql"
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
            "diff-so-fancy"
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
            "worktrunk"
            "ollama"
            "kanata"
            "rtk"
            "fish"
            "azure-cli"
            "kubectl"
            "appium"
            "herdr"
            "git-delta"
          ];

         masApps = {
            # Xcode = 497799835;
            # Transporter = 1450874784;
            # Hotspot-Shield = 771076721;
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
              package = inputs.brew-src // {
                name = "brew-5.1.10";
                version = "5.1.10";
              };
              user = username;
              autoMigrate = true;
            };
          }
        ];
      };
    };
}
