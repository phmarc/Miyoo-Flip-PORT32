#!/bin/bash

export HOME=${0%.*}

GAMEDIR=$HOME

#cd $GAMEDIR

# Fix for the annoying folder structure while still working with the previous one.
#if [ -d "$GAMEDIR/gamedata/shovelknight/32" ]; then
#	cd $GAMEDIR/gamedata/shovelknight/32
#else
#	cd $GAMEDIR/gamedata/32
#fi

# Request libGL from Portmaster
export LIBGL_ES=2
export LIBGL_GL=21
export LIBGL_FB=4

# If the dri device does not exist, then let's not use
# the gbm backend.
if [ ! -e "/dev/dri/card0" ]; then
  export LIBGL_FB=2
fi
  export LD_LIBRARY_PATH="$GAMEDIR/gl4es":$LD_LIBRARY_PATH

if [ "$LIBGL_ES" != "" ]; then
	export SDL_VIDEO_EGL_DRIVER="$GAMEDIR/gl4es/libEGL.so.1"
	export SDL_VIDEO_GL_DRIVER="$GAMEDIR/gl4es/libGL.so.1"
fi

# Force-enable SDL2 JGUID fix, see: https://github.com/ptitSeb/box86/commit/a0a33896519
export BOX86_SDL2_JGUID=1
export LIBGL_NOBANNER=1
export BOX86_LOG=0
export BOX86_LD_PRELOAD="$GAMEDIR/libShovelKnight.so"
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:"$GAMEDIR":"$GAMEDIR/box86/native":"$GAMEDIR/box86/lib":/usr/lib:/usr/lib32:/usr/local/lib/arm-linux-gnueabihf
export BOX86_LD_LIBRARY_PATH="$GAMEDIR/box86/lib":"$GAMEDIR/box86/native":/usr/lib32/:./:lib/:lib32/:x86/
export BOX86_DYNAREC=1
export SDL_GAMECONTROLLERCONFIG="030000005e0400008e02000014010000,X360 Controller,a:b1,b:b0,back:b6,dpdown:h0.4,dpleft:h0.8,dpright:h0.2,dpup:h0.1,guide:b8,leftshoulder:b4,leftstick:b9,lefttrigger:a2,leftx:a0,lefty:a1,rightshoulder:b5,rightstick:b10,righttrigger:a5,rightx:a3,righty:a4,start:b7,x:b3,y:b2,platform:Linux,"

export BOX86_PATH="$GAMEDIR/gamedata/shovelknight/32"
cd "$GAMEDIR/gamedata/shovelknight/32"

"$GAMEDIR/gptokeyb" -k "ShovelKnight" -c "$GAMEDIR/shovelknight.gptk" &
"$GAMEDIR/box86/box86" ./ShovelKnight 2>&1 | tee "$GAMEDIR/log.txt"
#"$GAMEDIR/box86/box86" "$GAMEDIR/gamedata/shovelknight/32/ShovelKnight" | tee "$GAMEDIR/log.txt"

# Cleanup
kill -9 $(pidof gptokeyb)
#systemctl restart oga