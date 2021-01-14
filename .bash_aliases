#!/bin/sh


# =================
#  Command mapping
# =================

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


# ===================
#  Directory mapping
# ===================
# Root
alias gR='cd "/"'
alias ge='cd "/etc/"'
alias gH='cd "/home/"'

alias gm.='cd "/mnt/"'
alias gmm='cd "/mnt/mrdky/"'
alias gmM='cd "/mnt/mrdky/Movies/"'
alias gmn='cd "/mnt/nas/"'
alias gmw='cd "/mnt/windows/"'

alias gr='cd "/run/media/$USER/"'

alias gV.='cd "/var/"'
alias gVl='cd "/var/lib/lxc/"'

# Home
alias gh='cd "$HOME/"'
alias gc='cd "$HOME/.config/"'

alias gl.='cd "$HOME/.local/"'
alias glb='cd "$HOME/.local/bin/"'
alias glS='cd "$HOME/.local/src/"'
alias gls='cd "$HOME/.local/suckless/"'
alias gla='cd "$HOME/.local/share/Anki2/Jiri Szkandera/collection.media/"'

alias gd.='cd "$HOME/Documents/"'
alias gdc='cd "$HOME/Documents/cvut/"'
alias gdf='cd "$HOME/Documents/faktury/"'
alias gdl='cd "$HOME/Documents/latex/"'
alias gdP='cd "$HOME/Documents/private/"'
alias gdp='cd "$HOME/Documents/programming/"'
alias gdw='cd "$HOME/Documents/workswell/"'

alias gD='cd "$HOME/Downloads/"'
alias gM='cd "$HOME/Music/"'
alias gp.='cd "$HOME/Pictures/"'
alias gps='cd "$HOME/Pictures/Screenshots/"'
alias gpm='cd "$HOME/Pictures/Memes/"'
alias gv='cd "$HOME/Videos/"'

# ======================
#  Fuzzy finder mapping
# ======================
# Current folder
alias f="fzf_mapping  './'"

# Root
alias fR="fzf_mapping  '/'"
alias fe="fzf_mapping  '/etc/'"
alias fH="fzf_mapping  '/home/'"

alias fm.="fzf_mapping '/mnt/'"
alias fmm="fzf_mapping '/mnt/mrdky/'"
alias fmM="fzf_mapping '/mnt/mrdky/Movies/'"
alias fmn="fzf_mapping '/mnt/nas/'"
alias fmw="fzf_mapping '/mnt/windows/'"

alias fr="fzf_mapping  \"/run/media/\$USER/\""

alias fv.="fzf_mapping '/var/'"
alias fvl="fzf_mapping '/var/lib/lxc/'"

# Home
alias fh="fzf_mapping  \"\$HOME/\""
alias fc="fzf_mapping  \"\$HOME/.config/\""

alias fl.="fzf_mapping \"\$HOME/.local/\""
alias flb="fzf_mapping \"\$HOME/.local/bin/\""
alias flS="fzf_mapping \"\$HOME/.local/src/\""
alias fls="fzf_mapping \"\$HOME/.local/suckless/\""
alias fla="fzf_mapping \"\$HOME/.local/share/Anki2/Jiri Szkandera/collection.media/\""

alias fd.="fzf_mapping \"\$HOME/Documents/\""
alias fdc="fzf_mapping \"\$HOME/Documents/cvut/\""
alias fdf="fzf_mapping \"\$HOME/Documents/faktury/\""
alias fdl="fzf_mapping \"\$HOME/Documents/latex/\""
alias fdP="fzf_mapping \"\$HOME/Documents/private/\""
alias fdp="fzf_mapping \"\$HOME/Documents/programming/\""
alias fdw="fzf_mapping \"\$HOME/Documents/workswell/\""

alias fD="fzf_mapping  \"\$HOME/Downloads/\""
alias fM="fzf_mapping  \"\$HOME/Music/\""
alias fp.="fzf_mapping \"\$HOME/Pictures/\""
alias fps="fzf_mapping \"\$HOME/Pictures/Screenshots/\""
alias fpm="fzf_mapping \"\$HOME/Pictures/Memes/\""
alias fv="fzf_mapping  \"\$HOME/Videos/\""
