# XDG Config Home
set -l config_home "$HOME/.config"
if set -q XDG_CONFIG_HOME
    set config_home "$XDG_CONFIG_HOME"
end
set -gx XDG_CONFIG_HOME "$config_home"

# mise activation
if command -v mise >/dev/null
    # Always add shims to PATH
    set -gx MISE_FISH_AUTO_ACTIVATE 0
    set -gx PATH "$HOME/.local/share/mise/shims" $PATH

    # Use shims only. Full activation installs command-not-found hooks that can
    # resolve "latest" tool versions over the network while rendering prompts.
    if status is-interactive
        command mise activate fish --shims | source
    else
        # Keep non-interactive shells cheap and deterministic.
        function mise --wraps mise
            functions -e mise
            command mise $argv
        end
    end
end

if status is-interactive; and test -f "$config_home/shell/aliases.fish"
    source "$config_home/shell/aliases.fish"
end

# Flutter root (lazy function)
function flutter --wraps flutter
    functions -e flutter
    set -gx FLUTTER_ROOT (mise where flutter 2>/dev/null; or echo "")
    command flutter $argv
end

# Android SDK from Homebrew
if test -d /opt/homebrew/share/android-commandlinetools
    set -gx ANDROID_HOME /opt/homebrew/share/android-commandlinetools
    set -gx ANDROID_AVD_HOME "$HOME/.config/.android/avd"
    set -gx PATH "$ANDROID_HOME/cmdline-tools/latest/bin" $PATH
    set -gx PATH "$ANDROID_HOME/platform-tools" $PATH
    set -gx PATH "$ANDROID_HOME/emulator" $PATH
end

# Shorebird
set -l shorebird_home "$HOME/.config/shorebird"
if set -q XDG_CONFIG_HOME
    set shorebird_home "$XDG_CONFIG_HOME/shorebird"
end
set -gx PATH "$shorebird_home/bin" "$HOME/.shorebird/bin" $PATH

# Dart
set -gx PATH "$HOME/.pub-cache/bin" $PATH

# PHP Composer
set -gx PATH "$HOME/.config/composer/vendor/bin" $PATH

# pnpm
set -gx PNPM_HOME "$HOME/Library/pnpm"
set -gx PATH "$PNPM_HOME/bin" $PATH

# Locale
set -gx LANG en_US.UTF-8
set -gx LC_ALL en_US.UTF-8

# Local binaries
set -gx PATH "$HOME/.local/bin" $PATH
