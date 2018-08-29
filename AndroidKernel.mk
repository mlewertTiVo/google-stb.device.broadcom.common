
#############################################################################
#    (c)2010-2016 Broadcom
#
# This program is the proprietary software of Broadcom and/or its licensors,
# and may only be used, duplicated, modified or distributed pursuant to the terms and
# conditions of a separate, written license agreement executed between you and Broadcom
# (an "Authorized License").  Except as set forth in an Authorized License, Broadcom grants
# no license (express or implied), right to use, or waiver of any kind with respect to the
# Software, and Broadcom expressly reserves all rights in and to the Software and all
# intellectual property rights therein.  IF YOU HAVE NO AUTHORIZED LICENSE, THEN YOU
# HAVE NO RIGHT TO USE THIS SOFTWARE IN ANY WAY, AND SHOULD IMMEDIATELY
# NOTIFY BROADCOM AND DISCONTINUE ALL USE OF THE SOFTWARE.
#
# Except as expressly set forth in the Authorized License,
#
# 1.     This program, including its structure, sequence and organization, constitutes the valuable trade
# secrets of Broadcom, and you shall use all reasonable efforts to protect the confidentiality thereof,
# and to use this information only in connection with your use of Broadcom integrated circuit products.
#
# 2.     TO THE MAXIMUM EXTENT PERMITTED BY LAW, THE SOFTWARE IS PROVIDED "AS IS"
# AND WITH ALL FAULTS AND BROADCOM MAKES NO PROMISES, REPRESENTATIONS OR
# WARRANTIES, EITHER EXPRESS, IMPLIED, STATUTORY, OR OTHERWISE, WITH RESPECT TO
# THE SOFTWARE.  BROADCOM SPECIFICALLY DISCLAIMS ANY AND ALL IMPLIED WARRANTIES
# OF TITLE, MERCHANTABILITY, NONINFRINGEMENT, FITNESS FOR A PARTICULAR PURPOSE,
# LACK OF VIRUSES, ACCURACY OR COMPLETENESS, QUIET ENJOYMENT, QUIET POSSESSION
# OR CORRESPONDENCE TO DESCRIPTION. YOU ASSUME THE ENTIRE RISK ARISING OUT OF
# USE OR PERFORMANCE OF THE SOFTWARE.
#
# 3.     TO THE MAXIMUM EXTENT PERMITTED BY LAW, IN NO EVENT SHALL BROADCOM OR ITS
# LICENSORS BE LIABLE FOR (i) CONSEQUENTIAL, INCIDENTAL, SPECIAL, INDIRECT, OR
# EXEMPLARY DAMAGES WHATSOEVER ARISING OUT OF OR IN ANY WAY RELATING TO YOUR
# USE OF OR INABILITY TO USE THE SOFTWARE EVEN IF BROADCOM HAS BEEN ADVISED OF
# THE POSSIBILITY OF SUCH DAMAGES; OR (ii) ANY AMOUNT IN EXCESS OF THE AMOUNT
# ACTUALLY PAID FOR THE SOFTWARE ITSELF OR U.S. $1, WHICHEVER IS GREATER. THESE
# LIMITATIONS SHALL APPLY NOTWITHSTANDING ANY FAILURE OF ESSENTIAL PURPOSE OF
# ANY LIMITED REMEDY.
#
#############################################################################

ifneq ($(BCM_DIST_KNLIMG_BINS),y)

ifeq (${OUT_DIR},)
ifeq (${OUT_DIR_COMMON_BASE},)
OUT_DIR := out
else
OUT_DIR := ${OUT_DIR_COMMON_BASE}/$(notdir ${PWD})
endif
endif
KERNEL_OUT_DIR := ${OUT_DIR}/target/product/${LOCAL_PRODUCT_OUT}
KERNEL_OUT_DIR_ABS := $(abspath ${KERNEL_OUT_DIR})

ifeq ($(BCHP_CHIP),)
ifneq ($(CALLED_FROM_SETUP),true)
# platform_app.inc modifies the PWD variable used by android. Save it and restore afterward.
PWD_BEFORE_PLATFORM_APP := $(PWD)
NEXUS_TOP := ${REFSW_BASE_DIR}/nexus
include ${NEXUS_TOP}/platforms/$(PLATFORM)/build/platform_app.inc
PWD := $(PWD_BEFORE_PLATFORM_APP)
endif
endif

ifeq ($(LOCAL_ARM_AARCH64),y)
ifeq ($(LOCAL_ARM_AARCH64_COMPAT_32_BIT),y)
KERNEL_IMG := Image
else
ifeq ($(LOCAL_ARM_AARCH64_NOT_ABI_COMPATIBLE),y)
KERNEL_IMG := zImage
else
KERNEL_IMG := Image
endif
endif
else
KERNEL_IMG := zImage
endif
KERNEL_2ND_IMG := zImage

# producing a dummy device tree for compliance.
DTB_BINARY := brcmstb-dummy.dtb

.PHONY: build_kernel
.PHONY: build_kernel_2nd_arch
AUTOCONF_1ST_ARCH := $(LINUX_OUT_1ST_ARCH)/include/generated/autoconf.h
ifeq ($(LOCAL_ARM_AARCH64),y)
ifeq ($(LOCAL_ARM_AARCH64_COMPAT_32_BIT),y)

build_kernel:
	@echo "'$@' started"
	mkdir -p ${LINUX_OUT_1ST_ARCH}
	-@if [ -f $(AUTOCONF_1ST_ARCH) ]; then \
		cp -pv $(AUTOCONF_1ST_ARCH) $(AUTOCONF_1ST_ARCH)_refsw; \
	fi
	-@if [ "$(LOCAL_LINUX_VERSION_NODASH)" == "4.1" ]; then \
		cp ${BCM_VENDOR_STB_ROOT}/bcm_platform/signing/verity_dev_key.der.x509 ${LINUX_OUT_1ST_ARCH}/; \
		if [ -f ${TOP}/device/broadcom/${LOCAL_PRODUCT_OUT}/dm-verity/${LOCAL_PRODUCT_OUT}.verifiedboot.der.x509 ]; then \
			cp ${TOP}/device/broadcom/${LOCAL_PRODUCT_OUT}/dm-verity/${LOCAL_PRODUCT_OUT}.verifiedboot.der.x509 ${LINUX_OUT_1ST_ARCH}/; \
		fi; \
	else \
		if [ -f ${TOP}/device/broadcom/${LOCAL_PRODUCT_OUT}/signing/keys.pem.x509 ]; then \
			cp ${TOP}/device/broadcom/${LOCAL_PRODUCT_OUT}/signing/keys.pem.x509 ${LINUX_OUT_1ST_ARCH}/; \
		else \
			cp ${BCM_VENDOR_STB_ROOT}/bcm_platform/signing/verity.x509.pem ${LINUX_OUT_1ST_ARCH}/keys.pem.x509; \
		fi; \
	fi
	rm -f $(LINUX_OUT_1ST_ARCH)/config_fragment;
	echo "CONFIG_SYSTEM_TRUSTED_KEYS=\"keys.pem.x509\"" > $(LINUX_OUT_1ST_ARCH)/config_fragment
	cd $(LINUX) && PATH=${B_KNB_TOOLCHAIN}:$$PATH ARCH=$(P_REFSW_DRV_ARCH) scripts/kconfig/merge_config.sh -O $(LINUX_OUT_1ST_ARCH) arch/arm64/configs/brcmstb_defconfig $(LINUX_OUT_1ST_ARCH)/config_fragment
	rm -f $(LINUX_OUT_1ST_ARCH)/config_fragment
	cd $(LINUX) && PATH=${B_KNB_TOOLCHAIN}:$$PATH KBUILD_OUTPUT=$(LINUX_OUT_1ST_ARCH) ARCH=$(P_REFSW_DRV_ARCH) $(MAKE) $(KERNEL_IMG)
	cd $(LINUX) && PATH=${B_KNB_TOOLCHAIN}:$$PATH KBUILD_OUTPUT=$(LINUX_OUT_1ST_ARCH) ARCH=$(P_REFSW_DRV_ARCH) $(MAKE) dtbs
	-@if [ -f $(AUTOCONF_1ST_ARCH)_refsw ]; then \
		if [ `diff -q $(AUTOCONF_1ST_ARCH)_refsw $(AUTOCONF_1ST_ARCH) | wc -l` -eq 0 ]; then \
			echo "'generated/autoconf.h' is unchanged"; \
			cp -pv $(AUTOCONF_1ST_ARCH)_refsw $(AUTOCONF_1ST_ARCH); \
		fi; \
		rm -f $(AUTOCONF_1ST_ARCH)_refsw; \
	fi
	cp -pv $(LINUX_OUT_1ST_ARCH)/arch/arm64/boot/$(KERNEL_IMG) $(KERNEL_OUT_DIR_ABS)/kernel
	cp -pv $(LINUX_OUT_1ST_ARCH)/arch/arm64/boot/dts/broadcom/$(DTB_BINARY) $(KERNEL_OUT_DIR_ABS)/bcm.dtb
	@echo "'$@' completed"

build_kernel_2nd_arch:
	@echo "'$@' no-op"

else
ifeq ($(LOCAL_ARM_AARCH64_NOT_ABI_COMPATIBLE),y)

build_kernel:
	@echo "'$@' started"
	mkdir -p ${LINUX_OUT_1ST_ARCH}
	-@if [ -f $(AUTOCONF_1ST_ARCH) ]; then \
		cp -pv $(AUTOCONF_1ST_ARCH) $(AUTOCONF_1ST_ARCH)_refsw; \
	fi
	-@if [ "$(LOCAL_LINUX_VERSION_NODASH)" == "4.1" ]; then \
		cp ${BCM_VENDOR_STB_ROOT}/bcm_platform/signing/verity_dev_key.der.x509 ${LINUX_OUT_1ST_ARCH}/; \
		if [ -f ${TOP}/device/broadcom/${LOCAL_PRODUCT_OUT}/dm-verity/${LOCAL_PRODUCT_OUT}.verifiedboot.der.x509 ]; then \
			cp ${TOP}/device/broadcom/${LOCAL_PRODUCT_OUT}/dm-verity/${LOCAL_PRODUCT_OUT}.verifiedboot.der.x509 ${LINUX_OUT_1ST_ARCH}/; \
		fi; \
	else \
		if [ -f ${TOP}/device/broadcom/${LOCAL_PRODUCT_OUT}/signing/keys.pem.x509 ]; then \
			cp ${TOP}/device/broadcom/${LOCAL_PRODUCT_OUT}/signing/keys.pem.x509 ${LINUX_OUT_1ST_ARCH}/; \
		else \
			cp ${BCM_VENDOR_STB_ROOT}/bcm_platform/signing/verity.x509.pem ${LINUX_OUT_1ST_ARCH}/keys.pem.x509; \
		fi; \
	fi
	rm -f $(LINUX_OUT_1ST_ARCH)/config_fragment
	echo "# CONFIG_BCM3390A0 is not set" > $(LINUX_OUT_1ST_ARCH)/config_fragment
	echo "# CONFIG_BCM7145 is not set" >> $(LINUX_OUT_1ST_ARCH)/config_fragment
	echo "CONFIG_CROSS_COMPILE=\"arm-linux-gnueabihf-\"" >> $(LINUX_OUT_1ST_ARCH)/config_fragment
	echo "CONFIG_SYSTEM_TRUSTED_KEYS=\"keys.pem.x509\"" >> $(LINUX_OUT_1ST_ARCH)/config_fragment
	cd $(LINUX) && PATH=${B_KNB_TOOLCHAIN}:$$PATH ARCH=$(P_REFSW_DRV_ARCH) scripts/kconfig/merge_config.sh -O $(LINUX_OUT_1ST_ARCH) arch/arm/configs/brcmstb_defconfig $(LINUX_OUT_1ST_ARCH)/config_fragment
	rm -f $(LINUX_OUT_1ST_ARCH)/config_fragment
	cd $(LINUX) && PATH=${B_KNB_TOOLCHAIN}:$$PATH KBUILD_OUTPUT=$(LINUX_OUT_1ST_ARCH) ARCH=$(P_REFSW_DRV_ARCH) $(MAKE) $(KERNEL_IMG)
	cd $(LINUX) && PATH=${B_KNB_TOOLCHAIN}:$$PATH KBUILD_OUTPUT=$(LINUX_OUT_1ST_ARCH) ARCH=$(P_REFSW_DRV_ARCH) $(MAKE) dtbs
	-@if [ -f $(AUTOCONF_1ST_ARCH)_refsw ]; then \
		if [ `diff -q $(AUTOCONF_1ST_ARCH)_refsw $(AUTOCONF_1ST_ARCH) | wc -l` -eq 0 ]; then \
			echo "'generated/autoconf.h' is unchanged"; \
			cp -pv $(AUTOCONF_1ST_ARCH)_refsw $(AUTOCONF_1ST_ARCH); \
		fi; \
		rm -f $(AUTOCONF_1ST_ARCH)_refsw; \
	fi
	cp -pv $(LINUX_OUT_1ST_ARCH)/arch/arm/boot/$(KERNEL_IMG) $(KERNEL_OUT_DIR_ABS)/kernel
	cp -pv $(LINUX_OUT_1ST_ARCH)/arch/arm/boot/dts/$(DTB_BINARY) $(KERNEL_OUT_DIR_ABS)/bcm.dtb
	@echo "'$@' completed"

build_kernel_2nd_arch:
	@echo "'$@' no-op"

else

build_kernel:
	@echo "'$@' started"
	mkdir -p ${LINUX_OUT_1ST_ARCH}
	-@if [ -f $(AUTOCONF_1ST_ARCH) ]; then \
		cp -pv $(AUTOCONF_1ST_ARCH) $(AUTOCONF_1ST_ARCH)_refsw; \
	fi
	-@if [ "$(LOCAL_LINUX_VERSION_NODASH)" == "4.1" ]; then \
		cp ${BCM_VENDOR_STB_ROOT}/bcm_platform/signing/verity_dev_key.der.x509 ${LINUX_OUT_1ST_ARCH}/; \
		if [ -f ${TOP}/device/broadcom/${LOCAL_PRODUCT_OUT}/dm-verity/${LOCAL_PRODUCT_OUT}.verifiedboot.der.x509 ]; then \
			cp ${TOP}/device/broadcom/${LOCAL_PRODUCT_OUT}/dm-verity/${LOCAL_PRODUCT_OUT}.verifiedboot.der.x509 ${LINUX_OUT_1ST_ARCH}/; \
		fi; \
	else \
		if [ -f ${TOP}/device/broadcom/${LOCAL_PRODUCT_OUT}/signing/keys.pem.x509 ]; then \
			cp ${TOP}/device/broadcom/${LOCAL_PRODUCT_OUT}/signing/keys.pem.x509 ${LINUX_OUT_1ST_ARCH}/; \
		else \
			cp ${BCM_VENDOR_STB_ROOT}/bcm_platform/signing/verity.x509.pem ${LINUX_OUT_1ST_ARCH}/keys.pem.x509; \
		fi; \
	fi
	rm -f $(LINUX_OUT_1ST_ARCH)/config_fragment;
	echo "CONFIG_SYSTEM_TRUSTED_KEYS=\"keys.pem.x509\"" >> $(LINUX_OUT_1ST_ARCH)/config_fragment
	cd $(LINUX) && PATH=${B_KNB_TOOLCHAIN}:$$PATH ARCH=$(P_REFSW_DRV_ARCH) scripts/kconfig/merge_config.sh -O $(LINUX_OUT_1ST_ARCH) arch/arm64/configs/brcmstb_defconfig $(LINUX_OUT_1ST_ARCH)/config_fragment;
	rm -f $(LINUX_OUT_1ST_ARCH)/config_fragment;
	cd $(LINUX) && PATH=${B_KNB_TOOLCHAIN}:$$PATH KBUILD_OUTPUT=$(LINUX_OUT_1ST_ARCH) ARCH=$(P_REFSW_DRV_ARCH) $(MAKE) $(KERNEL_IMG)
	cd $(LINUX) && PATH=${B_KNB_TOOLCHAIN}:$$PATH KBUILD_OUTPUT=$(LINUX_OUT_1ST_ARCH) ARCH=$(P_REFSW_DRV_ARCH) $(MAKE) dtbs
	-@if [ -f $(AUTOCONF_1ST_ARCH)_refsw ]; then \
		if [ `diff -q $(AUTOCONF_1ST_ARCH)_refsw $(AUTOCONF_1ST_ARCH) | wc -l` -eq 0 ]; then \
			echo "'generated/autoconf.h' is unchanged"; \
			cp -pv $(AUTOCONF_1ST_ARCH)_refsw $(AUTOCONF_1ST_ARCH); \
		fi; \
		rm -f $(AUTOCONF_1ST_ARCH)_refsw; \
	fi
	cp -pv $(LINUX_OUT_1ST_ARCH)/arch/arm64/boot/$(KERNEL_IMG) $(KERNEL_OUT_DIR_ABS)/kernel
	cp -pv $(LINUX_OUT_1ST_ARCH)/arch/arm64/boot/dts/broadcom/$(DTB_BINARY) $(KERNEL_OUT_DIR_ABS)/bcm.dtb
	@echo "'$@' completed"

build_kernel_2nd_arch:
	@echo "'$@' started"
	mkdir -p ${LINUX_OUT_2ND_ARCH}
	rm -f $(LINUX_OUT_2ND_ARCH)/config_fragment
	echo "# CONFIG_BCM3390A0 is not set" > $(LINUX_OUT_2ND_ARCH)/config_fragment
	echo "# CONFIG_BCM7145 is not set" >> $(LINUX_OUT_2ND_ARCH)/config_fragment
	echo "CONFIG_CROSS_COMPILE=\"arm-linux-gnueabihf-\"" >> $(LINUX_OUT_2ND_ARCH)/config_fragment
	cd $(LINUX) && PATH=${B_KNB_TOOLCHAIN}:$$PATH ARCH=arm scripts/kconfig/merge_config.sh -O $(LINUX_OUT_2ND_ARCH) arch/arm/configs/brcmstb_defconfig $(LINUX_OUT_2ND_ARCH)/config_fragment
	rm -f $(LINUX_OUT_2ND_ARCH)/config_fragment
	cd $(LINUX) && PATH=${B_KNB_TOOLCHAIN}:$$PATH KBUILD_OUTPUT=$(LINUX_OUT_2ND_ARCH) ARCH=arm $(MAKE) $(KERNEL_2ND_IMG)
	@echo "'$@' completed"

endif
endif

else

build_kernel:
	@echo "'$@' started"
	mkdir -p ${LINUX_OUT_1ST_ARCH}
	-@if [ -f $(AUTOCONF_1ST_ARCH) ]; then \
		cp -pv $(AUTOCONF_1ST_ARCH) $(AUTOCONF_1ST_ARCH)_refsw; \
	fi
	-@if [ "$(LOCAL_LINUX_VERSION_NODASH)" == "4.1" ]; then \
		cp ${BCM_VENDOR_STB_ROOT}/bcm_platform/signing/verity_dev_key.der.x509 ${LINUX_OUT_1ST_ARCH}/; \
		if [ -f ${TOP}/device/broadcom/${LOCAL_PRODUCT_OUT}/dm-verity/${LOCAL_PRODUCT_OUT}.verifiedboot.der.x509 ]; then \
			cp ${TOP}/device/broadcom/${LOCAL_PRODUCT_OUT}/dm-verity/${LOCAL_PRODUCT_OUT}.verifiedboot.der.x509 ${LINUX_OUT_1ST_ARCH}/; \
		fi; \
	else \
		if [ -f ${TOP}/device/broadcom/${LOCAL_PRODUCT_OUT}/signing/keys.pem.x509 ]; then \
			cp ${TOP}/device/broadcom/${LOCAL_PRODUCT_OUT}/signing/keys.pem.x509 ${LINUX_OUT_1ST_ARCH}/; \
		else \
			cp ${BCM_VENDOR_STB_ROOT}/bcm_platform/signing/verity.x509.pem ${LINUX_OUT_1ST_ARCH}/keys.pem.x509; \
		fi; \
	fi
	rm -f $(LINUX_OUT_1ST_ARCH)/config_fragment
	echo "# CONFIG_BCM3390A0 is not set" > $(LINUX_OUT_1ST_ARCH)/config_fragment
	echo "# CONFIG_BCM7145 is not set" >> $(LINUX_OUT_1ST_ARCH)/config_fragment
	echo "CONFIG_CROSS_COMPILE=\"arm-linux-gnueabihf-\"" >> $(LINUX_OUT_1ST_ARCH)/config_fragment
	echo "CONFIG_SYSTEM_TRUSTED_KEYS=\"keys.pem.x509\"" >> $(LINUX_OUT_1ST_ARCH)/config_fragment
	cd $(LINUX) && PATH=${B_KNB_TOOLCHAIN}:$$PATH ARCH=$(P_REFSW_DRV_ARCH) scripts/kconfig/merge_config.sh -O $(LINUX_OUT_1ST_ARCH) arch/arm/configs/brcmstb_defconfig $(LINUX_OUT_1ST_ARCH)/config_fragment
	rm -f $(LINUX_OUT_1ST_ARCH)/config_fragment
	cd $(LINUX) && PATH=${B_KNB_TOOLCHAIN}:$$PATH KBUILD_OUTPUT=$(LINUX_OUT_1ST_ARCH) ARCH=$(P_REFSW_DRV_ARCH) $(MAKE) $(KERNEL_IMG)
	cd $(LINUX) && PATH=${B_KNB_TOOLCHAIN}:$$PATH KBUILD_OUTPUT=$(LINUX_OUT_1ST_ARCH) ARCH=$(P_REFSW_DRV_ARCH) $(MAKE) dtbs
	-@if [ -f $(AUTOCONF_1ST_ARCH)_refsw ]; then \
		if [ `diff -q $(AUTOCONF_1ST_ARCH)_refsw $(AUTOCONF_1ST_ARCH) | wc -l` -eq 0 ]; then \
			echo "'generated/autoconf.h' is unchanged"; \
			cp -pv $(AUTOCONF_1ST_ARCH)_refsw $(AUTOCONF_1ST_ARCH); \
		fi; \
		rm -f $(AUTOCONF_1ST_ARCH)_refsw; \
	fi
	cp -pv $(LINUX_OUT_1ST_ARCH)/arch/arm/boot/$(KERNEL_IMG) $(KERNEL_OUT_DIR_ABS)/kernel
	cp -pv $(LINUX_OUT_1ST_ARCH)/arch/arm/boot/dts/$(DTB_BINARY) $(KERNEL_OUT_DIR_ABS)/bcm.dtb
	@echo "'$@' completed"

build_kernel_2nd_arch:
	@echo "'$@' no-op"

endif

$(KERNEL_OUT_DIR)/kernel: build_kernel
	@echo "'build_kernel' target: $@"

$(KERNEL_OUT_DIR)/bcm.dtb: build_kernel
	@echo "'build_kernel' target: $@"

.PHONY: clean_drivers
ifneq ($(HW_WIFI_SUPPORT),n)
clean_drivers: clean_brcm_dhd_driver
else
clean_drivers:
	@echo "'no-op' target: $@"
endif

.PHONY: clean_kernel
clean_kernel: clean_drivers
	rm -f $(KERNEL_OUT_DIR_ABS)/kernel
	rm -rf $(LINUX_OUT_ROOT)


endif
