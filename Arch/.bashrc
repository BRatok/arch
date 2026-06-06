#
# ~/.bashrc
#

# If not running interactively, don't do anything

[[ $- != *i* ]] && return

alias ll='ls -la --color=never'
alias grep='grep --color=auto'
alias n='nano -l'
alias i='micro'

alias ns='sudo nano --line'
alias up='sudo pacman -Syu --noconfirm'
alias ups='paru -Syu'
alias s='sudo pacman -S'
alias rns='sudo pacman -Rns'
# alias rm='rm -rf'
alias '!'='sudo $(fc -ln -1)'
alias y='yazi'
alias b='bluetoothctl'
alias l='lsblk -f'
alias r='reboot'
alias rw='sudo efibootmgr -n 0000; reboot'
alias m='sudo mount'
alias um='sudo umount'
alias v='nvim'

PS1=' \$\W ->'


#if [[ -z $DISPLAY ]] && [[ $(tty) = /dev/tty1 ]]; then
#    start-hyprland
#fi
