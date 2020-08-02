#!/bin/bash


v () {
	# disable <C-s> and <C-q> in $EDITOR
	stty -ixon && "$EDITOR" "$@" && stty ixon
	return 0
}

f () {
	# setup lf so it changes to the last directory when exited
	local tempfile
	tempfile="$(mktemp)" || {
		echo "Can't create tmpfile" >&2
		return 2
	}
	lf -last-dir-path="$tempfile" "$@"
	[ ! -f "$tempfile" ] && return 2

	dir="$(cat "$tempfile")"
	rm -f "$tempfile"
	[ -d "$dir" ] && [ "$dir" != "$(pwd)" ] && cd "$dir" || return 1
	return 0
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
