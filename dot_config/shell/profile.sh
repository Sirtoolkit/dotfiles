export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
[ ! -f "${XDG_CONFIG_HOME:-$HOME/.config}/shell/aliases.sh" ] || . "${XDG_CONFIG_HOME:-$HOME/.config}/shell/aliases.sh"

### Directory Colors
if [ -f "${XDG_CONFIG_HOME:-$HOME/.config}/shell/lscolors.sh" ]; then
	. "${XDG_CONFIG_HOME:-$HOME/.config}/shell/lscolors.sh"
fi

# Load mise and get dynamic paths
eval "$(mise activate zsh)"

# Flutter from mise
# export FLUTTER_ROOT=$(mise where flutter 2>/dev/null || echo "")
export FLUTTER_ROOT=$(mise where flutter 2>/dev/null || echo "")

# Android SDK from Homebrew (installed via Nix)
if [ -d "/opt/homebrew/share/android-commandlinetools" ]; then
	export ANDROID_HOME="/opt/homebrew/share/android-commandlinetools"
	export ANDROID_AVD_HOME="$HOME/.config/.android/avd"
	export PATH="$ANDROID_HOME/cmdline-tools/latest/bin:$PATH"
	export PATH="$ANDROID_HOME/platform-tools:$PATH"
	export PATH="$ANDROID_HOME/emulator:$PATH"
fi

# OrbStack
source ~/.orbstack/shell/init.zsh 2>/dev/null || :

# Dart
export PATH="$HOME/.pub-cache/bin:$PATH"

# PHP Composer
export PATH="$HOME/.config/composer/vendor/bin:$PATH"

# pnpm
export PNPM_HOME="$HOME/Library/pnpm"
export PATH="$PNPM_HOME:$PATH"

# Locale
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# Local binaries
export PATH="$HOME/.local/bin:$PATH"
