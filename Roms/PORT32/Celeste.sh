#!/bin/sh

#echo $0 $*
#export HOME=/mnt/SDCARD/App/Celeste

export HOME=${0%.*}

GAMEDIR=$HOME

#GAMEDIR=${PWD}
#only dirname, SAME

#DIRNAME=${GAMEDIR##*/}
#DIRNAME=$(basename ${PWD})
#echo game dir name is:  $DIRNAME

PORT_DIR=${GAMEDIR%/*}
echo parent is: $PORT_DIR

#controlfolder="../PortMaster"
#controlfolder=/mnt/SDCARD/Roms/PORTS/Data/PortMaster

controlfolder="$HOME/../PortMaster"
source $controlfolder/control.txt
#source $controlfolder/tasksetter
get_controls


gamedir="$GAMEDIR"
gameassembly="Celeste.exe"
cd "$gamedir/gamedata"

echo $controlfolder
# Grab text output...
$ESUDO chmod 666 /dev/tty0
printf "\033c" > /dev/tty0
echo "Loading... Please Wait." > /dev/tty0

# Setup mono
monodir="$GAMEDIR/mono"
monofile="$controlfolder/libs/mono-6.12.0.122-aarch64.squashfs"
$ESUDO mkdir -p "$monodir"
$ESUDO umount "$monodir" || true
$ESUDO mount -t squashfs "$monofile" "$monodir"

# Setup savedir
#$ESUDO rm -rf ~/.local/share/Celeste
#mkdir -p ~/.local/share
#ln -sfv "$gamedir/savedata" ~/.local/share/Celeste

# Remove all the dependencies in favour of system libs - e.g. the included 
# newer version of FNA with patcher included
rm -f System*.dll mscorlib.dll FNA.dll Mono.*.dll
cp $gamedir/libs/Celeste.exe.config $gamedir/gamedata

# Setup path and other environment variables

export FNA_PATCH="$gamedir/dlls/CelestePatches.dll"
export MONO_PATH="$gamedir/dlls"
export LD_LIBRARY_PATH="$gamedir/libs":"${monodir}/lib":$LD_LIBRARY_PATH
export PATH="$monodir/bin":"$PATH"
export FNA3D_OPENGL_FORCE_ES3=1
export FNA3D_OPENGL_FORCE_VBO_DISCARD=1

# Compress all textures with ASTC codec, bringing massive vram gains
if [[ ! -f "$gamedir/.astc_done" ]]; then
	echo "Optimizing textures..." >> /dev/tty0
	"$gamedir/celeste-repacker" "$gamedir/gamedata/Content/Graphics/" --install >> /dev/tty0
	if [ $? -eq 0 ]; then
		touch "$gamedir/.astc_done"
	fi
fi

# first_time_setup
$GPTOKEYB "mono" &
$TASKSET mono Celeste.exe 2>&1 | tee log.txt



$ESUDO kill -9 $(pidof gptokeyb)
#$ESUDO systemctl restart oga_events &
$ESUDO umount "$monodir"

# Disable console
printf "\033c" >> /dev/tty1
