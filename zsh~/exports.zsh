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

plugins=(sudo git flutter heroku react-native vscode docker-compose docker node npm archlinux zsh-autosuggestions zsh-syntax-highlighting)

# Neovim
export PATH=$PATH:$HOME/development/nvim-linux64/bin

# Postman 
export PATH=$PATH:$HOME/development/Postman/app

# Gradle 
export PATH=$PATH:$HOME/development/gradle-6.8.2/bin

# Heroku 
export PATH=$PATH:$HOME/development/heroku/bin

# NodeJs 
export PATH=$PATH:$HOME/development/node-v14.15.5-linux-x64/bin
# Npm
NPM_PACKAGES="${HOME}/.npm-packages"
export PATH="$PATH:$NPM_PACKAGES/bin"

# Spring 
export PATH=$PATH:$HOME/development/spring-2.5.3/bin

# Java 
export JAVA_HOME="/usr/lib/jvm/java-11-openjdk-amd64"
export JAR=$HOME/development/eclipse.jdt.ls/org.eclipse.jdt.ls.product/target/repository/plugins/org.eclipse.equinox.launcher_1.6.100.v20201223-0822.jar
export GRADLE_HOME="$HOME/development/gradle-6.8.2"
export JDTLS_CONFIG=$HOME/development/eclipse.jdt.ls/org.eclipse.jdt.ls.product/target/repository/config_linux
export WORKSPACE=$HOME/workspace/java/main
export PATH="$PATH":$JAVA_HOME/bin


# # Android Studio
export ANDROID_SDK_ROOT="$HOME/.android-sdk"
export PATH="$PATH:$ANDROID_SDK_ROOT/cmdline-tools/latest/bin"
export PATH="$PATH:$ANDROID_SDK_ROOT/platform-tools"
export PATH="$PATH:$ANDROID_SDK_ROOT/tools"
# export ANDROID_ADB_SERVER_PORT=6565
# export ANDROID_ADB_SERVER_ADDRESS=192.168.0.24

# Flutter 
export PATH=$PATH:$HOME/development/flutter/bin
export PATH=$PATH:$HOME/development/flutter/bin/cache/dart-sdk/bin
export PATH="$PATH":"$HOME/.pub-cache/bin"

# Chrome 
# export CHROME_EXECUTABLE=/opt/google/chrome/chrome
