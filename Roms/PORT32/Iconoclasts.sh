#!/bin/bash
# PORTMASTER: iconoclasts.zip, Iconoclasts.sh

#export HOME=$(cd "$(dirname "$0")" && pwd)
#GAMEDIR="$(cd "$(dirname "$0")" && pwd)"


cd "$(dirname "$0")"
FULL0="$PWD/$(basename "$0")"

export HOME=${FULL0%.*}
GAMEDIR=$HOME

export CHOWDREN_FPS=30
export LIBGL_FB_TEX_SCALE=0.5
export LIBGL_SKIPTEXCOPIES=1
export LIBGL_ES=2
export LIBGL_GL=21
export LIBGL_FB=4
export BOX86_LOG=1
export BOX86_ALLOWMISSINGLIBS=1
export BOX86_DLSYM_ERROR=1
export SDL_DYNAMIC_API="libSDL2-2.0.so.0"
export BOX86_LD_PRELOAD="$GAMEDIR/libIconoclasts.so"
export SDL_VIDEO_GL_DRIVER="$GAMEDIR/box86/native/libGL.so.1"
export SDL_VIDEO_EGL_DRIVER="$GAMEDIR/box86/native/libEGL.so.1"

export LD_LIBRARY_PATH="$GAMEDIR/box86/native":/usr/lib/arm-linux-gnueabihf/:/usr/lib32:/usr/config/emuelec/lib32:$LD_LIBRARY_PATH
export BOX86_LD_LIBRARY_PATH="$GAMEDIR/box86/lib":"$GAMEDIR/box86/native":"$GAMEDIR/gamedata/bin32":/usr/lib/arm-linux-gnueabihf/:./:lib/:lib/bin32/:x86/:$LD_LIBRARY_PATH

export BOX86_DYNAREC=1
export BOX86_FORCE_ES=31
export SDL_GAMECONTROLLERCONFIG="030000005e0400008e02000014010000,X360 Controller,a:b1,b:b0,back:b6,dpdown:h0.4,dpleft:h0.8,dpright:h0.2,dpup:h0.1,guide:b8,leftshoulder:b4,leftstick:b9,lefttrigger:a2,leftx:a0,lefty:a1,rightshoulder:b5,rightstick:b10,righttrigger:a5,rightx:a3,righty:a4,start:b7,x:b3,y:b2,platform:Linux,"
export BOX86_PATH="$GAMEDIR/gamedata/bin32"

# load user settings
source "$GAMEDIR/settings.txt"

cd $GAMEDIR/gamedata

$GAMEDIR/gptokeyb -k "box86" -c $GAMEDIR/iconoclasts.gptk &
$GAMEDIR/box86/box86 bin32/Chowdren 2>&1 | tee $GAMEDIR/log.txt

kill -9 $(pidof gptokeyb)

