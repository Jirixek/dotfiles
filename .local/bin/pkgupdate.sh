#!/bin/bash


hostnameFile="$(dirname "$0")/../src/pkglist_${HOSTNAME}.txt"
ignoreFile="$(dirname "$0")/../src/pkglistignore.txt"

getHelp() {
	echo "Usage: $(basename "$0") [OPTIONS] [FILES]"
	echo "Auxiliary script to help manage ./src/pkglist.txt"
	echo
	echo "Options:"
	echo "-g [INPUT] [OUTPUT]      Generate file without drivers and other machine specifis packages"
	echo "[SOURCE]                 Install packages that are missing on local system acording to given file"
	exit 127
}

yayInstall () {
	[ -n "$1" ] && echo "$1" | yay -Syu --needed "${install_flags[@]}" -
}

yayUninstall () {
	[ -n "$1" ] && echo "$1" | sudo pacman -Rnus -
}

filterMatches () {
	filter="$(sed 's/.*/\/&\/d;/' "$ignoreFile")"
	sed -E "$filter" "$1"
}

[ ! -d "$(dirname "$hostnameFile")" ] && getHelp

current_pkgs="$(pacman -Qqe | sort)"
install_flags=()
while [ "$#" -gt 0 ]; do
	case "$1" in
		-h)	getHelp ;;
		-g)
			echo "$current_pkgs" > "$hostnameFile"
			exit
			;;
		--noconfirm)
			install_flags=("${install_flags[@]}" "$1")
			shift
			;;
		*)
			if [ -f "$1" ]; then
				targetFile="$1"
			else
				getHelp
			fi
			shift
			;;
	esac
done

[ ! -f "$targetFile" ] && getHelp

new_pkgs="$(comm -13 <(echo "$current_pkgs") <(filterMatches <(sort "$targetFile")))"
yayInstall "$new_pkgs"

# must regenerate it again (because of last command)
current_pkgs="$(pacman -Qqe | sort)"
old_pkgs="$(filterMatches <(comm -23 <(echo "$current_pkgs") <(sort "$targetFile")))"
yayUninstall "$old_pkgs"
