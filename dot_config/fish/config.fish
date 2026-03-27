# System essentials
# Setup brew (cached for speed - 24h)
set -l cache_dir "$HOME/.cache/fish"
set -l BREW_PREFIX_CACHE "$cache_dir/brew_prefix"

if test -r "$BREW_PREFIX_CACHE"
    set -l cache_mtime (stat -f%m "$BREW_PREFIX_CACHE" 2>/dev/null; or echo 0)
    set -l now (date +%s)
    set -l cache_age (math $now - $cache_mtime)
    if test $cache_age -lt 86400
        set -gx BREW_PREFIX (cat "$BREW_PREFIX_CACHE")
    else
        set -gx BREW_PREFIX (brew --prefix 2>/dev/null; or echo "/opt/homebrew")
        mkdir -p "$cache_dir"
        echo "$BREW_PREFIX" > "$BREW_PREFIX_CACHE"
    end
else
    set -gx BREW_PREFIX (brew --prefix 2>/dev/null; or echo "/opt/homebrew")
    mkdir -p "$cache_dir"
    echo "$BREW_PREFIX" > "$BREW_PREFIX_CACHE"
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

# History
# fish_history is the session name (default: "fish"), not a path
# History files are stored in ~/.local/share/fish/fish_history by default

# Custom aliases
if test -f "$config_home/shell/aliases.fish"
    source "$config_home/shell/aliases.fish"
end

# zoxide
if command -v zoxide >/dev/null
    zoxide init fish | source
end

# direnv
if command -v direnv >/dev/null
    direnv hook fish | source
end

# PostgreSQL
set -gx PATH "/opt/homebrew/opt/postgresql@17/bin" $PATH

# Lazy loading for heavy commands
function aws --wraps aws
    functions -e aws
    eval (aws --cli-auto-prompt 2>/dev/null)
    aws $argv
end

function gcloud --wraps gcloud
    functions -e gcloud
    source "$BREW_PREFIX/share/google-cloud-sdk/path.fish.inc" 2>/dev/null
    gcloud $argv
end

# Starship
if command -v starship >/dev/null
    starship init fish | source
end

# Atuin - Shell History
if command -v atuin >/dev/null
    atuin init fish | source
end