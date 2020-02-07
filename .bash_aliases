#
# ~/.bash_aliases
#

# XDG Cleanup
alias nvidia-settings='nvidia-settings --config="$XDG_CONFIG_HOME"/nvidia/settings'
alias wget='wget --hsts-file="$XDG_CACHE_HOME/wget-hsts"'

# Enable color
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias diff='diff --color=auto'
alias watch='watch --color'

# General
alias youtube-dl='youtube-dl -f bestvideo+bestaudio'
alias l='ls -lh'
alias la='ls -lha'
alias nvim='v'
alias vim='v'
alias df='df -h'

# Dotfiles
alias dfl='/usr/bin/git --git-dir=$HOME/.dotfiles.git/ --work-tree=$HOME'
alias dpull="dfl pull --recurse-submodules origin master && dfl submodule foreach --recursive 'git checkout master && git pull'"
alias dpush='dfl push origin master'
