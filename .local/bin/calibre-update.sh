#!/bin/sh


versionURL='https://code.calibre-ebook.com/latest'

currentVersion="$(calibre-debug -c 'import calibre; print (calibre.__version__)' | tr -d '.')"
if ! remoteVersion=$(curl -s --insecure "$versionURL" | tr -d '.')
then
	echo "Unable to reach '$versionURL'" >&2
	exit 1
fi

if [ "$currentVersion" = '' ] || [ "$remoteVersion" -gt "$currentVersion" ]
then
	# not installed or older version
	sudo -v && wget -nv -O- 'https://download.calibre-ebook.com/linux-installer.sh' | sudo sh /dev/stdin
else
	echo 'Calibre is up to date'
fi
