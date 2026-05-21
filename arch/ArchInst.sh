#!/bin/bash

# logs
LOGFILE="/root/inst.log"
exec > >(tee -a "$LOGFILE") 2>&1
echo " Installation started $(date). logs in $LOGFILE"

# connecting to internet
source iw.sh 


# password, partitions, mount
source begin.sh 

#  packstrap
source packstrap.sh

# chroot, user, network, boot entry
source chroot.sh


# post install script 
source post_inst.sh

# end
