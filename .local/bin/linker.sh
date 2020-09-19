#!/bin/bash


if [ "$(id -u)" -eq 0 ]; then
	echo "Please don't run as root." >&2
	exit 2
fi

getHelp() {
	echo "Usage: $(basename "$0") [OPTIONS]"
	echo "Auxiliary script to update ./src files"
	echo
	echo "Options:"
	echo "-r        Read: copy SYSTEM files to .src"
	echo "-w        Write: copy .src files to SYSTEM"
	exit 127
}

CURRENTFOLDER="$(dirname "$0")"

(
cd "$CURRENTFOLDER"/../src || {
	echo "Can't enter ${HOME}/.local/src" >&2
	exit 1
}

case "$1" in
	-r)
		find etc/ -type f -exec cp -v /"{}" "{}" \;
		find usr/ -type f -exec cp -v /"{}" "{}" \;

		# Firefox
		for dir in ~/.mozilla/firefox/*-release; do
			if [ -d "$dir" ]; then
				cp -v "$dir"/prefs.js home/.mozilla/firefox/release/
				cp -rv "$dir"/chrome home/.mozilla/firefox/release/
			fi
		done

		# Thunderbird
		for dir in ~/.thunderbird/*-release; do
			if [ -d "$dir" ]; then
				cp -v "$dir"/prefs.js home/.thunderbird/release/
			fi
		done

		;;
	-w)
		find etc/ -type f -print0 | xargs -0 -I{} dirname {} | xargs -I{} sudo mkdir -p /"{}"
		sudo find etc/ -type f -exec cp -v "{}" /"{}" \;

		find usr/ -type f -print0 | xargs -0 -I{} dirname {} | xargs -I{} sudo mkdir -p /"{}"
		sudo find usr/ -type f -exec cp -v "{}" /"{}" \;

		# Firefox
		for dir in ~/.mozilla/firefox/*-release; do
			if [ -d "$dir" ]; then
				cp -rv home/.mozilla/firefox/release/* "$dir"
			fi
		done

		# Thunderbird
		for dir in ~/.thunderbird/*-release; do
			if [ -d "$dir" ]; then
				cp -v home/.thunderbird/release/* "$dir"
			fi
		done

		# change sh shell to dash
		sudo ln -sf /bin/dash /bin/sh
		;;
	*)
		getHelp
		;;
esac
)
