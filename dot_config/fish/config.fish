# Nix environment (must load early)
if test -e /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish
    source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish
end

# Tools installed by nix-darwin live here. Keep this explicit so new shells can
# see systemPackages even if Nix's profile script does not prepend the path.
if test -d /run/current-system/sw/bin
    set -gx PATH /run/current-system/sw/bin $PATH
end

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
    # zoxide - avoid mise shims during startup; shims can resolve "latest" tools
    # over the network before the prompt is even shown.
    set -l zoxide_bin
    if test -x /run/current-system/sw/bin/zoxide
        set zoxide_bin /run/current-system/sw/bin/zoxide
    else if test -x "$BREW_PREFIX/bin/zoxide"
        set zoxide_bin "$BREW_PREFIX/bin/zoxide"
    else
        set -l mise_zoxide_bins "$HOME"/.local/share/mise/installs/zoxide/*/zoxide
        for candidate in $mise_zoxide_bins
            if test -x "$candidate"
                set zoxide_bin "$candidate"
                break
            end
        end
    end

    test -n "$zoxide_bin" && "$zoxide_bin" init fish | source

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
