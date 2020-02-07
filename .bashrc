#!/bin/bash


# If not running interactively, don't do anything
[[ $- != *i* ]] && return

source /usr/share/git/completion/git-prompt.sh

PS1='\[\033[01;32m\]\u@\h\[\033[01;34m\] \w \[\033[01;33m\]$(__git_ps1 "[%s]")\[\033[01;34m\]\$\[\033[00m\] '
if [ ${EUID} -eq 0 ]
then
	PS1='\[\033[01;31m\]\h\[\033[01;34m\] \W \$\[\033[00m\] '
elif [ -n "$RANGER_LEVEL" ]
then
	PS1="[r] $PS1"
fi

# searching repos for unnamed commands
[ -e "/usr/share/doc/pkgfile/command-not-found.bash" ] && source /usr/share/doc/pkgfile/command-not-found.bash

# kitty autocompletion
command -v kitty &>/dev/null && source <(kitty + complete setup bash)

[ -f ~/.bash_aliases ]           && source "${HOME}/.bash_aliases"
[ -f ~/.local/bin/shortcuts.sh ] && source "${HOME}/.local/bin/shortcuts.sh"
