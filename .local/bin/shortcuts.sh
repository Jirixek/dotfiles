#!/bin/bash


v () {
	# disable <C-s> and <C-q> in $EDITOR
	stty -ixon && "$EDITOR" "$@" && stty ixon
}

f () {
	# setup lf so it changes to the last directory when exited
	local tempfile
	tempfile="$(mktemp)" || {
		echo "Can't create tmpfile" >&2
		return 1
	}
	lf -last-dir-path="$tempfile" "$@"
	[ ! -f "$tempfile" ] && return 1

	dir="$(cat "$tempfile")"
	rm -f "$tempfile"
	[ -d "$dir" ] && [ "$dir" != "$(pwd)" ] && cd "$dir" || return
}

cc () {
	# compile .c/.cpp file when changed
	compileFile=''
	for i in "$@"; do
		if [ -f "$i" ]; then
			compileFile="$i"
			break
		fi
	done

	if [ -n "$compileFile" ]; then
		entr -c g++.sh -x "$@" <<<"$compileFile"
	else
		echo "Can't find file to keep watching" >&2
		return 1
	fi
}

cl () {
	if [ ! -f "$1" ]; then
		echo "Can't find file to keep watching" >&2
		return 1
	fi

	printf '%s\n' "$@" | entr -rc tex.sh "$1"
}

fs () {
	local TARGETDIR="$HOME/.local/bin/"
	cd "$TARGETDIR" || return
	local TARGET=''
	TARGET="$(find . -name '[^.]*' -type f | sed 's|^\./||' | fzf)" && "$EDITOR" "$TARGET"
}

fk () {
	local TARGETDIR="$HOME/Documents/cvut/"
	cd "$TARGETDIR" || return
	local TARGET=''
	TARGET="${TARGETDIR}$(find "$TARGETDIR" -mindepth 1 -maxdepth 1 -type d -name '[^.]*' -printf '%f\n' | fzf)" && "$FILE" "$TARGET"
}
