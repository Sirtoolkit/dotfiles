export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
[ ! -f "${XDG_CONFIG_HOME:-$HOME/.config}/shell/aliases.sh" ] || . "${XDG_CONFIG_HOME:-$HOME/.config}/shell/aliases.sh"

### Directory Colors
if [ -f "${XDG_CONFIG_HOME:-$HOME/.config}/shell/lscolors.sh" ]; then
  . "${XDG_CONFIG_HOME:-$HOME/.config}/shell/lscolors.sh"
fi

# Set PATH, MANPATH, etc., for Homebrew.
eval "$(/opt/homebrew/bin/brew shellenv)"

# Added by Toolbox App
export PATH="$PATH:/Users/cesarleonardo/Library/Application Support/JetBrains/Toolbox/scripts"
export FLUTTER_ROOT=$(mise where flutter)

# Configure ANDROID common paths
# export ANDROID_HOME="/opt/homebrew/share/android-commandlinetools"
# export PATH="$ANDROID_HOME/tools:$PATH"
# export PATH="$ANDROID_HOME/tools/bin:$PATH"
# export PATH="$ANDROID_HOME/platform-tools:$PATH"
# export PATH="$ANDROID_HOME/emulator:$PATH"

source ~/.orbstack/shell/init.zsh 2>/dev/null || :

# Dart
export PATH="$HOME/.pub-cache/bin:$PATH"

export SSH_AUTH_SOCK=~/.1password/agent.sock

export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

export PATH="$HOME/.local/bin:$PATH"

### cd aliases
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

alias zshconfig="nvim ~/.zshrc"
alias ohmyzsh="nvim ~/.oh-my-zsh"
alias v="nvim"
alias zsource='source ~/.zshrc'
alias gdu='gdu-go'

alias dbb="flutter clean && dart run build_runner build -d"
alias dbw="flutter clean && dart run build_runner watch -d"

alias mkdir='mkdir -pv'

dgrep() {
  als | grep "$@"
}

# Alias seguro para eliminar todos los paquetes y aplicaciones de Homebrew (VERSIÓN CORREGIDA PARA ZSH/BASH)
brew-purge-all() {
    # Muestra un mensaje de advertencia claro
    echo "\n\033[1;31mADVERTENCIA:\033[0m Estás a punto de eliminar TODOS los paquetes y aplicaciones instalados con Homebrew."
    echo "Esta acción no se puede deshacer."
    
    # Pide confirmación al usuario (forma compatible con Zsh y Bash)
    echo -n "¿Estás seguro de que quieres continuar? (escribe 'si' para confirmar): "
    read CONFIRM
    
    # Comprueba si la confirmación es correcta
    if [[ "$CONFIRM" == "si" ]]; then
        echo "\nProcediendo con la eliminación..."
        
        # Elimina las fórmulas
        echo "\n\033[1;33m=> Desinstalando Fórmulas...\033[0m"
        if brew list --formula &>/dev/null; then
            brew remove --force $(brew list --formula)
        else
            echo "No hay fórmulas para desinstalar."
        fi
        
        # Elimina los casks
        echo "\n\033[1;33m=> Desinstalando Casks (Aplicaciones)...\033[0m"
        if brew list --cask &>/dev/null; then
            brew uninstall --cask --force $(brew list --cask)
        else
            echo "No hay casks para desinstalar."
        fi

        echo "\n\033[1;32m¡Proceso completado!\033[0m"
        echo "Se recomienda ejecutar 'brew cleanup' para borrar archivos en caché."

    else
        echo "\n\033[1;32mOperación cancelada.\033[0m No se ha eliminado nada."
    fi
}