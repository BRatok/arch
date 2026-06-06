#!/bin/bash

echo "Copying postInstall script"
cp postin.sh /mnt/usr/local/bin/
chmod +x /mnt/usr/local/bin/postin.sh
cp postinstall.service /mnt/etc/systemd/system/
chmod +x /mnt/etc/systemd/system/postinstall.service 
arch-chroot /mnt systemctl enable postinstall.service

echo " Copying wall folders"
mkdir /mnt/home/$username/Desktop 2>/dev/null || true
cp -r wallw/ /mnt/home/$username/Desktop 2>/dev/null || true
cp -r wallv/ /mnt/home/$username/Desktop 2>/dev/null || true

# ----------------------
echo "Copying config folders"
cp -r .config/. /mnt/home/$username/.config/ 2>/dev/null || true
cp -r .bashrc /mnt/home/$username/ 2>/dev/null || true
cp -r .bash_logout /mnt/home/$username/ 2>/dev/null || true
cp -r .nanorc /mnt/home/$username/ 2>/dev/null || true
cp -r coms/* /mnt/home/$username/Desktop 2>/dev/null || true
cp -r greetd/ /mnt/etc/ || true
cp -r nanorc /mnt/etc/ 2>/dev/null || true

chmod +x /mnt/home/.config/* 2>/dev/null || true
sudo chown -R $username:$username /mnt/home/$username/.config
sudo chown -R $username:$username /mnt/home/$username/Desktop


echo "deleting EFI/BOOT"
rm /mnt/boot/EFI/BOOT/BOOTX64.EFI

echo "Copy logs"
cp /root/ar/inst.log /mnt

echo "Creds.sh creation"
echo "#!/bin/bash" > /mnt/home/creds.sh
echo "username=$username" >> /mnt/home/creds.sh
echo "user_password=$user_password" >> /mnt/home/creds.sh
echo "wifissid=$wifissid" >> /mnt/home/creds.sh
echo "wifipass=$wifipass" >> /mnt/home/creds.sh




chmod +x /mnt/home/creds.sh

echo "Umount and Reboot"
umount -R /mnt
umount -R /root/ar
swapoff -a
reboot

# Copy custom scripts
#cp -r bin/* /mnt/usr/local/bin/ 2>/dev/null || true
#chmod +x /mnt/usr/local/bin/* 2>/dev/null || true

