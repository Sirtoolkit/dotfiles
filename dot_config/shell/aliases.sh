alias zshconfig="nvim ~/.zshrc"
alias ohmyzsh="nvim ~/.oh-my-zsh"
alias v="nvim"
alias zsource='source ~/.zshrc'
alias gdu='gdu-go'

alias ls="eza -l --icons=always -m -n -l"
alias l="eza -l --icons=always -m -n -l -a"
alias ll="eza -l --icons=always -m -n -l"

alias dbb="flutter clean && dart run build_runner build -d"
alias dbw="flutter clean && dart run build_runner watch -d"

alias mkdir='mkdir -pv'

alias Applications='cd $HOME/Applications'
alias Cloud='cd $HOME/Cloud'
alias Config='cd $HOME/.config'
alias Desktop='cd $HOME/Desktop'
alias Downloads='cd $HOME/Downloads'
alias Library='cd $HOME/Library'
alias Local='cd $HOME/.local'
alias Movies='cd $HOME/Movies'
alias Music='cd $HOME/Music'
alias Pictures='cd $HOME/Pictures'
alias Public='cd $HOME/Public'

dgrep() {
  als | grep "$@"
}
 
mise-purge-all() {
    echo -e "\n\033[1;31mADVERTENCIA:\033[0m Esta acción eliminará todas las herramientas gestionadas por mise y la carpeta ~/.local/share/mise."
    echo "Esta acción no se puede deshacer."
    echo -n "¿Estás seguro de que quieres continuar? (escribe 'si' para confirmar): "
    read CONFIRM
    if [[ "$CONFIRM" == "si" ]]; then
        echo -e "\nProcediendo con la eliminación de herramientas gestionadas por mise..."
        if command -v mise &>/dev/null && command -v jq &>/dev/null; then
            TOOLS_JSON=$(mise list --json 2>/dev/null)
            if [[ $? -eq 0 ]]; then
                TOOLS=$(echo "$TOOLS_JSON" | jq -r '.[] | .plugin + "/" + .version' 2>/dev/null)
                if [[ $? -eq 0 && -n "$TOOLS" ]]; then
                    echo -e "\nHerramientas instaladas con mise:"
                    echo "$TOOLS"
                else
                    echo "No hay herramientas instaladas con mise."
                fi
            else
                echo "No hay herramientas instaladas con mise."
            fi
        else
            echo "No se pudo verificar herramientas instaladas (falta 'mise' o 'jq')."
        fi
        echo -e "\nEliminando la carpeta ~/.local/share/mise..."
        rm -rf ~/.local/share/mise
        echo -e "\n\033[1;32m¡Carpeta eliminada!\033[0m"
    else
        echo -e "\n\033[1;32mOperación cancelada.\033[0m No se ha eliminado nada."
    fi
}

brew-purge-formula() {
    echo "\n\033[1;31mADVERTENCIA:\033[0m Estás a punto de eliminar TODAS las fórmulas (paquetes) instaladas con Homebrew."
    echo "Esta acción no se puede deshacer."
    echo -n "¿Estás seguro de que quieres continuar? (escribe 'si' para confirmar): "
    read CONFIRM
    if [[ "$CONFIRM" == "si" ]]; then
        echo "\nProcediendo con la eliminación de fórmulas..."
        echo "\n\033[1;33m=> Desinstalando Fórmulas...\033[0m"
        if brew list --formula &>/dev/null; then
            brew remove --force --ignore-dependencies $(brew list --formula)
        else
            echo "No hay fórmulas para desinstalar."
        fi
        echo "\n\033[1;32m¡Proceso completado!\033[0m"
        echo "Se recomienda ejecutar 'brew cleanup' para borrar archivos en caché."
    else
        echo "\n\033[1;32mOperación cancelada.\033[0m No se ha eliminado nada."
    fi
}

brew-purge-cask() {
    echo "\n\033[1;31mADVERTENCIA:\033[0m Estás a punto de eliminar TODOS los casks (aplicaciones) instalados con Homebrew."
    echo "Esta acción no se puede deshacer."
    echo -n "¿Estás seguro de que quieres continuar? (escribe 'si' para confirmar): "
    read CONFIRM
    if [[ "$CONFIRM" == "si" ]]; then
        echo "\nProcediendo con la eliminación de casks..."
        echo "\n\033[1;33m=> Desinstalando Casks (Aplicaciones)...\033[0m"
        if brew list --cask &>/dev/null; then
            brew uninstall --cask --force --ignore-dependencies $(brew list --cask)
        else
            echo "No hay casks para desinstalar."
        fi
        echo "\n\033[1;32m¡Proceso completado!\033[0m"
        echo "Se recomienda ejecutar 'brew cleanup' para borrar archivos en caché."
    else
        echo "\n\033[1;32mOperación cancelada.\033[0m No se ha eliminado nada."
    fi
}

mas-purge-all() {
    # Primero, comprueba si el comando 'mas' está disponible
    if ! command -v mas &>/dev/null; then
        echo "\n\033[1;31mError:\033[0m El comando 'mas' no está instalado."
        echo "Por favor, instálalo con 'brew install mas' y vuelve a intentarlo."
        return 1
    fi

    # Muestra un mensaje de advertencia claro
    echo "\n\033[1;31mADVERTENCIA:\033[0m Estás a punto de eliminar TODAS las aplicaciones instaladas desde la Mac App Store (Pages, Numbers, etc.)."
    echo "Esta acción no se puede deshacer."
    
    # Pide confirmación al usuario (forma compatible con Zsh y Bash)
    echo -n "¿Estás seguro de que quieres continuar? (escribe 'si' para confirmar): "
    read CONFIRM
    
    # Comprueba si la confirmación es correcta
    if [[ "$CONFIRM" == "si" ]]; then
        echo "\nProcediendo con la eliminación de aplicaciones de la App Store..."
        
        # Obtiene la lista de IDs de las apps y las desinstala una por una
        # Usamos 'awk' para extraer solo la primera columna (el ID de la app)
        if mas list &>/dev/null; then
            mas list | awk '{print $1}' | xargs -n 1 mas uninstall
            echo "\n\033[1;32m¡Proceso completado!\033[0m"
        else
            echo "No hay aplicaciones de la Mac App Store para desinstalar."
        fi

    else
        echo "\n\033[1;32mOperación cancelada.\033[0m No se ha eliminado ninguna aplicación."
    fi
}