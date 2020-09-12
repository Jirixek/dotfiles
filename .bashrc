#!/bin/bash


. /usr/share/git/completion/git-prompt.sh
PS1_GIT='$(__git_ps1 "[%s]")\[\033[01;34m\]\$\[\033[00m\]'
PS1='\[\033[01;32m\]\u@\h\[\033[01;34m\] \w \[\033[01;33m\]'"$PS1_GIT "
[ "${EUID}" -eq 0 ] && PS1='\[\033[01;31m\]\h\[\033[01;34m\] \W \$\[\033[00m\]'"$PS1_GIT "

# Searching repos for unnamed commands
[ -e "/usr/share/doc/pkgfile/command-not-found.bash" ] && . /usr/share/doc/pkgfile/command-not-found.bash

# Kitty autocompletion
command -v kitty &>/dev/null && . <(kitty + complete setup bash)

[ -f ~/.bash_aliases ]           && . "${HOME}/.bash_aliases"
[ -f ~/.local/bin/shortcuts.sh ] && . "${HOME}/.local/bin/shortcuts.sh"
