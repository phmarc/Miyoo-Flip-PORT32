#!/bin/bash

#export HOME=$(cd "$(dirname "$0")" && pwd)
#controlfolder="$(cd "$(dirname "$0")" && pwd)"/../PortMaster
#gamedir="$(cd "$(dirname "$0")" && pwd)"
#cd "$gamedir/"

cd "$(dirname "$0")"
FULL0="$PWD/$(basename "$0")"
export HOME=${FULL0%.*}
GAMEDIR=$HOME

controlfolder="$GAMEDIR/../PortMaster"
gamedir="$GAMEDIR"
cd "$gamedir"

# Grab text output...

# Setup mono
monodir="$HOME/mono"
monofile="$controlfolder/libs/mono-6.12.0.122-aarch64.squashfs"
mkdir -p "$monodir"
umount "$monofile" || true
mount "$monofile" "$monodir"

# Setup savedir

# Setup path and other environment variables
export MONOGAME_PATCH="$gamedir/dlls/StardewPatches.dll"
export MONO_PATH="$gamedir/dlls":"$gamedir"
export PATH="$monodir/bin":"$PATH"
export LD_LIBRARY_PATH="$gamedir/libs:$LD_LIBRARY_PATH"

# Delete older GL4ES installs...
rm -f $gamedir/libs/libGL.so.1 $gamedir/libs/libEGL.so.1

# Request libGL from Portmaster
export LIBGL_ES=2
export LIBGL_GL=21
export LIBGL_FB=4

if [ ! -e "/dev/dri/card0" ]; then
  export LIBGL_FB=2
fi

if [[ "$LIBGL_ES" != "" ]]; then
	export SDL_VIDEO_GL_DRIVER="${gamedir}/gl4es/libGL.so.1"
	export SDL_VIDEO_EGL_DRIVER="${gamedir}/gl4es/libEGL.so.1"
fi

# Jump into the gamedata dir now
cd "$gamedir/gamedata"

# Fix for the Linux builds, use mono-provided libraries instead.
# Exception for the System.Data.* assemblies, since Stardew needs
# xxHash types we would otherwise not provide.
mv System.Data*.dll "$gamedir/dlls"
rm -f MonoGame.Framework.* System*.dll

# Check if it's the Windows or Linux version
if [[ -f "Stardew Valley.exe" ]]; then
	gameassembly="Stardew Valley.exe"

	# Copy the Windows Stardew Valley WinAPI workarounds
	cp "${gamedir}/dlls/Stardew Valley.exe.config" "${gamedir}/gamedata/Stardew Valley.exe.config"
else
	gameassembly="StardewValley.exe"
fi

../gptokeyb -k "mono" &
mono ../SVLoader.exe "${gameassembly}" 2>&1 | tee "${gamedir}/log.txt"
kill -9 $(pidof gptokeyb)
umount "$monodir"


