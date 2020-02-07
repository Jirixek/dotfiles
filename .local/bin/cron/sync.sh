#!/bin/bash

# This script synchronizes and backups system with osync
# Executed daily by anacron


if [ "$(id -u)" -eq 0 ]
then
	echo "This script is ment to be executed by normal user" >&2
	exit 1
fi

info () {
	sudo -u jirik DISPLAY=:0 DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/1000/bus notify-send "$@" --icon=dialog-information || return 1
	return 0
}

gDriveExit=0
backupExit=0
IGNORE_OS_TYPE=no

info 'Starting synchronization'

osync-batch.sh --path="$HOME"/.config/osync/gDrive
gDriveExit=$?

# check if running on the ethernet
if nmcli device | grep -Es 'ethernet[[:blank:]]+connected'
then
	# ping on NAS
	if ping -c 1 nas.lan &> /dev/null
	then
		osync-batch.sh --path="$HOME"/.config/osync/backup
		backupExit=$?
	fi
fi

globalExit=$((gDriveExit > backupExit ? gDriveExit : backupExit))
case "$globalExit" in
	2) info 'Synchronization complete' 'Synchronization finished with errors'    ;;
	1) info 'Synchronization complete' 'Synchronization finished with warnings'  ;;
	0) info 'Synchronization complete' 'Synchronization finished successfully'   ;;
	*) info 'Synchronization complete' 'Unknown error'                           ;;
esac

exit ${globalExit}
