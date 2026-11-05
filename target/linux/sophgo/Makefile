# SPDX-License-Identifier: GPL-2.0-only
#
# Sophgo SG2000 (CV1800B / SG2002) — Milk-V Duo / Duo S 家族
# riscv64 主核 (C906, RV64GC)；arm64 (A53) 是第二份 dts/内核，另开 subtarget。
# 引导链参考 Armbian: BootROM -> FAT/fip.bin -> FSBL -> OpenSBI -> U-Boot -> kernel
#   fip.bin 由 sophgo/fsbl + sophgo/opensbi(generic) + sophgo/u-boot-2021.10(sg200x-dev) 拼装。
#
include $(TOPDIR)/rules.mk

ARCH:=riscv64
BOARD:=sophgo
BOARDNAME:=Sophgo (CV1800B / SG2000 / SG2002)
FEATURES:=ext4 squashfs
KERNELNAME:=Image dtbs

KERNEL_PATCHVER:=6.18

include $(INCLUDE_DIR)/target.mk

define Target/Description
	Build firmware images for Sophgo SG2000 (Milk-V Duo S) boards
endef

$(eval $(call BuildTarget))
