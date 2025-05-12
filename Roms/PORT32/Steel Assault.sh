#!/bin/bash

#定位遊戲文件夾到當前目錄
#GAMEDIR="$(cd "$(dirname "$0")" && pwd)"
#定位遊戲存檔跟配置位置到當前目錄
#export HOME=$(cd "$(dirname "$0")" && pwd)
#定位PortMaster目錄
#controlfolder="$(cd "$(dirname "$0")" && pwd)"/../PortMaster
#cd "$GAMEDIR/gamedata"

cd "$(dirname "$0")"
FULL0="$PWD/$(basename "$0")"
export HOME=${FULL0%.*}
GAMEDIR=$HOME

controlfolder="$GAMEDIR/../PortMaster"
cd "$GAMEDIR/gamedata"


"$GAMEDIR/cpufreq.sh"
"$GAMEDIR/cpuswitch.sh"
# 掛載 mono
#定位mono掛載文件夾
monodir="$HOME/mono"
#定位mono文件
monofile="$controlfolder/libs/mono-6.12.0.122-aarch64.squashfs"
#如果沒有mono文件夾就建立
mkdir -p "$monodir"
#先確保沒有其他mono組件被掛載
umount "$monofile" || true
#將mono組件掛載到文件夾
mount "$monofile" "$monodir"


# Remove all the dependencies in favour of system libs - e.g. the included 
# newer version of FNA with patcher included
rm -f System*.dll mscorlib.dll FNA.dll Mono.*.dll

# Setup path and other environment variables
# export FNA_PATCH="$GAMEDIR/dlls/SteelAssaultPatches.dll"
export MONO_PATH="$GAMEDIR/dlls"
export LD_LIBRARY_PATH="$GAMEDIR/libs":/usr/config/emuelec/lib32:/usr/lib32:$LD_LIBRARY_PATH
export PATH="$monodir/bin":$PATH

export FNA3D_FORCE_MODES=800x480
export FNA3D_FORCE_DRIVER=OpenGL
export FNA3D_OPENGL_FORCE_ES3=1

#放一個gptokeyb進來然後把$GPTOKEYB改成$GAMEDIR/gptokeyb -k
"$GAMEDIR/gptokeyb" -k "mono" &
mono SteelAssaultCs.exe 2>&1 | tee "$GAMEDIR/log.txt"
kill -9 $(pidof gptokeyb)
#卸載mono組件
umount "$monodir"
unset LD_LIBRARY_PATH

