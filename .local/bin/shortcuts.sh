#!/bin/bash


v () {
	# disable <C-s> and <C-q> in $EDITOR
	stty -ixon && "$EDITOR" "$@" && stty ixon
	return 0
}

r () {
	# setup ranger so it cds to directory when exited
	local tempfile
	tempfile="$(mktemp --tmpdir=/tmp)" || {
		echo "Can't create tmpfile" >&2
			return 2
		}
	ranger --choosedir="$tempfile" "$@"
	flag=0
	cd "$(cat "$tempfile")" || flag=1
	rm -f "$tempfile"
	return "$flag"
}

cc () {
	# compile .c/.cpp file when changed
	compileFile=''
	for i
	do
		if [ -f "$i" ]
		then
			compileFile="$i"
			break
		fi
	done

	if [ -n "$compileFile" ]
	then
		entr -c g++.sh -x "$@" <<<"$compileFile"
	else
		echo "Can't find file to keep watching" >&2
		return 1
	fi
	return 0
}

cl () {
	if [ ! -f "$1" ]
	then
		echo "Can't find file to keep watching" >&2
		return 1
	fi

	printf '%s\n' "$@" | entr -rc tex.sh "$1"

	return 0
}

fs () {
	local TARGETDIR="$HOME/.local/bin/"
	cd "$TARGETDIR" || return 1
	local TARGET=''
	TARGET="$(find . -name '[^.]*' -type f | sed 's|^\./||' | fzf)" && "$EDITOR" "$TARGET"
	return 0
}

fk () {
	local TARGETDIR="$HOME/Documents/cvut/"
	cd "$TARGETDIR" || return 1
	local TARGET=''
	TARGET="${TARGETDIR}$(find "$TARGETDIR" -mindepth 1 -maxdepth 1 -type d -name '[^.]*' -printf '%f\n' | fzf)" && "$FILE" "$TARGET"
	return 0
}

extract () {
	if [ -f "$1" ]
	then
		NEWDIR="$(basename "$1" | sed -E 's/\..+//')"
		case "$1" in
			*.tar.bz2) mkdir -p "$NEWDIR" && tar --directory="$NEWDIR" -xvjf "$1" ;;
			*.tbz2)    mkdir -p "$NEWDIR" && tar --directory="$NEWDIR" -xvjf "$1" ;;
			*.tar.gz)  mkdir -p "$NEWDIR" && tar --directory="$NEWDIR" -xvzf "$1" ;;
			*.tgz)     mkdir -p "$NEWDIR" && tar --directory="$NEWDIR" -xvzf "$1" ;;
			*.tar)     mkdir -p "$NEWDIR" && tar --directory="$NEWDIR" -xvf "$1"  ;;
			*.bz2)     bunzip2 "$1"                                               ;;
			*.gz)      gunzip "$1"                                                ;;
			*.rar)     unrar "$1" "$NEWDIR"                                       ;;
			*.zip)     unzip -d "$NEWDIR" "$1"                                    ;;
			*.Z)       uncompress "$1"                                            ;;
			*.7z)      7z "$1"                                                    ;;
			*)
				echo "don't know how to extract '$1'..." >&2
				return 2
				;;
	esac
else
	echo "'$1' is not a valid file!" >&2
	return 2
	fi
	return 0
}
