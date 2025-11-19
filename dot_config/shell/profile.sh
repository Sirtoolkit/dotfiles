export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
[ ! -f "${XDG_CONFIG_HOME:-$HOME/.config}/shell/aliases.sh" ] || . "${XDG_CONFIG_HOME:-$HOME/.config}/shell/aliases.sh"

### Directory Colors
if [ -f "${XDG_CONFIG_HOME:-$HOME/.config}/shell/lscolors.sh" ]; then
	. "${XDG_CONFIG_HOME:-$HOME/.config}/shell/lscolors.sh"
fi

eval "$(mise activate zsh)"
eval "$(/opt/homebrew/bin/brew shellenv)"

# Added by Toolbox App
export FLUTTER_ROOT=$(mise where flutter)

export ANDROID_HOME="/opt/homebrew/share/android-commandlinetools"
export ANDROID_AVD_HOME="$HOME/.config/.android/avd"

export PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin
export PATH=$PATH:$ANDROID_HOME/platform-tools
export PATH=$PATH:$ANDROID_HOME/emulator

source ~/.orbstack/shell/init.zsh 2>/dev/null || :

# Dart
export PATH="$HOME/.pub-cache/bin:$PATH"

# PHP Composer
export PATH="$HOME/.config/composer/vendor/bin:$PATH"

export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

export PATH="$HOME/.local/bin:$PATH"
