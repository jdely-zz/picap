#!/bin/bash

# PiCAP
# Automatic packet capture for Raspberry Pi

## Path Variables
picapdir=/home/pi/picap/captures
logFile=/home/pi/picap/picap.log

## Session Variables
int=eth0
state="$(cat /sys/class/net/${int}/carrier)"
runtime=10s
sessionNumber=$(($(ls -l $picapdir | wc -l)))

## Log File
exec 3>&1 1>>${logFile} 2>&1

# Interface Prep
ifconfig $int 0.0.0.0
ifconfig $int up

for (( ; ; ))
do

	printf "Carrier Value: ${state}\n" | tee /dev/fd/3
	state="$(cat /sys/class/net/${int}/carrier)"
	if [ "${state}" = 1 ]
	then
		break
	fi
done

sessionTimestamp=$(date +"%d-%m-%y-at-%H-%M")

printf "Ethernet Carrier Signal Detected.\n" | tee /dev/fd/3
printf "Starting capture session at $sessionTimestamp.\n Captures stored at $picapdir\n" | tee /dev/fd/3
printf "Capture File Created: capture-$sessionNumber-$sessionTimestamp-$RANDOM.pcapng\n" | tee /dev/fd/3

timeout "${runtime}" tcpdump -i $int -w $picapdir/session-$sessionNumber-$sessionTimestamp-$RANDOM.pcapng

printf "Session timeout reached.\n\n" | tee /dev/fd/3

chmod 644 /home/pi/picap/picap.log
chown pi:pi /home/pi/picap/picap.log
chmod 644 /home/pi/picap/captures/*
chown pi:pi /home/pi/picap/captures/*
