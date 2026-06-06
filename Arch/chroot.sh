#!/bin/bash

echo "...........chroot........"
echo "Package manager running updates"


pacman -S --noconfirm archlinux-keyring

pacman-key --init
pacman-key --populate archlinux

pacman -Syu

echo "pacman installing things"

pacman -S --noconfirm efibootmgr nano networkmanager nvidia-open nvidia-utils nvidia-settings amd-ucode ntfs-3g \
    tzdata greetd hyprland nano-syntax-highlighting xf86-input-libinput \
     alacritty btrfs-progs sudo archlinux-keyring xorg-server xorg-xinit xorg-xrandr xorg-xsetroot \
     ufw thunar pipewire pipewire-pulse htop reflector lsof maim wpa_supplicant ttf-fira-code \
     terminus-font nnn pavucontrol broadcom-wl


pacman -Syu

#timezone
ln -sf /usr/share/zoneinfo/Europe/Kyiv  /etc/localtime
timedatectl set-timezone Europe/Kyiv
timedatectl set-ntp true

echo "Set locales"
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
echo "ru_RU.UTF-8 UTF-8" >> /etc/locale.gen

locale-gen

echo "Set keyboard layout and font"
echo "KEYMAP=us" > /etc/vconsole.conf
echo "FONT=ter-v32b" >> /etc/vconsole.conf

echo "Set hostname"
echo "$username" > /etc/hostname

echo "Set hosts file"
echo "127.0.0.1 localhost" > /etc/hosts
echo "::1 localhost" >> /etc/hosts
echo "127.0.1.1 $username.localdomain $username" >> /etc/hosts

echo "Set root password"
echo "root:$root_password" | chpasswd

echo "Add user and set password"
useradd -m -G wheel,storage,power,audio,video,input,render,uucp -s /bin/bash $username
echo "$username:$user_password" | chpasswd

echo "Grant wheel group sudo access no pass"
echo "%wheel ALL=(ALL:ALL) ALL" >> /etc/sudoers
echo "$username ALL=(ALL) NOPASSWD: /usr/bin/pacman, /usr/bin/git, /home/" >> /etc/sudoers

echo "Enable multilib repository for 32-bit support"
echo "[multilib]" >> /etc/pacman.conf
echo "Include = /etc/pacman.d/mirrorlist" >> /etc/pacman.conf

echo "Chown home desk"
chown -R $username:$username /home
install -d -m 755 /home/$username/.config

echo "Enable NetworkManager and greetd"
systemctl enable NetworkManager.service
systemctl enable greetd

echo "Install bootloader (systemd-boot)"
bootctl --path=/boot install

echo "set larger text size in tty1 loggin part"
echo "setfont ter-v32b" >> ~/.bash_profile

echo "create include nanorc file"
echo 'include "/usr/share/nano-syntax-highlighting/*.nanorc"' >> ~/.nanorc

echo "Create boot entry with efibootmgr"

if efibootmgr | grep -q "ArchTest"; then
    echo "Existing ArchTest entry found. Deleting..."
    for entry in $(efibootmgr | grep "ArchTest" | awk '{print $1}'); do
        bootnum=${entry#Boot}
        bootnum=${bootnum%\*}
        echo "Deleting: $bootnum"
        efibootmgr -b "$bootnum" -B
        sleep 1
    done
else
    echo "No existing ArchTest entry found."
fi

uuid=$(blkid -s UUID -o value $root)

efibootmgr -c -d $disk -p 1 -L 'ArchTest' -l '\vmlinuz-linux' -u "initrd=\initramfs-linux.img root=UUID=$uuid rw"
sleep 1

# ----------------BOOT 'Arch Linux'
for entry in $(efibootmgr | grep "ArchTest" | awk '{print $1}'); do
	bootnum=${entry#Boot}
	bootnum=${bootnum%\*}
	if [ -z "$bootnum" ]; then
    		echo "Error: 'Arch Linux' boot entry not found!"
    		exit 1
	fi


	echo "Boot number: $bootnum"
	efibootmgr -n $bootnum
  sleep 1
	break

done


#export GTK_THEME=Adwaita:dark
#export GTK2_RC_FILES=/usr/share/themes/Adwaita-dark/gtk-2.0/gtkrc
#export QT_STYLE_OVERRIDE=Adwaita-Dark
