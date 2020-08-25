#!/bin/sh


if [ "$(id -u)" -eq 0 ]; then
	echo "Please don't run as root." >&2
	exit 1
fi

getHelp() {
	echo "Usage: $(basename "$0") [OPTION]"
	echo "Configure system for optimal use"
	echo
	echo "Options:"
	echo "-h, --help      Show brief help"
	echo "-f              Provide file with packages"
	echo "-t, --tlp       Install tlp (laptop battery management system)"
	echo "-v, --vim       Set up vim directory"
	exit 127
}

CURRENTFOLDER=$(dirname "$0")
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
		-v|--vim)
			(
				sudo pacman -Syu --needed git openssh || return 1
				VIMDIR="$HOME/.config/nvim"
				if [ -d "$VIMDIR" ]
				then
					echo "Directory '$VIMDIR' exists, overwriting."
					rm -r "$VIMDIR" || return 1
				fi
				git clone --recurse-submodules -j8 git@github.com:Jirixek/vim.git "$VIMDIR" || return 1
				return 0
			) || exit 2
			shift
			;;
		-f)
			shift
			if [ -f "$1" ]
			then
				INSTALLFILE="$1"
			fi
			shift
			;;
		*)	getHelp ;;
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

git_init () {
	[ -d ~/.dotfiles.git ] && return 0
	sudo pacman -Syu --needed --noconfirm git || return 1
	{	echo ".dotfiles.git" >> ~/.gitignore                                            && \
		git clone --bare git@github.com:Jirixek/dotfiles.git ~/.dotfiles.git            && \
		/usr/bin/git --git-dir="$HOME"/.dotfiles.git/ --work-tree="$HOME" checkout -f   && \
		/usr/bin/git --git-dir="$HOME"/.dotfiles.git/ --work-tree="$HOME" config --local status.showUntrackedFiles no
	} || return 2
	rm ~/.bash_login ~/.bash_profile || return 1
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
