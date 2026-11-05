#!/usr/bin/env bash
# SPDX-License-Identifier: GPL-2.0-only
#
# Sophgo SG2000 (Milk-V Duo S) SD card image assembly.
#
# Layout (MBR): p1 = FAT16(0x0c, bootable, fip.bin + Image + dtb + extlinux)
#               p2 = rootfs (squashfs/ext4)
#
set -ex
[ $# -eq 5 ] || {
    echo "SYNTAX: $0 <file> <bootfs image> <rootfs image> <bootfs size> <rootfs size>"
    exit 1
}

OUTPUT="$1"
BOOTFS="$2"
ROOTFS="$3"
BOOTFSSIZE="$4"
ROOTFSSIZE="$5"

# ptgen verbose 输出: start0 size0 start1 size1 (字节)
set $(ptgen -o $OUTPUT -h 2 -s 32 -t c -a 1 -p ${BOOTFSSIZE}M -t 83 -p ${ROOTFSSIZE}M)

BOOTOFFSET=$(($1 / 512))
ROOTFSOFFSET=$(($3 / 512))

dd bs=512 if="$BOOTFS" of="$OUTPUT" seek=${BOOTOFFSET} conv=notrunc
dd bs=512 if="$ROOTFS" of="$OUTPUT" seek=${ROOTFSOFFSET} conv=notrunc
