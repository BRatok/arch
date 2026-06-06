#!/bin/bash

source logs.sh

# connecting to internet
#source iw.sh 

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
echo "............Chroot..........."
arch-chroot /mnt bash -c '
	             user_password="$user_password"
	             root_password="$root_password"
	             disk="$disk"
                 root="$root"
	            username="$username"
#   $(declare -p user_password)
#	$(declare -p root_password)
#	$(declare -p disk)
#	$(declare -p root)
#	$(declare -p username)
	/home/chroot.sh
	'
# end
source ending.sh


