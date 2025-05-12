#!/bin/bash

#GAMEDIR="$(cd "$(dirname "$0")" && pwd)"

cd "$(dirname "$0")"
FULL0="$PWD/$(basename "$0")"

export HOME=${FULL0%.*}
GAMEDIR=$HOME

cd "$GAMEDIR"
export LD_LIBRARY_PATH="$GAMEDIR"/lib:/usr/lib:/usr/lib32:$LD_LIBRARY_PATH
export GMLOADER_DEPTH_DISABLE=1
export GMLOADER_SAVEDIR="$GAMEDIR/gamedata/"

mv gamedata/data.win gamedata/game.droid
mv gamedata/game.unx gamedata/game.droid

$GAMEDIR/gptokeyb -k "gmloader" -c "$GAMEDIR/valhalla.gptk" &
$GAMEDIR/gmloader ./valhallawrapper.apk 2>&1 | tee $GAMEDIR/log.txt

# clean up
kill -9 "$(pidof gptokeyb)"
