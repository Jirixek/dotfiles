#!/bin/sh


if [ "$(id -u)" -eq 0 ]; then
	echo "Please don't run as root." >&2
	exit 1
fi

getHelp() {
	echo "Usage: $(basename "$0") [OPTIONS] FILE"
	echo "Configure system for optimal use"
	echo "Supply FILE as a list of packages that you want to install"
	echo
	echo "Options:"
	echo "-h, --help      Show brief help"
	echo "-t, --tlp       Install tlp (laptop battery management system)"
	exit 127
}

CURRENTFOLDER="$(dirname "$0")"
INSTALLFILE=""

while [ "$#" -gt 0 ]
do
	case "$1" in
		-h|--help)	getHelp ;;
		-t|--tlp)
			sudo pacman -Syu --needed --noconfirm tlp tlp-rdw                     && \
			sudo systemctl enable tlp.service NetworkManager-dispatcher.service   && \
			sudo systemctl mask systemd-rfkill.service systemd-rfkill.socket      || exit 1
			shift
			;;
		*)
			if [ -z "$INSTALLFILE" ] && [ -f "$1" ]; then
				INSTALLFILE="$1"
			else
				getHelp
			fi
			shift
			;;
	esac
done

yay_install () {
	pacman -Qq | grep -q yay && return 0
	sudo pacman -Syu --needed --noconfirm git openssh || return 1
	(
	cd "$CURRENTFOLDER"                           && \
	git clone https://aur.archlinux.org/yay.git   && \
	cd yay                                        && \
	makepkg -si --needed --noconfirm              && \
	cd ..                                         && \
	rm -rf yay/                                   || return 2
	)
	return $?
}

prompt_and_remove_path () {
	if [ -e "$1" ]; then
		printf "%s exists, overwrite? [Y/n] " "$1"
		read -r input
		if [ -z "$input" ] || [ "${input,,}" = 'y' ]; then
			rm -rf "$1"
		else
			return 0
		fi
	fi
}

git_init () {
	sudo pacman -Syu --needed --noconfirm openssh git || return 1

	REPO_PATH="$HOME/.dotfiles.git"
	prompt_and_remove_path "$REPO_PATH"

	# TODO: check ssh key
	git clone --bare --recurse-submodules git@github.com:Jirixek/dotfiles.git "$REPO_PATH"     && \
	git --git-dir="$REPO_PATH" --work-tree="$HOME" checkout -f                                 && \
	git --git-dir="$REPO_PATH" --work-tree="$HOME" config --local status.showUntrackedFiles no || return 1
	rm ~/.bash_login ~/.bash_profile || return 2
}

borg_init () {
	BACKUP_PATH='/home/backup'
	prompt_and_remove_path "$BACKUP_PATH"
	sudo borg init --encryption=none "$BACKUP_PATH"
}

service_enable () {
	# CUPS (printer)
	# Suggestions in bash for unknown package
	# Bluetooth
	# Cron
	# Firefox profile in memory

	sudo systemctl enable             \
	     org.cups.cupsd.socket        \
	     pkgfile-update.timer         \
	     bluetooth.service            \
	     cronie.service               \
	     lightdm                      \
	     fstrim.timer
	root_exit=$?

	systemctl --user enable psd.service mpd.service
	user_exit=$?

	return $((root_exit > user_exit ? root_exit : user_exit))
}

# --------------
#  Init Section
# --------------
if [ -z "$INSTALLFILE" ]
then
	echo "please provide installation file."
	exit 1
fi

git_init                                         && \
yay_install                                      && \
"$HOME"/.local/bin/pkgupdate.sh "$INSTALLFILE"   && \
service_enable                                   && \
borg_init                                        || exit 1

"$HOME"/.local/bin/linker.sh -w || exit 2
