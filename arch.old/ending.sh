#!/bin/bash
sleep 0.5

# Copy postInstall script
cp postin.sh /mnt/usr/local/bin/

chmod +x /mnt/usr/local/bin/postin.sh

cp postinstall.service /mnt/etc/systemd/system/
chmod +x /mnt/etc/systemd/system/postinstall.service 

arch-chroot /mnt systemctl enable postinstall.service

# Copy wallpaper folders
cp -r wallw/ /mnt/home/$username/Desktop 2>/dev/null || true
sleep 0.5

cp -r wallv/ /mnt/home/$username/Desktop 2>/dev/null || true
sleep 0.5

# Copy dotfiles
cp -r coms /mnt/home/$username/ 2>/dev/null || true

# Copy logs
cp /root/ar/inst.log /mnt

sleep 0.5


# Copy custom scripts to /usr/local/bin
#cp -r bin/* /mnt/usr/local/bin/ 2>/dev/null || true

#chmod +x /mnt/usr/local/bin/* 2>/dev/null || true
chmod +x /.config/* 2>/dev/null || true
sudo chown -R $username:$username /home/$username/.config
chmod 700 /home/$username/.config



echo "Set Arch Linux as the default boot entry (Boot$BOOTNUM)."


echo "Reboot"

umount -R /mnt
swapoff -a

#reboot

# end
