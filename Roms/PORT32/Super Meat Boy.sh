#!/bin/bash
# PORTMASTER: supermeatboy.zip, Super Meat Boy.sh


#export HOME=$(cd "$(dirname "$0")" && pwd)
#GAMEDIR=$(cd "$(dirname "$0")" && pwd)

BINARYNAME="SuperMeatBoy"

export HOME=${0%.*}
GAMEDIR=$HOME
CONFDIR="$GAMEDIR/conf/"

cd $GAMEDIR
mkdir -p "$GAMEDIR/conf"

# Set the XDG environment variables for config & savefiles
export XDG_DATA_HOME="$CONFDIR"

# If there isn't a config file present, copy the default one to avoid volume sliders being set to zero
if [ ! -f "$GAMEDIR/conf/SuperMeatBoy/UserData/reg0.dat" ] && [ ! -f "$GAMEDIR/gamedata/userdata/reg0.dat" ]; then
  echo "Can't locate a configuration file. Importing a default."
  cp "$GAMEDIR/conf/SuperMeatBoy/UserData/reg0.default" "$GAMEDIR/conf/SuperMeatBoy/UserData/reg0.dat"
fi

# Setup gl4es

export LIBGL_ES=2
export LIBGL_GL=21
export LIBGL_FB=4

# If the dri device does not exist, then let's not use
# the gbm backend.
if [ ! -e "/dev/dri/card0" ]; then
  export LIBGL_FB=2
fi
  export LD_LIBRARY_PATH="$PWD/gl4es:$LD_LIBRARY_PATH"


cd "$GAMEDIR/gamedata"

# determine best output resolution based on device CPU or RAM
output_res=640x480
detail_level="lowdetail"


# uncomment these to manually override output settings:
#output_res="320x240"
#detail_level="ultralowdetail"
echo "Setting game resolution to $output_res, detail level to $detail_level"

# uncomment this to select ingame language. Default is US English (en_US.UTF8) eg: Brazilian Portuguese (pt_BR.UTF8):
#export LANG=pt_BR.UTF8
echo "Game language is set to $LANG"

# Setup Box86
export BOX86_ALLOWMISSINGLIBS=1
export BOX86_LOG=1
export BOX86_DLSYM_ERROR=1
export BOX86_SHOWSEGV=1
export BOX86_SHOWBT=1
export BOX86_DYNAREC=1

export LD_LIBRARY_PATH="$GAMEDIR/box86/native":"/usr/lib/arm-linux-gnueabihf/":"/usr/lib32":"$GAMEDIR/libs/":"$LD_LIBRARY_PATH"
export BOX86_LD_LIBRARY_PATH="$GAMEDIR/box86/x86":"$GAMEDIR/box86/native":"$GAMEDIR/libs/x86":"$GAMEDIR/gamedata/x86"

if [ "$LIBGL_FB" != "" ]; then
export SDL_VIDEO_GL_DRIVER="$GAMEDIR/gl4es/libGL.so.1"
fi

export SDL_GAMECONTROLLERCONFIG="030000005e0400008e02000014010000,X360 Controller,a:b1,b:b0,back:b6,dpdown:h0.4,dpleft:h0.8,dpright:h0.2,dpup:h0.1,guide:b8,leftshoulder:b4,leftstick:b9,lefttrigger:a2,leftx:a0,lefty:a1,rightshoulder:b5,rightstick:b10,righttrigger:a5,rightx:a3,righty:a4,start:b7,x:b3,y:b2,platform:Linux,"
export TEXTINPUTINTERACTIVE="Y"

"$GAMEDIR/gptokeyb" -k "box86" xbox360 &
"$GAMEDIR/box86/box86" "$GAMEDIR/gamedata/x86/$BINARYNAME" -$output_res -$detail_level -fullscreen | tee $GAMEDIR/log.txt

kill -9 $(pidof gptokeyb)
printf "\033c" > /dev/tty0

