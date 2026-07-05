function purge-everything
    # =============================================================================
    # purge-everything
    # Modo nuclear: elimina configuraciones, cachés, historiales y datos de apps
    # gestionadas por el dotfiles de chezmoi. Requiere confirmación explícita.
    #
    # Uso:
    #   purge-everything              Modo interactivo estándar
    #   purge-everything --dry-run    Muestra TODO lo que borraría sin tocar nada
    #   purge-everything --include-nix        También intenta desinstalar Nix/nix-darwin
    #   purge-everything --include-karabiner  También ejecuta purge-karabiner
    # =============================================================================

    set -l dry_run 0
    set -l include_nix 0
    set -l include_karabiner 0

    for arg in $argv
        switch $arg
            case --dry-run
                set dry_run 1
            case --include-nix
                set include_nix 1
            case --include-karabiner
                set include_karabiner 1
            case --help -h
                _purge_everything_help
                return 0
            case '*'
                echo -e "\033[1;31mError:\033[0m Opción desconocida: $arg"
                _purge_everything_help
                return 1
        end
    end

    if test (id -u) -eq 0
        echo -e "\033[1;31mError:\033[0m No ejecutes esto como root."
        return 1
    end

    # -------------------------------------------------------------------------
    # Listas de eliminación
    # -------------------------------------------------------------------------

    # Carpetas XDG / home principales
    set -l xdg_paths \
        ~/.config \
        ~/.cache \
        ~/.local

    # Archivos sueltos en $HOME
    set -l home_files \
        ~/.bashrc \
        ~/.zshrc \
        ~/.tmux \
        ~/.tmux.conf \
        ~/.zsh_history \
        ~/.bash_history \
        ~/.zoxide \
        ~/.opencommit \
        ~/.dcli \
        ~/.npm \
        ~/.yarn \
        ~/.pnpm-store \
        ~/Library/pnpm \
        ~/.gradle \
        ~/.pub-cache \
        ~/.android \
        ~/.cocoapods \
        ~/.pod \
        ~/.fastlane \
        ~/.ollama \
        ~/.claude \
        ~/.claude-code \
        ~/.shorebird \
        ~/.expo \
        ~/.aerospace.toml \
        ~/.flutter-tool-settings \
        ~/.dart \
        ~/.mason \
        ~/.kube \
        ~/.docker \
        ~/.bundle \
        ~/.gem \
        ~/.nix-profile \
        ~/.nix-defexpr \
        ~/.nix-channels

    # Application Support de apps gestionadas (Casks, MAS, dev)
    set -l app_support_paths \
        ~/Library/Application\ Support/Arc \
        ~/Library/Application\ Support/com.mitchellh.ghostty \
        ~/Library/Application\ Support/discord \
        ~/Library/Application\ Support/Slack \
        ~/Library/Application\ Support/com.tinyspeck.slackmacgap \
        ~/Library/Application\ Support/Raycast \
        ~/Library/Application\ Support/bruno \
        ~/Library/Application\ Support/Google/Chrome \
        ~/Library/Application\ Support/BraveSoftware \
        ~/Library/Application\ Support/JetBrains/DataGrip \
        ~/Library/Application\ Support/io.flutter \
        ~/Library/Application\ Support/CrossOver \
        ~/Library/Application\ Support/Clockify \
        ~/Library/Application\ Support/Bitwarden \
        ~/Library/Application\ Support/Transporter \
        ~/Library/Application\ Support/Claude \
        ~/Library/Application\ Support/RedisInsight \
        ~/Library/Application\ Support/Lens \
        ~/Library/Application\ Support/Google/Drive \
        ~/Library/Application\ Support/Microsoft/Teams \
        ~/Library/Application\ Support/WhatsApp \
        ~/Library/Application\ Support/com.lwouis.alt-tab-macos

    # Preferencias de apps gestionadas
    set -l prefs_paths \
        ~/Library/Preferences/company.thebrowser.Browser.plist \
        ~/Library/Preferences/com.hnc.Discord.plist \
        ~/Library/Preferences/com.tinyspeck.slackmacgap.plist \
        ~/Library/Preferences/com.raycast.macos.plist \
        ~/Library/Preferences/com.google.Chrome.plist \
        ~/Library/Preferences/com.brave.Browser.plist \
        ~/Library/Preferences/com.anthropic.claude.plist \
        ~/Library/Preferences/com.microsoft.teams.plist \
        ~/Library/Preferences/com.lwouis.alt-tab-macos.plist \
        ~/Library/Preferences/com.apple.itunes.transporter.plist \
        ~/Library/Preferences/com.whatsapp.WhatsApp.plist

    # Cachés y logs del usuario
    set -l cache_log_paths \
        ~/Library/Caches \
        ~/Library/Logs

    set -l all_paths $xdg_paths $home_files $app_support_paths $prefs_paths $cache_log_paths

    # -------------------------------------------------------------------------
    # Encabezado
    # -------------------------------------------------------------------------
    echo -e "\n\033[1;31m⚠️  MODO NUCLEAR ACTIVADO ⚠️\033[0m"
    echo -e "\n\033[1;31mADVERTENCIA:\033[0m Esta acción eliminará COMPLETAMENTE:"
    echo "  • ~/.config, ~/.cache y ~/.local (carpetas completas)"
    echo "  • Shell configs: ~/.bashrc, ~/.zshrc, ~/.tmux, ~/.tmux.conf"
    echo "  • Historiales: zsh, bash, atuin, fish, etc."
    echo "  • Configs de casks activas: Arc, Brave, Raycast, Claude, Discord, Bruno, etc."
    echo "  • Configs de casks usadas antes: Chrome, Ghostty, Slack, DataGrip, CrossOver, Bitwarden, etc."
    echo "  • Configs de dev tools: Android, Flutter, Cocoapods, PNPM, Yarn, Expo, Shorebird, Docker, K8s, etc."
    echo "  • Cachés y logs de usuario: ~/Library/Caches y ~/Library/Logs"

    if test $include_nix -eq 1
        echo -e "  • \033[1;31mNix / nix-darwin (desinstalación completa con sudo)\033[0m"
    else
        echo -e "  \033[1;33m• Nix / nix-darwin NO se tocará (usa --include-nix si lo deseas)\033[0m"
    end

    if test $include_karabiner -eq 1
        echo -e "  • \033[1;31mKarabiner-VirtualHIDDevice (vía purge-karabiner, requiere sudo)\033[0m"
    else
        echo -e "  \033[1;33m• Karabiner-VirtualHIDDevice NO se tocará (usa --include-karabiner si lo deseas)\033[0m"
    end

    echo -e "\n\033[1;31mEsto dejará tu sistema como recién instalado.\033[0m"
    echo "Esta acción no se puede deshacer."

    if test $dry_run -eq 1
        echo -e "\n\033[1;34m[DRY RUN] Se habrían eliminado los siguientes elementos existentes:\033[0m"
        for p in $all_paths
            if test -e "$p"
                echo "  - $p"
            end
        end
        echo -e "\n\033[1;32m[DRY RUN] No se ha eliminado nada.\033[0m"
        return 0
    end

    echo -n "Escribe 'borrar-todo' para confirmar: "
    read CONFIRM

    if test "$CONFIRM" != borrar-todo
        echo -e "\n\033[1;32mOperación cancelada.\033[0m No se ha eliminado nada."
        return 0
    end

    # -------------------------------------------------------------------------
    # Eliminación
    # -------------------------------------------------------------------------
    echo -e "\n\033[1;33m=> Eliminando carpetas XDG principales...\033[0m"
    for p in $xdg_paths
        if test -e "$p"
            rm -rf "$p"
        end
    end
    echo "   ✓ ~/.config, ~/.cache, ~/.local"

    echo -e "\n\033[1;33m=> Eliminando archivos de configuración en $HOME...\033[0m"
    for p in $home_files
        if test -e "$p"
            rm -rf "$p"
        end
    end
    echo "   ✓ Dotfiles y datos de dev tools en $HOME"

    echo -e "\n\033[1;33m=> Eliminando configs de apps (Casks, MAS, dev tools)...\033[0m"
    for p in $app_support_paths
        if test -e "$p"
            rm -rf "$p"
        end
    end
    echo "   ✓ Application Support"

    echo -e "\n\033[1;33m=> Eliminando preferencias de apps...\033[0m"
    for p in $prefs_paths
        if test -e "$p"
            rm -rf "$p"
        end
    end
    echo "   ✓ Preferences .plist"

    echo -e "\n\033[1;33m=> Eliminando cachés y logs de usuario...\033[0m"
    for p in $cache_log_paths
        if test -e "$p"
            rm -rf "$p"
        end
    end
    echo "   ✓ ~/Library/Caches y ~/Library/Logs"

    # -------------------------------------------------------------------------
    # Opcionales: Nix y Karabiner
    # -------------------------------------------------------------------------
    if test $include_nix -eq 1
        echo -e "\n\033[1;33m=> Desinstalando Nix / nix-darwin...\033[0m"
        _purge_everything_nix
    end

    if test $include_karabiner -eq 1
        echo -e "\n\033[1;33m=> Ejecutando purge-karabiner...\033[0m"
        if functions --query purge-karabiner
            purge-karabiner
        else
            echo -e "\033[1;33m  ⚠ purge-karabiner no está disponible en este shell.\033[0m"
            echo "     Ejecútalo manualmente o recarga fish: source ~/.config/fish/config.fish"
        end
    end

    echo -e "\n\033[1;32m🔥 ¡TODO HA SIDO ELIMINADO! 🔥\033[0m"
    echo "Tu sistema está limpio."
    echo "Restaura con: chezmoi init --apply Sirtoolkit"

    if test $include_nix -eq 0
        echo -e "\n\033[1;33mNota:\033[0m Nix / nix-darwin sigue instalado. Para eliminarlo ejecuta:"
        echo "  sudo /nix/nix-installer uninstall   # si usaste el instalador determinado"
        echo "  # o revisa: https://nixos.org/manual/nix/stable/installation/uninstall.html"
    end

    if test $include_karabiner -eq 0
        echo -e "\n\033[1;33mNota:\033[0m Karabiner-VirtualHIDDevice sigue instalado. Para eliminarlo ejecuta:"
        echo "  purge-karabiner"
    end

    echo -e "\n\033[1;33mNota:\033[0m Este script solo borra configs y datos. Si también quieres desinstalar"
    echo "  las aplicaciones de Homebrew / Mac App Store, ejecuta después:"
    echo "    purge-brew-apps && purge-brew-pkgs && purge-mas"
end

function _purge_everything_help
    echo "Uso: purge-everything [opciones]"
    echo ""
    echo "Opciones:"
    echo "  --dry-run              Muestra todo lo que se eliminaría sin borrar nada"
    echo "  --include-nix          También desinstala Nix / nix-darwin (requiere sudo)"
    echo "  --include-karabiner    También ejecuta purge-karabiner (requiere sudo)"
    echo "  -h, --help             Muestra esta ayuda"
    echo ""
    echo "Ejemplo:"
    echo "  purge-everything --dry-run"
    echo "  purge-everything --include-nix --include-karabiner"
end

function _purge_everything_nix
    # Desinstalación segura de Nix en macOS.
    # Si existe el desinstalador determinado, úsalo; si no, deja instrucciones.
    if test -x /nix/nix-installer
        echo "  Usando /nix/nix-installer uninstall..."
        sudo /nix/nix-installer uninstall || begin
            echo -e "\033[1;33m  ⚠ El desinstalador de Nix falló.\033[0m"
            echo "     Continúa manualmente con: sudo /nix/nix-installer uninstall"
        end
    else
        echo -e "\033[1;33m  ⚠ No se detectó /nix/nix-installer.\033[0m"
        echo "     Nix fue instalado con el instalador clásico; la desinstalación es manual:"
        echo "       sudo rm -rf /etc/nix /var/root/.nix-* /nix"
        echo "       sudo rm -f /Library/LaunchDaemons/org.nixos.*"
        echo "     También revisa: https://nixos.org/manual/nix/stable/installation/uninstall.html"
    end
end
