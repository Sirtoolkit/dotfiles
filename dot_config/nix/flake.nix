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
      configuration = { pkgs, ... }: {
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
            persistent-apps = [
              "/Applications/Arc.app"
              "/Applications/Ghostty.app"
              "/Applications/Nix Apps/Zed.app"
              "/Applications/Nix Apps/GitKraken.app"
              "/Applications/Nix Apps/Postman.app"
              "/Applications/Nix Apps/Obsidian.app"
            ];
          };
        };

        environment.systemPackages = with pkgs; [
          aerospace
          gitkraken
          postman
          obsidian
          orbstack
          slack
          shortcat
          jetbrains.datagrip
          google-cloud-sdk
          devpod
          raycast
          zed-editor

          # --- Core & Shell ---
          coreutils
          findutils
          wget
          btop
          tree
          bat
          tldr
          trash-cli
          topgrade

          # --- Desarrollo & Git ---
          git
          commitizen
          cloc
          mise

          # --- macOS Específico ---
          mas
          pam-reattach

          # --- Lenguajes & Frameworks ---
          cocoapods
          fastlane

          # --- Herramientas Específicas ---
          qmk
        ];

        # security.pam.enableSudoTouchIdAuth = true;

        homebrew = {
          enable = true;
          taps = [ 
            "dashlane/tap" 
            "FelixKratz/formulae" 
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
          ];
          brews = [ "dashlane-cli" "mole" "borders" ];
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
