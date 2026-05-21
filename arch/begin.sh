#!/bin/bash

umount /mnt/boot
umount /mnt
swapoff -a

# 1. Ask for root password

echo "Enter root password:"
read -s root_password
echo "Confirm root password:"
read -s root_password_confirm

while [[ "$root_password" != "$root_password_confirm" ]]; do
    echo "Passwords do not match. Please try again."
    echo "Enter root password:"
    read -s root_password
    echo "Confirm root password:"
    read -s root_password_confirm
done

# 2. Ask for user details
echo "Enter the username for the new user:"
read username

echo "Enter password for user $username:"
read -s user_password
echo "Confirm password for user $username:"
read -s user_password_confirm

while [[ "$user_password" != "$user_password_confirm" ]]; do
    echo "Passwords do not match. Please try again."
    echo "Enter password for user $username:"
    read -s user_password
    echo "Confirm password for user $username:"
    read -s user_password_confirm
done
# 3. Scan for available disks
echo "Scanning available disks..."
lsblk

# 4. Ask for disk address
echo "Enter the disk to install Arch Linux (e.g., nvme0n1 or sda):"

read disk_input
disk="/dev/${disk_input}"
read -p "Are you sure you want to format ${disk}? (y/N): " confirm
[ $confirm != "y" ] && echo "Cancelled." && exit 1

# 5. Ask for swap size

echo "Do you want to create swap? (y/n)"

read swap_choice

if [[ "$swap_choice" == "y" ]]; then
    echo "Enter swap size in GB:"
    read swap_size
fi

if [[ $disk == *"nvme"* ]]; then
  efi="${disk}p1"
  	if [[ $swap_choice == "y" ]]; then
    		swap="${disk}p2"
    		root="${disk}p3"
	else
    		root="${disk}p2"
	fi
else	
  efi="${disk}1"
       	if [[ $swap_choice == "y" ]]; then
    		swap="${disk}2"
    		root="${disk}3"
  	else
    		root="${disk}2"
  	fi
fi

# 6. Check for EFI and mount efivarfs if needed
if ! mount | grep -q /sys/firmware/efi/efivars; then
    echo "Mounting efivarfs..."
    mount -t efivarfs efivarfs /sys/firmware/efi/efivars
fi

# 7. Partitioning the disk
echo "Partitioning the disk using fdisk..."

# Calculate end sectors based on swap choice

if [[ $swap_choice == "y" ]]; then
	echo "making swap partition"
    	fdisk "$disk" <<EOF
	g
	n
	1
	
	+512M
	t
	1
	n
	2
	
	+${swap_size}G
	t
	2
	19
	n
	3
	
	
	w	
EOF
else
	echo "no swap partition made"
    	fdisk "$disk" <<EOF
	g
	n
	1
	
	+512M
	t
	1
	1
	n
	2
	
	
	w
EOF
fi

# 8. Format the partitions
echo "Formatting partitions..."

# EFI partition (1GB)
mkfs.fat -F32 ${efi}

# Swap partition (if needed)
if [[ $swap_choice == "y" ]]; then
	echo "making swap fs"
	mkswap ${swap}
	swapon ${swap}
fi

# Btrfs partition (or ext4 if preferred)

mkfs.btrfs -f ${root}

sleep 1
# 9. Mount partitions
echo "Mounting partitions..."

mount ${root} /mnt
mkdir /mnt/boot
mount ${efi} /mnt/boot


echo "..........end begin.........."
