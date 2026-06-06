#!/bin/bash
LOGFILE="/home/inst.log"
exec > >(tee -a "$LOGFILE") 2>&1
echo " Installation started $(date). logs in $LOGFILE"

echo "including creds"
source /home/creds.sh
#export HOME=/root
#export USER=root

echo "Enable WPA ..."
nmcli radio wifi on

echo "Waiting for NetworkManager..."
until nmcli -t -f RUNNING general | grep -q running; do
    sleep 1
done

until nmcli device status | grep -q wifi; do
    sleep 2
done

echo "wpa rescan and run"
nmcli device wifi rescan
sleep 1
nmcli device wifi connect "$wifissid" password "$wifipass"
sleep 3

echo "Enable WPA ..."
 nmcli device wifi connect "$wifissid" password "$wifipass"
 nmcli con modify "$wifissid" wifi-sec.key-mgmt wpa-psk
 nmcli con modify "$wifissid" wifi-sec.psk "$wifipass"
 nmcli con up "$wifissid"

echo "Waiting for WPA"
until nmcli -t | grep -i "connected to CabalHuge"; do
    sleep 2
       nmcli device wifi connect "$wifissid" password "$wifipass"

done

#echo "$username ALL=(ALL) NOPASSWD: /usr/bin/pacman, /usr/bin/git, /home/" >> /etc/sudoers
echo "Enable greetd"
systemctl enable greetd
systemctl start greetd

echo "Changing owner of Desktop"
sudo chown -R $username:$username /home/$username

echo "Pacman installing"
pacman -Syu --noconfirm
pacman -S --noconfirm hyprpaper swww hyprsunset rofi firefox\
              base-devel git rust mpv keepass git waybar

echo "Paru installing"
cd /home/$username/Desktop
su -c "git clone https://aur.archlinux.org/paru.git" $username
#sudo -u "$username" git clone https://aur.archlinux.org/paru.git
sleep 1
cd /home/$username/Desktop/paru
su -c "makepkg -si --noconfirm" $username
#pacman -U --noconfirm ./*.pkg.tar.zst
#sudo -u "$username" makepkg -si --noconfirm
sleep 1
cd ../
su -c "paru -S --noconfirm waypaper" $username
#sudo -u "$username" paru -S --noconfirm waypaper
sleep 1
echo "Cleanup"
systemctl disable postinstall.service
rm -f /etc/systemd/system/postinstall.service
rm /home/creds.sh
rm /home/chroot.sh

exit 0


