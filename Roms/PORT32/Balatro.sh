#!/bin/bash

#cd $(dirname "$0")

HOME=./
GAMEDIR=${0%.*}

LD_LIBRARY_PATH=$GAMEDIR/lib:$LD_LIBRARY_PATH

cd $HOME

$GAMEDIR/love $GAMEDIR/Balatro.love 2>&1 | tee $GAMEDIR/log.txt

unset LD_LIBRARY_PATH