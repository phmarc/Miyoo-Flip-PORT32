#!/bin/bash

# Variables
# GAMEDIR="$(dirname "$0")"

cd "$(dirname "$0")"
FULL0="$PWD/$(basename "$0")"
export HOME=${FULL0%.*}
GAMEDIR=$HOME

# Exports
export LD_LIBRARY_PATH=/usr/lib:"$GAMEDIR/lib":$LD_LIBRARY_PATH
#export HOME="$GAMEDIR"

cd "$GAMEDIR"
# Run the game
./gptokeyb "gmloadernext" &
pm_platform_helper "$GAMEDIR/gmloadernext"
./gmloadernext

# Kill processes
pm_finish
