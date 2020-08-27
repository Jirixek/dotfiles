# Profile file. Runs on login. Environmental variables are set here.

export PATH="$(find "${HOME}/.local/bin/" -maxdepth 1 -type d -printf '%p:')$PATH"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"

# Increase history size
export HISTSIZE=10000
export HISTFILESIZE=10000
export HISTCONTROL=erasedups

# Default programs:
export OPENER='mimeopen'
export EDITOR='nvim'
export VISUAL='nvim'
export SUDO_EDITOR='nvim'
export TERMINAL='kitty'
export BROWSER='firefox'
export READER='evince'
export FILE='f'

# ~/ Clean-up:
export GTK2_RC_FILES="$HOME/.config/gtk-2.0/gtkrc-2.0"
# export GTK_THEME='Adwaita:dark'
export LESSHISTFILE='-'
export GNUPGHOME="$XDG_DATA_HOME"/gnupg
export _JAVA_OPTIONS=-Djava.util.prefs.userRoot="$XDG_CONFIG_HOME"/java
export MATHEMATICA_USERBASE="$XDG_CONFIG_HOME"/mathematica
export NPM_CONFIG_USERCONFIG=$XDG_CONFIG_HOME/npm/npmrc
export WGETRC="$XDG_CONFIG_HOME/wgetrc"
export XINITRC="$XDG_CONFIG_HOME"/X11/xinitrc

# Other program settings:
export FZF_DEFAULT_OPTS='--layout=reverse --height 40%'
export LESS='-R'
export LESS_TERMCAP_mb='[1;31m'
export LESS_TERMCAP_md='[1;34m'
export LESS_TERMCAP_me='[0m'
export LESS_TERMCAP_so='[01;44;33m'
export LESS_TERMCAP_se='[0m'
export LESS_TERMCAP_us='[1;32m'
export LESS_TERMCAP_ue='[0m'

# Kvuli SQLdeveloperu
export _JAVA_AWT_WM_NONREPARENTING=1

# Git
export GIT_PS1_SHOWDIRTYSTATE=1
export GIT_PS1_SHOWSTASHSTATE=1
export GIT_PS1_SHOWUNTRACKEDFILES=1
export GIT_PS1_SHOWUPSTREAM="auto verbose"

# Make
export MAKEFLAGS="-j$(nproc)"

# CppUTest
export CPPUTEST_HOME="$HOME/.local/cpputest"
