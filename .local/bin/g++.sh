#!/bin/bash


# Created by Jiri Szkandera
# Compile .c/.cpp program and execute unit tests accordingly

prg="$(basename "$0")"
SRCFOLDER="$(dirname "$0")"/../src/

getHelp() {
	echo "Usage: $prg [OPTIONS] [FILE]"
	echo "Compile .c/.cpp program and execute unit tests accordingly"
	echo
	echo "Options:"
	echo "-h      Show this help"
	echo "-d      Specify directory with unit tests (if not supplied, $prg will just execute given program)"
	echo "-c      Compile only (do not execute, just COMPILE a program)"
	echo "-x      Execute only (do not compile, just EXECUTE a program)"
	echo "-m      Disable memory debugger"
	echo "-O      Compile with optimization (O2)"
	exit 127
}

compile () {
	readarray -t FLAGS <"$SRCFOLDER"/cpp_compilation_flags.txt
	readarray -t LIBS <"$SRCFOLDER"/cpp_library_flags.txt

	if [ -f "$PWD/Makefile" ]; then
		make
	else
		[ "$memdebug" = 'true' ]     && FLAGS=("${FLAGS[@]}" "-g" "-fsanitize=address")
		[ "$optimization" = 'true' ] && FLAGS=("${FLAGS[@]}" "-O2")
		g++ "${FLAGS[@]}" "$compileFile" -o "$executeFile" "${LIBS[@]}"
	fi
}

compile='true'
execute='true'
memdebug='true'
optimization='false'

compileFile=''
executeFile=''
testDir=''

while [ "$#" -gt 0 ]; do
	case "$1" in
		-h)	getHelp ;;
		-d)
			# testdir
			shift
			if [ -d "$1" ]; then
				testDir="$1"
			else
				echo "$1 is not a directory." >&2
				exit 1
			fi
			shift
			;;
		-c)
			# compile only
			compile='true'
			execute='false'
			shift
			;;
		-x)
			# execute only
			compile='false'
			execute='true'
			shift
			;;
		-m)
			memdebug='false'
			shift
			;;
		-O)
			optimization='true'
			shift
			;;
		*)
			if [ -f "$1" ]; then
				if [ "$compile" = 'false' ]; then
					executeFile="$1"
				else
					compileFile="$1"
					executeFile="${compileFile%.*}"
				fi
			else
				echo "Invalid option: '$1'" >&2
				echo "Try '$prg -h' for more information." >&2
				exit 1
			fi
			shift
			break
			;;
	esac
done

if [ "$compile" = 'true' ] && [ ! -f "$compileFile" ]; then
	echo "'$compileFile' is not a file." >&2
	exit 1
fi

if [ "$compile" = 'false' ] && [ ! -x "$executeFile" ]; then
	echo "'$executeFile' not executable." >&2
	exit 1
fi

if [ "$execute" = 'false' ]; then
	compile
elif [ "$compile" = 'false' ] || compile; then
	if [ -d "$testDir" ]; then
		# unit tests
		for i in "$testDir"/*_in.txt; do
			outCMP="${i%_in.txt}_cmp.txt"
			outREF="${i%_in.txt}_ref.txt"

			/usr/bin/time --quiet -f "$i\t\tuser: %U s\tmemory: %M kB" ./"$executeFile" "$@" < "$i" > "$outCMP"
			diff --color="always" "$outCMP" "$outREF"
		done
	else
		# case without unit tests, just execute program
		/usr/bin/time --quiet -f "user: %U s\tmemory: %M kB" ./"$executeFile" "$@"
	fi
else
	exit 2
fi
