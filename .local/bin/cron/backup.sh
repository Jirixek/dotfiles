#!/bin/sh


# Setting this, so the repo does not need to be given on the commandline:
export BORG_REPO='/home/backup'

# Setting this, so you won't be asked for your repository passphrase:
export BORG_PASSPHRASE='D@ddyBackMeUp'

# Location of log file
export LOG_FILE='/var/log/borg/backup.log'

# some helpers and error handling:
info () {
	sudo -u jirik DISPLAY=:0 DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/1000/bus notify-send "$@" --icon=dialog-information || return 1
	return 0
}
trap 'echo $(date) Backup interrupted >&2; exit 2' INT TERM

info "Starting backup"

# Backup the most important directories into an archive named after
# the machine this script is currently running on:

borg create                              \
	--filter AME                       \
	--list                             \
	--stats                            \
	--show-rc                          \
	--compression lz4                  \
	--exclude-caches                   \
	--exclude '/home/backup/*'         \
	--exclude '/home/*/.cache/*'       \
	--exclude '/var/cache/*'           \
	--exclude '/var/tmp/*'             \
	                                   \
	::'{hostname}-{now}'               \
	/etc                               \
	/home                              \
	/root                              \
	/var                               \
	> "$LOG_FILE" 2>&1
backup_exit=$?

# Use the `prune` subcommand to maintain 7 daily, 4 weekly and 6 monthly
# archives of THIS machine. The '{hostname}-' prefix is very important to
# limit prune's operation to this machine's archives and not apply to
# other machines' archives also:

borg prune                               \
	--prefix '{hostname}-'             \
	--list                             \
	--show-rc                          \
	--keep-daily 7                     \
	--keep-weekly 4                    \
	--keep-monthly 6                   \
	>> "$LOG_FILE" 2>&1
prune_exit=$?

# use highest exit code as global exit code
global_exit=$((backup_exit > prune_exit ? backup_exit : prune_exit))

if [ ${global_exit} -eq 0 ]; then
	info "Backup and Prune finished successfully"
elif [ ${global_exit} -eq 1 ]; then
	info "Backup and/or Prune finished with warnings"
else
	info "Backup and/or Prune finished with errors"
fi

exit ${global_exit}
