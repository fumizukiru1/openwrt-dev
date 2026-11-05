ARCH:=riscv64
BOARD:=sophgo
SUBTARGET:=sg200x
BOARDNAME:=Sophgo SG200x (CV1800B / SG2000 / SG2002) RISC-V
KERNELNAME:=Image

define Target/Description
	Sophgo SG2000 (Milk-V Duo S, Duo 256M) riscv64
endef

$(eval $(call BuildTarget))
