#!/bin/bash

source logs.sh

# connecting to internet
source iw.sh

# begin
source begin.sh
	export user_password
	export root_password
	export disk
	export root
	export username

#  packstrap
source packstrap.sh

# Chroot
arch-chroot /mnt bash -c '
	             user_password="$user_password"
	             root_password="$root_password"
	             disk="$disk"
                     root="$root"
		     username="$username"
		     /home/chroot.sh
			'
# end
source ending.sh


