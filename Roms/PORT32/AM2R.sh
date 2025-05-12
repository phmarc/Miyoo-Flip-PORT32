#!/bin/sh

GAMEDIR=${0%.*}
cd $GAMEDIR
export HOME=$GAMEDIR/conf
export LD_LIBRARY_PATH="$GAMEDIR/libs:$LD_LIBRARY_PATH"

$GAMEDIR/gptokeyb -k "gmloader" -c "$GAMEDIR/gmloader.gptk" &
$GAMEDIR/gmloader gamedata/am2r.apk 2>&1 | tee $GAMEDIR/log.txt

# clean up
kill -9 $(pidof gptokeyb) 


