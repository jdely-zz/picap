#!/bin/bash

# PiCAP
# Automatic packet capture for Raspberry Pi

## Path
#rootdir=~/pitap
#pcapdir=$root/captures
#logFile=picap.log
int=eno16777736
state="$(cat /sys/class/net/${int}/carrier)"
runtime=10s

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
timeout "${runtime}" tcpdump -i $int -w $sessionTimestamp-$RANDOM.pcapng