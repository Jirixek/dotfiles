#!/bin/sh


prg=$(basename "$0")

getHelp() {
	echo "Usage: $prg [.tex file]"
	echo "Compile .tex file"
	exit 127
}

compileFile=''
if [ -f "$1" ]
then
	compileFile="$1"
else
	getHelp
fi

lualatex "$compileFile"
# luatex -fmt pdfcsplain "$compileFile"
# musixflx "$compileFile"
# luatex -fmt pdfcsplain "$compileFile"

# echo
# texcount "$compileFile"
