#!/bin/bash

# PiCAP
# Automatic packet capture for Raspberry Pi

## Path
rootdir=~/picap
pcapdir=$rootdir/captures
logFile=$rootdir/picap.log
int=eth0
state="$(cat /sys/class/net/${int}/carrier)"
runtime=10s
filecount="$(ls -l $pcapdir | wc -l)" 

# Interface Prep
ifconfig $int 0.0.0.0
ifconfig $int up

for (( ; ; ))
do

	echo "${state}"
	state="$(cat /sys/class/net/${int}/carrier)"
	if [ "${state}" = 1 ]
	then
		break
	fi
done

echo "${state}"

sessionTimestamp=$(date +"session-%d-%m-%y-at-%H-%M")
echo "Starting dump mode at $sessionTimestamp. Captures stored the base directory." >> $logFile
timeout "${runtime}" tcpdump -i $int -w $picapdir/$sessionTimestamp-$RANDOM.pcapng
