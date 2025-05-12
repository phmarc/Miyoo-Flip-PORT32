#!/bin/sh
#cd $(dirname "$0")
#GAMEDIR="$(dirname "$0")"

cd "$(dirname "$0")"
FULL0="$PWD/$(basename "$0")"
export HOME=${FULL0%.*}
GAMEDIR=$HOME

#HOME="$GAMEDIR"

cd "$GAMEDIR"

./gptokeyb -k "RSDKv5" &
LD_LIBRARY_PATH="$GAMEDIR/libs:$LD_LIBRARY_PATH" SDL_GAMECONTROLLERCONFIG_FILE="./gamecontrollerdb.txt" ./RSDKv5 2>&1 | tee $GAMEDIR/log.txt
kill -9 $(pidof gptokeyb)
