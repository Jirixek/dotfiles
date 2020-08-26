#!/bin/sh


get_help () {
	echo "Usage: $(basename "$0") [OPTIONS] FILE"
	echo "Configure system for optimal use"
	echo "Supply FILE as a list of packages that you want to install"
	echo
	echo "Options:"
	echo "-h, --help      Show brief help"
	echo "-t, --tlp       Install tlp (laptop battery management system)"
	exit 127
}

yay_install () {
	pacman -Qq | grep -q yay && return
	sudo pacman -Syu --needed --noconfirm git openssh || return
	(
	cd "$CURRENTFOLDER"                           && \
	git clone https://aur.archlinux.org/yay.git   && \
	cd yay                                        && \
	makepkg -si --needed --noconfirm              && \
	cd ..                                         && \
	rm -rf yay/                                   || return
	)
}

prompt_and_remove_path () {
	if [ -e "$1" ]; then
		printf "%s exists, overwrite? [Y/n] " "$1"
		read -r input
		if [ -z "$input" ] || [ "${input,,}" = 'y' ]; then
			sudo rm -rf "$1"
		else
			return 1
		fi
	fi
}

check_rsa () {
	[ -f "$RSAPATH" ] && return
	ssh-keygen -t rsa -b 4096 -C 'jirik.sz@gmail.com' -P '' -f "$RSAPATH"
}

github_key () {
	cp "${RSAPATH}.pub" "${HOME}/add_to_github_rsa.pub"
	[ -n "$NEWRSA" ] && printf '%s\n'                                                  \
		"A copy of the rsa public key has been added to $HOME/add_to_github_rsa.pub" \
		"Please add this key to github.com"
}

git_init () {
	REPO_PATH="${HOME}/.dotfiles.git"
	sudo pacman -Syu --needed --noconfirm openssh git                                            && \
	prompt_and_remove_path "$REPO_PATH"                                                          && \
	git clone --bare --recurse-submodules https://github.com/Jirixek/dotfiles.git "$REPO_PATH"   && \
	git --git-dir="$REPO_PATH" --work-tree="$HOME" checkout -f                                   && \
	git --git-dir="$REPO_PATH" config --local status.showUntrackedFiles no                       && \
	git --git-dir="$REPO_PATH" remote set-url origin git@github.com:Jirixek/dotfiles.git         && \
	check_rsa                                                                                    && \
	rm -f ~/.bash_login ~/.bash_profile                                                          || return
}

borg_init () {
	BACKUP_PATH='/home/backup'
	prompt_and_remove_path "$BACKUP_PATH" || return
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

# ---------------
#  Init Section
# ---------------
if [ "$(id -u)" -eq 0 ]; then
	echo "Please don't run as root." >&2
	exit 1
fi

CURRENTFOLDER="$(dirname "$0")"
RSAPATH="${HOME}/.ssh/id_rsa"
INSTALLFILE=""

while [ "$#" -gt 0 ]
do
	case "$1" in
		-h|--help)	get_help ;;
		-t|--tlp)
			sudo pacman -Syu --needed --noconfirm tlp tlp-rdw                     && \
			sudo systemctl enable tlp.service NetworkManager-dispatcher.service   && \
			sudo systemctl mask systemd-rfkill.service systemd-rfkill.socket      || exit
			shift
			;;
		*)
			if [ -z "$INSTALLFILE" ] && [ -f "$1" ]; then
				INSTALLFILE="$1"
			else
				get_help
			fi
			shift
			;;
	esac
done

[ -z "$INSTALLFILE" ] && get_help

git_init                                                     && \
yay_install                                                  && \
"$HOME"/.local/bin/pkgupdate.sh "$INSTALLFILE" --noconfirm   && \
service_enable                                               && \
borg_init                                                    && \
"$HOME"/.local/bin/linker.sh -w                              && \
github_key                                                   || exit
