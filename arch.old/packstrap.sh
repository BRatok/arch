#!/bin/bash

echo "............pacstrap............"
pacman -Sy --noconfirm archlinux-keyring
#pacman-key --refresh-keys --noconfirm
pacman-key --init
pacman-key --populate archlinux

echo "Installing base system..."
pacstrap -K /mnt --noconfirm base linux linux-firmware linux-headers sof-firmware base-devel bash bash-completion



echo "installing bash"

sleep 0.5

echo "[ -r /usr/share/bash-completion/bash_completion ] && . /usr/share/bash-completion/bash_completion" >> /mnt/etc/bash.bashrc
	  
	  
sleep 0.5
 

echo "Generating fstab..."
genfstab -U /mnt >> /mnt/etc/fstab

cp chroot.sh /mnt/home/
chmod +x /mnt/home/chroot.sh

echo "...........end pacstrap........."
