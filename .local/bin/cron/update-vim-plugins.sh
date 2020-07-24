#!/bin/sh


if nmcli device | grep -wE 'ethernet|wifi' | grep -wq 'connected'
then
	nvim -es -u "$XDG_CONFIG_HOME"/nvim/init.vim -i NONE -c "PlugUpdate"
fi
