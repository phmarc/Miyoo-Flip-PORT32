#!/bin/bash
# PORTMASTER: undertale.zip, Undertale.sh


#export HOME=$(cd "$(dirname "$0")" && pwd)
#GAMEDIR=$(cd "$(dirname "$0")" && pwd)/Undertale

HOME=${0%.*}
GAMEDIR=$HOME
LIBDIR="$GAMEDIR/lib32"
BINDIR="$GAMEDIR/box86"

# gl4es
export LIBGL_FB=4

# system
export LD_LIBRARY_PATH="$LIBDIR:/usr/lib32:/usr/local/lib/arm-linux-gnueabihf:$LD_LIBRARY_PATH"

# box86
export BOX86_ALLOWMISSINGLIBS=1
export BOX86_LD_LIBRARY_PATH="$LIBDIR"
export BOX86_LIBGL="$LIBDIR/libGL.so.1"
export BOX86_PATH="$BINDIR"


cd $GAMEDIR
export SDL_GAMECONTROLLERCONFIG="030000005e0400008e02000014010000,X360 Controller,a:b1,b:b0,back:b6,dpdown:h0.4,dpleft:h0.8,dpright:h0.2,dpup:h0.1,guide:b8,leftshoulder:b4,leftstick:b9,lefttrigger:a2,leftx:a0,lefty:a1,rightshoulder:b5,rightstick:b10,righttrigger:a5,rightx:a3,righty:a4,start:b7,x:b3,y:b2,platform:Linux,"

./gptokeyb -k "box86" -c "$GAMEDIR/undertale.gptk" &
$GAMEDIR/box86/box86 $GAMEDIR/runner 2>&1 | tee $GAMEDIR/log.txt

kill -9 $(pidof gptokeyb)
unset LD_LIBRARY_PATH