#!/bin/bash


hostnameFile="$(dirname "$0")/../src/pkglist_${HOSTNAME}.txt"

getHelp() {
	echo "Usage: $(basename "$0") [OPTIONS] [FILES]"
	echo "Auxiliary script to help manage ./src/pkglist.txt list"
	echo
	echo "Options:"
	echo "-g [INPUT] [OUTPUT]      Generate file without drivers and other machine specifis packages"
	echo "[SOURCE]                 Install packages that are missing on local system acording to given file"
	exit 127
}

yayInstall () {
	[ -n "$1" ] && echo "$1" | yay -Syu --needed -
	return $?
}

yayUninstall () {
	[ -n "$1" ] && echo "$1" | sudo pacman -Rnus -
	return $?
}

filterMatches () {
		sed -E '
			/^bbswitch$/d;
			/^bumblebee$/d;
			/^intel-ucode$/d;
			/^intel.*/d;
			/^libva.*/d;
			/^nvidia.*/d;
			/^mesa.*/d;
			/^tlp.*/d;
			/^mathematica$/d;
			/^ttf-ms.*$/d;
			/^st$/d;
			/^dwm$/d;
			/^oracle-sqldeveloper$/d;
			' "$1" || return 1
		return 0
}

[ ! -d "$(dirname "$hostnameFile")" ] && getHelp

current_pkgs="$(pacman -Qqe | sort)"
case "$1" in
	-h)	getHelp ;;
	-g)
		echo "$current_pkgs" > "$hostnameFile"
		exit 0
		;;
	*)
		if [ -f "$1" ]; then
			targetFile="$1"
		else
			getHelp
		fi
		;;
esac

new_pkgs="$(comm -13 <(echo "$current_pkgs") <(filterMatches <(sort "$targetFile")))"
yayInstall "$new_pkgs" || exit 1

# must regenerate it again (because of last command)
current_pkgs="$(pacman -Qqe | sort)"
old_pkgs="$(filterMatches <(comm -23 <(echo "$current_pkgs") <(sort "$targetFile")))"
yayUninstall "$old_pkgs" || exit 1
