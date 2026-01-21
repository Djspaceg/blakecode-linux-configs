#!/bin/bash

if (!$1) then
	echo 'Please include an interface to restart.'
	ifconfig
	exit
fi

echo 'Admin privilages required to restart networking.'
sudo echo 'Restarting networking on $1…'
sudo ifconfig en0 down

echo 'Waiting for 5 seconds…'
sleep 5s

echo 'Start things back up again…'
sudo ifconfig en0 up
