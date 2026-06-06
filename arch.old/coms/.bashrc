#
# ~/.bashrc
#

# If not running interactively, don't do anything

[[ $- != *i* ]] && return

alias ll='ls -lah'
alias up='sudo pacman -Syu'
alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1=' \$\W ->'


# Start X after login
if [[ -z $DISPLAY ]] && [[ $(tty) = /dev/tty1 ]]; then
    startx
fi
cd ~/Desktop/

#export GDK_SCALE=1.5 

export ANDROID_HOME="/home/duck/Android/Sdk"

export JAVA_HOME="/home/duck/android-studio/jbr"

export PATH="$PATH:/home/duck/Android/Sdk/platform-tools:/home/duck/Android/Sdk/build-tools/34.0.0:/home/duck/Android/Sdk/tools/bin"

export NDKROOT="/home/duck/Android/Sdk/ndk/25.1.8937393"
export NDK_ROOT="/home/duck/Android/Sdk/ndk/25.1.8937393"

export PATH="$PATH:/home/duck/Android/Sdk/platform-tools:/home/duck/Android/Sdk/build-tools/34.0.0:/home/duck/Android/Sdk/tools/bin"

export PATH="$PATH:/home/duck/Android/Sdk/platform-tools:/home/duck/Android/Sdk/build-tools/34.0.0:/home/duck/Android/Sdk/tools/bin"

export PATH="$PATH:/home/duck/Android/Sdk/platform-tools:/home/duck/Android/Sdk/build-tools/34.0.0:/home/duck/Android/Sdk/tools/bin"

export PATH="$HOME/.local/bin:$PATH"
