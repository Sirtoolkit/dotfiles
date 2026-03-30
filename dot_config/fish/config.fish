# System essentials
# Fast Homebrew detection
if test -d /opt/homebrew
    set -gx BREW_PREFIX /opt/homebrew
else if test -d /usr/local/bin/brew
    set -gx BREW_PREFIX /usr/local
else
    set -gx BREW_PREFIX (brew --prefix 2>/dev/null; or echo "/opt/homebrew")
end

set -gx HOMEBREW_PREFIX "$BREW_PREFIX"
set -gx HOMEBREW_CELLAR "$BREW_PREFIX/Cellar"
set -gx HOMEBREW_REPOSITORY "$BREW_PREFIX"
set -gx PATH "$BREW_PREFIX/bin" "$BREW_PREFIX/sbin" $PATH
set -gx MANPATH "$BREW_PREFIX/share/man" $MANPATH
set -gx INFOPATH "$BREW_PREFIX/share/info" $INFOPATH

# Add Homebrew paths
if test -n "$BREW_PREFIX"
    set -gx PATH "$BREW_PREFIX/opt/coreutils/libexec/gnubin" $PATH
end

# User profile
set -l config_home "$HOME/.config"
if set -q XDG_CONFIG_HOME
    set config_home "$XDG_CONFIG_HOME"
end

if test -f "$config_home/shell/profile.fish"
    source "$config_home/shell/profile.fish"
end

# Interactive-only tools initialization
if status is-interactive
    # zoxide - fast, load immediately
    command -v zoxide >/dev/null && zoxide init fish | source

    # direnv - needed for interactive shells
    command -v direnv >/dev/null && direnv hook fish | source

    # starship - prompt (load immediately, only ~3ms)
    command -v starship >/dev/null && starship init fish | source

    # atuin - lazy load on first up-arrow (avoids 7ms startup cost)
    function _atuin_lazy_init
        functions -e _atuin_lazy_init
        bind --erase \e'['A
        command -v atuin >/dev/null && atuin init fish | source
        commandline -f history-search-backward
    end
    bind \e'['A _atuin_lazy_init
end

function gcloud --wraps gcloud
    functions -e gcloud
    source "$BREW_PREFIX/share/google-cloud-sdk/path.fish.inc" 2>/dev/null
    gcloud $argv
end

# Anthropic API configuration
set -gx ANTHROPIC_AUTH_TOKEN ollama
set -gx ANTHROPIC_BASE_URL http://localhost:11434

# Claude alias con modelo seleccionado
function claude
    if test -f ~/.config/ollama/model
        set -l model (cat ~/.config/ollama/model)
        if test -n "$model"
            command claude --model "$model" $argv
            return
        end
    end
    echo "No hay modelo seleccionado. Usa 'olc' para seleccionar uno."
end
