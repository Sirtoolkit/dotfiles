# XDG Config Home
set -l config_home "$HOME/.config"
if set -q XDG_CONFIG_HOME
    set config_home "$XDG_CONFIG_HOME"
end
set -gx XDG_CONFIG_HOME "$config_home"

# mise activation (lazy load to avoid 44ms startup cost)
if command -v mise > /dev/null
    # Only set PATH and basic env, defer full activation
    set -gx MISE_FISH_AUTO_ACTIVATE 0
    set -gx PATH "$HOME/.local/share/mise/shims" $PATH

    # Lazy load mise on first use
    function mise --wraps mise
        functions -e mise
        # Now do the real activation
        eval (command mise activate fish)
        command mise $argv
    end
end

# Flutter root (lazy function)
function flutter --wraps flutter
    functions -e flutter
    set -gx FLUTTER_ROOT (mise where flutter 2>/dev/null; or echo "")
    command flutter $argv
end

# Android SDK from Homebrew
if test -d "/opt/homebrew/share/android-commandlinetools"
    set -gx ANDROID_HOME "/opt/homebrew/share/android-commandlinetools"
    set -gx ANDROID_AVD_HOME "$HOME/.config/.android/avd"
    set -gx PATH "$ANDROID_HOME/cmdline-tools/latest/bin" $PATH
    set -gx PATH "$ANDROID_HOME/platform-tools" $PATH
    set -gx PATH "$ANDROID_HOME/emulator" $PATH
end

# OrbStack lazy load
function orb --wraps orb
    functions -e orb
    source ~/.orbstack/shell/init.fish 2>/dev/null; or true
    orb $argv
end

# Dart
set -gx PATH "$HOME/.pub-cache/bin" $PATH

# PHP Composer
set -gx PATH "$HOME/.config/composer/vendor/bin" $PATH

# pnpm
set -gx PNPM_HOME "$HOME/Library/pnpm"
set -gx PATH "$PNPM_HOME" $PATH

# Locale
set -gx LANG en_US.UTF-8
set -gx LC_ALL en_US.UTF-8

# Local binaries
set -gx PATH "$HOME/.local/bin" $PATH