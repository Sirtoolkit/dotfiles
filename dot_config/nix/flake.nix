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
      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
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
          # 65: Finder Search Window (Option + Cmd + Space) - Opcional
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
       controlcenter= {
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
         NSAutomaticWindowAnimationsEnabled= false;
	 AppleKeyboardUIMode = 3;
       };
    
       dock.autohide = true;
       dock.expose-group-apps = false;
       dock.show-recents = false;
       dock.orientation = "left";
       dock.persistent-apps = [
         {
           app = "/Applications/Arc.app";
         }
         {
           app = "/Applications/Ghostty.app";
         }
         {
           app = "/Applications/Nix Apps/Zed.app";
         }
         {
           app = "/Applications/Nix Apps/GitKraken.app";
         }
         {
           app = "/Applications/Nix Apps/Postman.app";
         }
         {
           app = "/Applications/Nix Apps/Obsidian.app";
         }
      ];

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
	   tldr      # manuales simplificados
	   trash-cli # para no usar rm y perder archivos
	   topgrade  # actualizador universal
	  
	   # --- Desarrollo & Git ---
	   git
	   commitizen
	   cloc      # contar líneas de código
	   mise      # gestor de versiones (alternativa a asdf)
	  
	   # --- macOS Específico ---
	   mas           # Mac App Store CLI
	   pam-reattach  # CRUCIAL: Permite usar TouchID dentro de tmux
	  
	   # --- Lenguajes & Frameworks ---
	   cocoapods     # Gestión de dependencias Swift/Obj-C
	   fastlane      # Automatización iOS/Android
	  
	   # --- Herramientas Específicas ---
	   qmk           # Firmware teclados
    ];

      # security.pam.enableSudoTouchIdAuth = true;

      homebrew.enable = true;
      homebrew.taps = [ { name = "dashlane/tap"; } { name = "FelixKratz/formulae"; }];
      homebrew.casks = [ "arc" "ghostty" "figma" "whatsapp" "microsoft-excel" "leader-key" "discord" "android-commandlinetools"];
      homebrew.brews = [ "dashlane-cli" "mole" "composer" "php" "borders"];

      homebrew.masApps = { 
       Xcode = 497799835;
       Transporter = 1450874784;
       Hotspot-Shield = 771076721;
      };

      homebrew.onActivation = { autoUpdate = true; upgrade = true;  cleanup = "zap";  };

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      # Enable alternative shell support in nix-darwin.
      # programs.fish.enable = true;

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 6;

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "aarch64-darwin";
    };
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#Cesars-MacBook-Pro
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
