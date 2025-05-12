#!/bin/bash

#cd $(dirname "$0")

cd "$(dirname "$0")"
FULL0="$PWD/$(basename "$0")"
export HOME=${FULL0%.*}
GAMEDIR=$HOME

cd "$GAMEDIR"

export SDL_GAMECONTROLLERCONFIG_FILE="../PortMaster/gamecontrollerdb.txt"
#export HOME="$(dirname "$0")"
#GAMEDIR="$(dirname "$0")"
export LD_LIBRARY_PATH="$GAMEDIR/libs":$LD_LIBRARY_PATH
./gptokeyb -k "wipegame" -c "wipeout.gptk" &
LIBGL_FB=4 LIBGL_ES=2 LIBGL_GL=21 ./wipegame 2>&1 | tee $GAMEDIR/log.txt
kill -9 $(pidof gptokeyb)

