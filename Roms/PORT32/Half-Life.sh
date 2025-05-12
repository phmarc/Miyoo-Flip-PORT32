#!/bin/sh
cd "$(dirname "$0")"
FULL0="$PWD/$(basename "$0")"
export HOME=${FULL0%.*}
GAMEDIR=$HOME

export SDL_GAMECONTROLLERCONFIG_FILE="../PortMaster/gamecontrollerdb.txt"
export LD_LIBRARY_PATH="$GAMEDIR/libs":$LD_LIBRARY_PATH

cd "$GAMEDIR"
./gptokeyb -k "xash3d" &
HOME=./ ./xash3d -ref gles2 -fullscreen -console
kill -9 $(pidof gptokeyb) 

