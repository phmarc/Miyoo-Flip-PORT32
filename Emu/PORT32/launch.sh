#!/bin/bash

#echo $0 $*
PROGDIR=`dirname "$0"`
PORT32DIR="/mnt/sdcard/Roms/PORT32"
ROMNAME="$1"
BASEROMNAME=${ROMNAME##*/}
ROMNAMETMP=${BASEROMNAME%.*}
ROMNAMEESC="${ROMNAMETMP// /\\ }" 

cd $PROGDIR

#debug
echo $ROMNAME,$BASEROMNAME,$ROMNAMETMP 2>&1 | tee $PROGDIR/debug.txt

# don't use miyoo355_rootfs_32.img for these
ROMS=("Balatro" "Celeste" "Garden Story" "Half-Life" "Sonic Mania" "Stardew Valley" "Steel Assault" "TMNTShreddersRevenge" "Wipeout")

if printf '%s\n' "${ROMS[@]}" | grep -Fxq "$ROMNAMETMP"; then
    cd $PORT32DIR
    "$PORT32DIR/${ROMNAMETMP}.sh"  2>&1 | tee -a $PROGDIR/log.txt
else
    mount -t squashfs miyoo355_rootfs_32.img mnt
    mount --bind /sys mnt/sys
    mount --bind /dev mnt/dev
    mount --bind /proc mnt/proc
    mount --bind /var/run mnt/var/run
#    mount --bind "$(dirname $0)/../../Roms/PORT32/" mnt/sdcard
    mount --bind "$PORT32DIR" mnt/sdcard
#    chroot mnt /bin/sh -c '"/mnt/sdcard/${ROMNAMETMP}.sh"'  2>&1 | tee -a $PROGDIR/log.txt
    chroot mnt /bin/sh -c "/mnt/sdcard/${ROMNAMEESC}.sh"  2>&1 | tee -a $PROGDIR/log.txt
    #cleanup
    umount mnt/sdcard
    umount mnt/var/run
    umount mnt/proc
    umount mnt/sys
    umount mnt/dev
    umount mnt
fi
