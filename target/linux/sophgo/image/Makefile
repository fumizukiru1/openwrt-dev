# SPDX-License-Identifier: GPL-2.0-only
#
# Sophgo SG2000 (Milk-V Duo S) — SD/eMMC boot image
#
# BootROM -> FAT/fip.bin (FSBL + OpenSBI + U-Boot) -> distroboot -> Image + dtb
# 打包参考 Armbian: build/config/sources/families/sophgo-sg200x-riscv64.conf
#
include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/image.mk

SOPHGO_BOOT_PARTSIZE:=256
FAT32_BLOCK_SIZE:=1024
FAT32_BLOCKS:=$(shell echo $$(($(SOPHGO_BOOT_PARTSIZE)*1024*1024/$(FAT32_BLOCK_SIZE))))

define Build/bootfs
	rm -f $@.boot
	mkfs.fat $@.boot -C $(FAT32_BLOCKS)
	mmd -i $@.boot ::/extlinux
	mcopy -i $@.boot $(STAGING_DIR_IMAGE)/fip.bin ::fip.bin
	mcopy -i $@.boot $(IMAGE_KERNEL) ::Image
	mcopy -i $@.boot $(LINUX_DIR)/arch/riscv/boot/dts/$(DEVICE_DTS).dtb ::sg2000-milkv-duo-s.dtb
	mcopy -i $@.boot $(TOPDIR)/target/linux/sophgo/image/extlinux.conf ::/extlinux/extlinux.conf
endef

define Build/sdcard
	./gen_sophgo_sdcard_img.sh $@ $@.boot $(IMAGE_ROOTFS) $(SOPHGO_BOOT_PARTSIZE) $(CONFIG_TARGET_ROOTFS_PARTSIZE)
endef

define Device/Default
  PROFILES := Default
  KERNEL_NAME := Image
  KERNEL := kernel-bin
  IMAGES := sdcard.img.gz
  IMAGE/sdcard.img.gz := bootfs | sdcard | gzip
endef

define Device/milkv-duos
  $(call Device/Default)
  DEVICE_VENDOR := Milk-V
  DEVICE_MODEL := Duo S
  DEVICE_DTS := sophgo/sg2000-milkv-duo-s
endef
TARGET_DEVICES += milkv-duos

$(eval $(call BuildImage))
