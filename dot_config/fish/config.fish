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

# Tools initialization (optimized loop)
for tool in zoxide direnv starship atuin
    if command -v $tool >/dev/null
        switch $tool
            case zoxide
                zoxide init fish | source
            case direnv
                direnv hook fish | source
            case starship
                starship init fish | source
            case atuin
                atuin init fish | source
        end
    end
end

function gcloud --wraps gcloud
    functions -e gcloud
    source "$BREW_PREFIX/share/google-cloud-sdk/path.fish.inc" 2>/dev/null
    gcloud $argv
end
