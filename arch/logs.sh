#!/bin/bash


# logs
LOGFILE="/root/ar/inst.log"
if [ -f $LOGFILE ]; then
	echo "deleting existing log"
	rm -rf $LOGFILE
fi

exec > >(tee -a "$LOGFILE") 2>&1
echo " Installation started $(date). logs in $LOGFILE"

