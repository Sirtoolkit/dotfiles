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
              "/Applications/Hotspot Shield.app"
              "/Applications/WhatsApp.app"
              "/Applications/Bruno.app"
              "/Applications/Claude.app"
              "/Applications/Obsidian.app"
              "/Applications/Microsoft Teams.app"
              "/Applications/Ceryon.app"
              "/Applications/Brave Browser.app"
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
            # AltTab replaces Cmd+Tab (set as hold modifier via the blob in
            # postActivation below). `exceptions` hides apps from the switcher:
            # Simulator is ours; the rest mirror AltTab's built-in defaults.
            # NOTE: AltTab stores booleans/enums as *strings* and this list as a
            # JSON string; other types get silently reset to defaults.
            "com.lwouis.alt-tab-macos" = {
              exceptions = builtins.toJSON [
                { bundleIdentifier = "com.apple.iphonesimulator"; hide = "1"; ignore = "0"; }
                { bundleIdentifier = "com.apple.finder"; hide = "2"; ignore = "0"; }
                { bundleIdentifier = "com.apple.ScreenSharing"; hide = "0"; ignore = "2"; }
                { bundleIdentifier = "com.microsoft.rdc.macos"; hide = "0"; ignore = "2"; }
                { bundleIdentifier = "com.teamviewer.TeamViewer"; hide = "0"; ignore = "2"; }
                { bundleIdentifier = "org.virtualbox.app.VirtualBoxVM"; hide = "0"; ignore = "2"; }
                { bundleIdentifier = "com.parallels."; hide = "0"; ignore = "2"; }
                { bundleIdentifier = "com.citrix.XenAppViewer"; hide = "0"; ignore = "2"; }
                { bundleIdentifier = "com.citrix.receiver.icaviewer.mac"; hide = "0"; ignore = "2"; }
                { bundleIdentifier = "com.nicesoftware.dcvviewer"; hide = "0"; ignore = "2"; }
                { bundleIdentifier = "com.vmware.fusion"; hide = "0"; ignore = "2"; }
                { bundleIdentifier = "com.utmapp.UTM"; hide = "0"; ignore = "2"; }
                { bundleIdentifier = "com.McAfee.McAfeeSafariHost"; hide = "1"; ignore = "0"; }
              ];
            };
          };
        };

        # AltTab v11+ stores shortcuts as { string, secureData } where secureData is
        # an NSKeyedArchiver blob of SRShortcut — not expressible via
        # CustomUserPreferences (toPlist has no <data> type), so we write it here.
        # Blob = Shortcut(keyEquivalent: "⌘"), generated with AltTab's vendored
        # ShortcutRecorder (v11.3.0) and roundtrip-verified with its exact codec.
        # Result: holding ⌘ + Tab triggers AltTab, which swallows the event before
        # the native app switcher sees it.
        system.activationScripts.postActivation.text = ''
          launchctl asuser "$(id -u -- ${username})" sudo --user=${username} -- defaults write com.lwouis.alt-tab-macos holdShortcut '<dict><key>string</key><string>⌘</string><key>secureData</key><data>YnBsaXN0MDDUAQIDBAUGBwpYJHZlcnNpb25ZJGFyY2hpdmVyVCR0b3BYJG9iamVjdHMSAAGGoF8QD05TS2V5ZWRBcmNoaXZlctEICVRyb290gAGmCwwZGhscVSRudWxs1g0ODxAREhMUFRQXGF1tb2RpZmllckZsYWdzXxAbY2hhcmFjdGVyc0lnbm9yaW5nTW9kaWZpZXJzViRjbGFzc1pjaGFyYWN0ZXJzV2tleUNvZGVXdmVyc2lvboADgASABYAEgAKAABH//xIAEAAAUNIdHh8gWiRjbGFzc25hbWVYJGNsYXNzZXNaU1JTaG9ydGN1dKIfIVhOU09iamVjdAAIABEAGgAkACkAMgA3AEkATABRAFMAWgBgAG0AewCZAKAAqwCzALsAvQC/AMEAwwDFAMcAygDPANAA1QDgAOkA9AD3AAAAAAAAAgEAAAAAAAAAIgAAAAAAAAAAAAAAAAAAAQA=</data></dict>'
        '';

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
            "alt-tab"
            "whatsapp"
            "leader-key"
            "discord"
            "android-commandlinetools"
            "orbstack"
            "windows-app"
            "microsoft-teams"
            "bruno"
            "obsidian"
            "raycast"
            "flutter"
            "clockify"
            "google-drive"
            "gcloud-cli"
            "claude"
            "redis-insight"
            "lens"
            "brave-browser"
            # "google-chrome"
            # "ghostty"
            # "crossover"
            # "claude-code@latest"
            # "slack"
            # "datagrip"
          ];

          brews = [
            "dashlane/tap/dashlane-cli"
            "FelixKratz/formulae/borders"
            "go-task/tap/go-task"
            "Azure/kubelogin/kubelogin"
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
            "yazi"
            "lazygit"
            "neovim"
            "starship"
            "zoxide"
            "fzf"
            "eza"
            "ripgrep"
            "fd"
            "jq"
            "trash-cli"
            "diff-so-fancy"
            "git"
            "cocoapods"
            "act"
            "atuin"
            "carapace"
            "chezmoi"
            "tree-sitter"
            "openvpn"
            "worktrunk"
            "kanata"
            "rtk"
            "fish"
            "azure-cli"
            "kubectl"
            "appium"
            "herdr"
            "git-delta"
            # "pipx"
            # "lazyssh"
            # "tmux"
            # "fastlane"
            # "balena-cli"
            # "ollama"
            # "mas"
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
