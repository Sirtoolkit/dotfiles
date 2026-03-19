export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
[ ! -f "${XDG_CONFIG_HOME:-$HOME/.config}/shell/aliases.sh" ] || . "${XDG_CONFIG_HOME:-$HOME/.config}/shell/aliases.sh"

### Directory Colors
if [ -f "${XDG_CONFIG_HOME:-$HOME/.config}/shell/lscolors.sh" ]; then
	. "${XDG_CONFIG_HOME:-$HOME/.config}/shell/lscolors.sh"
fi

# mise - cached activation for fast startup
MISE_CONFIG="$HOME/.config/mise/config.toml"
MISE_INSTALLS="$HOME/.local/share/mise/installs"
MISE_CACHE="${XDG_CACHE_HOME:-$HOME/.cache}/shell/mise_activate"

# Check if cache needs regeneration:
# - Cache doesn't exist, or
# - Config file is newer than cache, or
# - Any install directory is newer than cache (tools were updated)
_needs_regen=false
if [[ ! -r "$MISE_CACHE" ]]; then
  _needs_regen=true
elif [[ "$MISE_CONFIG" -nt "$MISE_CACHE" ]]; then
  _needs_regen=true
elif [[ -d "$MISE_INSTALLS" ]]; then
  # Find if any install is newer than cache (check top-level dirs only, with timeout)
  [[ -n "$(find "$MISE_INSTALLS" -maxdepth 2 -newer "$MISE_CACHE" -print -quit 2>/dev/null)" ]] && _needs_regen=true
fi

if $_needs_regen; then
  mkdir -p "$(dirname "$MISE_CACHE")"
  mise activate zsh > "$MISE_CACHE" 2>/dev/null || echo "# mise not installed" > "$MISE_CACHE"
fi
unset _needs_regen

# Source the cached activation
[[ -r "$MISE_CACHE" ]] && source "$MISE_CACHE"

# Function to reload mise cache
reload-mise() {
  rm -f "$MISE_CACHE"
  source "${ZDOTDIR:-$HOME}/.zshrc"
}

# Flutter root (lazy set)
flutter() {
  unset -f flutter
  export FLUTTER_ROOT=$(mise where flutter 2>/dev/null || echo "")
  command flutter "$@"
}

# Android SDK from Homebrew (installed via Nix)
if [ -d "/opt/homebrew/share/android-commandlinetools" ]; then
	export ANDROID_HOME="/opt/homebrew/share/android-commandlinetools"
	export ANDROID_AVD_HOME="$HOME/.config/.android/avd"
	export PATH="$ANDROID_HOME/cmdline-tools/latest/bin:$PATH"
	export PATH="$ANDROID_HOME/platform-tools:$PATH"
	export PATH="$ANDROID_HOME/emulator:$PATH"
fi

# OrbStack - lazy load
orb() {
  unset -f orb
  source ~/.orbstack/shell/init.zsh 2>/dev/null || :
  orb "$@"
}

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
