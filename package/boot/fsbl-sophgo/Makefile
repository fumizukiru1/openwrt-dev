# SPDX-License-Identifier: GPL-2.0-only
#
# Sophgo SG2000 (Milk-V Duo S) — FSBL + fip.bin 拼装
#
# FSBL 打包 fip.bin 的 TOC：monitor(OpenSBI fw_dynamic.bin @0x80000000)
# + loader2nd(u-boot-raw.bin @0x80200000)。依赖 uboot-sophgo + opensbi_generic。
#
include $(TOPDIR)/rules.mk

PKG_NAME:=fsbl-sophgo
PKG_VERSION:=2026.06.30
PKG_RELEASE:=1

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://github.com/sophgo/fsbl.git
PKG_SOURCE_VERSION:=3c47dfc743ad6cee06bca7161b352673e5c63356
PKG_MIRROR_HASH:=skip

PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)-$(PKG_VERSION)
PKG_BUILD_PARALLEL:=1
PKG_BUILD_DEPENDS:=opensbi_generic

include $(INCLUDE_DIR)/package.mk

define Package/fsbl-sophgo
  SECTION:=boot
  CATEGORY:=Boot Loaders
  DEPENDS:=@TARGET_sophgo +uboot-sophgo
  DEFAULT:=y
  TITLE:=Sophgo SG2000 FSBL (fip.bin)
  URL:=https://github.com/sophgo/fsbl
endef

define Package/fsbl-sophgo/description
  FSBL (first-stage bootloader) for the Sophgo SG2000, packs OpenSBI + U-Boot
  into the fip.bin that the BootROM loads from the first FAT partition.
endef

SOPHGO_PROJECT:=sg2000_milkv_duos_musl_riscv64_sd

define Build/Compile
	mkdir -p $(PKG_BUILD_DIR)/build
	$(CP) ./files/cvi_board_memmap.h $(PKG_BUILD_DIR)/build/
	$(CP) $(STAGING_DIR_IMAGE)/sophgo-u-boot.bin $(PKG_BUILD_DIR)/u-boot-raw.bin
	$(CP) $(STAGING_DIR_IMAGE)/fw_dynamic-generic.bin $(PKG_BUILD_DIR)/fw_dynamic.bin
	ARCH=riscv \
	CROSS_COMPILE_64="$(TARGET_CROSS)" \
	CROSS_COMPILE_GLIBC_RISCV64="$(TARGET_CROSS)" \
	CHIP_ARCH=CV181X \
	CHIP=sg2000 \
	DDR_CFG=ddr3_1866_x16 \
	STORAGE=sd \
	STORAGE_TYPE=sd \
	OD_CLK_SEL=y \
	PROJECT_FULLNAME=$(SOPHGO_PROJECT) \
	$(MAKE) -C $(PKG_BUILD_DIR) \
		O=$(PKG_BUILD_DIR)/build/$(SOPHGO_PROJECT) \
		LOG_LEVEL=2 \
		BLCP_2ND_PATH= \
		LOADER_2ND_PATH=$(PKG_BUILD_DIR)/u-boot-raw.bin \
		LDFLAGS=--no-warn-rwx-segments \
		MONITOR_PATH=$(PKG_BUILD_DIR)/fw_dynamic.bin \
		$(PKG_JOBS)
endef

define Package/fsbl-sophgo/install
	$(INSTALL_DIR) $(1)/
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/build/$(SOPHGO_PROJECT)/fip.bin $(1)/fip.bin
endef

define Build/InstallDev
	$(INSTALL_DIR) $(STAGING_DIR_IMAGE)
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/build/$(SOPHGO_PROJECT)/fip.bin $(STAGING_DIR_IMAGE)/fip.bin
endef

$(eval $(call BuildPackage,fsbl-sophgo))
