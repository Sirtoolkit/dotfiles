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

plugins=(sudo git flutter node npm tmux archlinux zsh-autosuggestions zsh-syntax-highlighting)

export PATH=$PATH:$HOME/development/nvim-linux64/bin
export PATH=$PATH:$HOME/development/Postman/app
export PATH=$PATH:$HOME/development/flutter/bin/
export PATH=$PATH:$HOME/development/gradle-6.8.2/bin
export PATH=$PATH:$HOME/development/heroku/bin
export PATH=$PATH:$HOME/development/node-v14.15.5-linux-x64/bin
export PATH=$PATH:$HOME/development/spring-2.4.3/bin

export JAR=$HOME/development/eclipse.jdt.ls/org.eclipse.jdt.ls.product/target/repository/plugins/org.eclipse.equinox.launcher_1.6.0.v20200915-1508.jar
export GRADLE_HOME=$HOME/gradle
export JAVA_HOME="/usr/lib/jvm/java-11-openjdk/"
export JDTLS_CONFIG=$HOME/development/eclipse.jdt.ls/org.eclipse.jdt.ls.product/target/repository/config_linux
export WORKSPACE=$HOME/workspace/java/main

export PATH="$PATH:$HOME/npm/bin"
export ANDROID_HOME=$HOME/Android/Sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/platform-tools
export PATH=$PATH:$ANDROID_HOME/cmdline-tools/lastet/bin
export PATH=$PATH:$HOME/Flutter/flutter/bin
export PATH=$PATH:$HOME/var/lib/snapd/snap/bin
