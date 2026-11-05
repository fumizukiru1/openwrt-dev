# SPDX-License-Identifier: GPL-2.0-only
#
# Sophgo SG2000 (Milk-V Duo S) — vendor U-Boot (sophgo/u-boot-2021.10, sg200x-dev)
#
# 主线 u-boot 无 SG2000(CV181X) 板级支持（只有 CV1800B/SG2002），故用 vendor fork。
# board files + distroboot/zicsr/SD-slot 补丁来自 Armbian u-boot-sophgo-sg200x。
#
include $(TOPDIR)/rules.mk

PKG_NAME:=uboot-sophgo
PKG_VERSION:=2021.10
PKG_RELEASE:=1

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://github.com/sophgo/u-boot-2021.10.git
PKG_SOURCE_VERSION:=bb7496c2dfded43921695bf49c23da28381f8960
PKG_MIRROR_HASH:=skip

PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)-$(PKG_VERSION)
PKG_BUILD_PARALLEL:=1

include $(INCLUDE_DIR)/package.mk

define Package/uboot-sophgo
  SECTION:=boot
  CATEGORY:=Boot Loaders
  DEPENDS:=@TARGET_sophgo
  DEFAULT:=y
  TITLE:=Sophgo SG2000 U-Boot (Milk-V Duo S)
  URL:=https://github.com/sophgo/u-boot-2021.10
endef

# vendor 构建环境（SD 变体）
SOPHGO_UBOOT_ENV = \
	CHIP=sg2000 \
	CHIP_ARCH=CV181X \
	CVIBOARD=milkv_duos_musl_riscv64_sd \
	STORAGE_TYPE=sd \
	PANEL_TUNING_PARAM=MIPI_panel_milkv_8hd \
	CONFIG_SKIP_RAMDISK=y \
	CONFIG_USE_DEFAULT_ENV=y \
	RELEASE=0 \
	UBOOT_VBOOT=0

SOPHGO_UBOOT_DEFCONFIG:=cvitek_sg2000_milkv_duos_musl_riscv64_sd

define Build/Prepare
	$(call Build/Prepare/Default)
	$(CP) ./files/common/dts/*.dtsi $(PKG_BUILD_DIR)/arch/riscv/dts/
	$(CP) ./files/riscv64/dts/* $(PKG_BUILD_DIR)/arch/riscv/dts/
	$(CP) ./files/riscv64/configs/* $(PKG_BUILD_DIR)/configs/
	$(CP) ./files/riscv64/board/cvi_board_init.c $(PKG_BUILD_DIR)/board/cvitek/
	mkdir -p $(PKG_BUILD_DIR)/include/cvitek
	$(CP) ./files/riscv64/include/cvitek.h $(PKG_BUILD_DIR)/include/cvitek/
	$(CP) ./files/riscv64/include/cvi_board_memmap.h $(PKG_BUILD_DIR)/include/
	$(CP) ./files/riscv64/include/sd/cvipart.h $(PKG_BUILD_DIR)/include/
	$(CP) ./files/riscv64/include/sd/imgs.h $(PKG_BUILD_DIR)/include/
endef

define Build/Compile
	+$(SOPHGO_UBOOT_ENV) $(MAKE) -C $(PKG_BUILD_DIR) \
		CROSS_COMPILE=$(TARGET_CROSS) \
		$(SOPHGO_UBOOT_DEFCONFIG)_defconfig
	+$(SOPHGO_UBOOT_ENV) $(MAKE) -C $(PKG_BUILD_DIR) \
		CROSS_COMPILE=$(TARGET_CROSS) \
		KCFLAGS=-Wno-error=enum-int-mismatch \
		$(PKG_JOBS)
endef

define Build/InstallDev
	$(INSTALL_DIR) $(STAGING_DIR_IMAGE)
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/u-boot.bin $(STAGING_DIR_IMAGE)/sophgo-u-boot.bin
endef

define Package/uboot-sophgo/install
	$(INSTALL_DIR) $(1)/
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/u-boot.bin $(1)/u-boot.bin
endef

$(eval $(call BuildPackage,uboot-sophgo))
