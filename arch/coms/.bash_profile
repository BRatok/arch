#
# ~/.bash_profile
#

[[ -f ~/.bashrc ]] && . ~/.bashrc
if [[ $(tty) == /dev/tty1 ]]; then 
	setfont ter-v32b 
fi

