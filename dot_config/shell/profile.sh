export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
[ ! -f "${XDG_CONFIG_HOME:-$HOME/.config}/shell/aliases.sh" ] || . "${XDG_CONFIG_HOME:-$HOME/.config}/shell/aliases.sh"

### Directory Colors
if [ -f "${XDG_CONFIG_HOME:-$HOME/.config}/shell/lscolors.sh" ]; then
	. "${XDG_CONFIG_HOME:-$HOME/.config}/shell/lscolors.sh"
fi

if command -v tmux &>/dev/null && [ -z "$TMUX" ]; then
	tmux attach-session -t default || tmux new-session -s default
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
