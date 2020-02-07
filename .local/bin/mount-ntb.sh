#!/bin/sh


if [ "$(ping -c 1 192.168.1.18 > /dev/null; echo $?)" -eq '0' ]
then
	# eth reachable
	sshfs jirik@192.168.1.18:/home/jirik/ /mnt/ntb/
elif [ "$(ping -c 1 192.168.1.19 > /dev/null; echo $?)" -eq '0' ]
then
	# wifi reachable
	sshfs jirik@192.168.1.19:/home/jirik/ /mnt/ntb/
else
	echo "Unreachable"
	exit 1
fi

exit 0
