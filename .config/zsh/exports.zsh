# Uncomment the following line to use case-sensitive completion.
CASE_SENSITIVE="true"

zle_highlight=('paste:none')
# export
export TF_FORCE_GPU_ALLOW_GROWTH=true
# Preferred editor for local and remote sessions
 if [[ -n $SSH_CONNECTION ]]; then
   export EDITOR='nvim'
 else
   export EDITOR='nvim'
 fi
#autoload -U colors && colors
export CLICOLOR=1
export FZF_DEFAULT_COMMAND='rg --files --hidden'
export FZF_ALT_C_COMMAND="$FZF_DEFAULT_COMMAND"
export MANPAGER='nvim +Man!'
export MANWIDTH=999

plugins=(git flutter node npm tmux archlinux zsh-autosuggestions zsh-syntax-highlighting)

# export PATH=$PATH:$HOME/Neovim/nvim-linux64/bin
export JAVA_HOME="/usr/lib/jvm/java-11-openjdk/"
export ANDROID_HOME=$HOME/Android/Sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/platform-tools
export PATH=$PATH:$ANDROID_HOME/cmdline-tools/lastet/bin
export PATH=$PATH:$HOME/Flutter/flutter/bin
export PATH=$PATH:$HOME/var/lib/snapd/snap/bin
