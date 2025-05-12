#!/bin/bash

#export HOME=$(cd "$(dirname "$0")" && pwd)
#GAMEDIR=$(cd "$(dirname "$0")" && pwd)

cd "$(dirname "$0")"
FULL0="$PWD/$(basename "$0")"

export HOME=${FULL0%.*}
GAMEDIR=$HOME

export LD_LIBRARY_PATH="$GAMEDIR/libs":/usr/lib32:/usr/local/lib/arm-linux-gnueabihf/

cd "$GAMEDIR"
./gptokeyb -k "bgdi" -c "$GAMEDIR/sorr.gptk" &

#./bgdi $(find "$GAMEDIR" -type f -iname "sorr.dat) 2>&1 | tee "$GAMEDIR/log.txt"
./bgdi ./SorR.dat 2>&1 | tee "$GAMEDIR/log.txt"
kill -9 $(pidof gptokeyb)

unset LD_LIBRARY_PATH

