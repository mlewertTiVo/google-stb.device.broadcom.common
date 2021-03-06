
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

ifeq ($(OUT_DIR_COMMON_BASE),)
KERNEL_OUT_DIR := out/target/product/${ANDROID_PRODUCT_OUT}
KERNEL_OUT_DIR_ABS := ${ANDROID_TOP}/${KERNEL_OUT_DIR}
else
KERNEL_OUT_DIR := ${OUT_DIR_COMMON_BASE}/$(notdir $(PWD))/target/product/${ANDROID_PRODUCT_OUT}
KERNEL_OUT_DIR_ABS := ${KERNEL_OUT_DIR}
endif

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
ifeq ($(LOCAL_ARM_AARCH64_NOT_ABI_COMPATIBLE),y)
KERNEL_IMG := zImage
else
KERNEL_IMG := Image
endif
else
KERNEL_IMG := zImage
endif
KERNEL_2ND_IMG := zImage

ifneq ($(LOCAL_KCONFIG_CHIP_OVERRIDE),)
KCONFIG_CHIP := $(LOCAL_KCONFIG_CHIP_OVERRIDE)
else
KCONFIG_CHIP := $(BCHP_CHIP)$(BCHP_VER)
endif

.PHONY: build_kernel
.PHONY: build_kernel_2nd_arch
AUTOCONF_1ST_ARCH := $(LINUX_OUT_1ST_ARCH)/include/generated/autoconf.h
ifeq ($(LOCAL_ARM_AARCH64),y)
ifeq ($(LOCAL_ARM_AARCH64_NOT_ABI_COMPATIBLE),y)

build_kernel:
	@echo "'$@' started"
	mkdir -p ${LINUX_OUT_1ST_ARCH}
	-@if [ -f $(AUTOCONF_1ST_ARCH) ]; then \
		cp -pv $(AUTOCONF_1ST_ARCH) $(AUTOCONF_1ST_ARCH)_refsw; \
	fi
	cp ${BCM_VENDOR_STB_ROOT}/bcm_platform/signing/verity_dev_key.der.x509 ${LINUX_OUT_1ST_ARCH}/
	rm -f $(LINUX_OUT_1ST_ARCH)/config_fragment
	echo "# CONFIG_BCM3390A0 is not set" > $(LINUX_OUT_1ST_ARCH)/config_fragment
	echo "# CONFIG_BCM7145 is not set" >> $(LINUX_OUT_1ST_ARCH)/config_fragment
	echo "CONFIG_CROSS_COMPILE=\"arm-linux-gnueabihf-\"" >> $(LINUX_OUT_1ST_ARCH)/config_fragment
	echo "CONFIG_BCM$(KCONFIG_CHIP)=y" >> $(LINUX_OUT_1ST_ARCH)/config_fragment
	-@if [ "$(HW_GPU_MMU_SUPPORT)" == "y" ]; then \
		echo "CONFIG_DRM_BRCM_V3D=y" >> $(LINUX_OUT_1ST_ARCH)/config_fragment; \
	fi
	cd $(LINUX) && scripts/kconfig/merge_config.sh -O $(LINUX_OUT_1ST_ARCH) arch/arm/configs/brcmstb_defconfig $(LINUX_OUT_1ST_ARCH)/config_fragment
	rm -f $(LINUX_OUT_1ST_ARCH)/config_fragment
	cd $(LINUX) && KBUILD_OUTPUT=$(LINUX_OUT_1ST_ARCH) $(MAKE) $(KERNEL_IMG)
	-@if [ -f $(AUTOCONF_1ST_ARCH)_refsw ]; then \
		if [ `diff -q $(AUTOCONF_1ST_ARCH)_refsw $(AUTOCONF_1ST_ARCH) | wc -l` -eq 0 ]; then \
			echo "'generated/autoconf.h' is unchanged"; \
			cp -pv $(AUTOCONF_1ST_ARCH)_refsw $(AUTOCONF_1ST_ARCH); \
		fi; \
		rm -f $(AUTOCONF_1ST_ARCH)_refsw; \
	fi
	cp -pv $(LINUX_OUT_1ST_ARCH)/arch/arm/boot/$(KERNEL_IMG) $(KERNEL_OUT_DIR_ABS)/kernel
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
	cp ${BCM_VENDOR_STB_ROOT}/bcm_platform/signing/verity_dev_key.der.x509 ${LINUX_OUT_1ST_ARCH}/
	-@if [ "$(HW_GPU_MMU_SUPPORT)" == "y" ]; then \
		rm -f $(LINUX_OUT_1ST_ARCH)/config_fragment; \
		echo "CONFIG_DRM_BRCM_V3D=y" >> $(LINUX_OUT_1ST_ARCH)/config_fragment; \
		cd $(LINUX) && scripts/kconfig/merge_config.sh -O $(LINUX_OUT_1ST_ARCH) arch/arm64/configs/brcmstb_defconfig $(LINUX_OUT_1ST_ARCH)/config_fragment; \
		rm -f $(LINUX_OUT_1ST_ARCH)/config_fragment; \
	fi
	cd $(LINUX) && KBUILD_OUTPUT=$(LINUX_OUT_1ST_ARCH) ARCH=arm64 $(MAKE) brcmstb_defconfig
	cd $(LINUX) && KBUILD_OUTPUT=$(LINUX_OUT_1ST_ARCH) ARCH=arm64 $(MAKE) $(KERNEL_IMG)
	-@if [ -f $(AUTOCONF_1ST_ARCH)_refsw ]; then \
		if [ `diff -q $(AUTOCONF_1ST_ARCH)_refsw $(AUTOCONF_1ST_ARCH) | wc -l` -eq 0 ]; then \
			echo "'generated/autoconf.h' is unchanged"; \
			cp -pv $(AUTOCONF_1ST_ARCH)_refsw $(AUTOCONF_1ST_ARCH); \
		fi; \
		rm -f $(AUTOCONF_1ST_ARCH)_refsw; \
	fi
	cp -pv $(LINUX_OUT_1ST_ARCH)/arch/arm64/boot/$(KERNEL_IMG) $(KERNEL_OUT_DIR_ABS)/kernel
	@echo "'$@' completed"

build_kernel_2nd_arch:
	@echo "'$@' started"
	mkdir -p ${LINUX_OUT_2ND_ARCH}
	rm -f $(LINUX_OUT_2ND_ARCH)/config_fragment
	echo "# CONFIG_BCM3390A0 is not set" > $(LINUX_OUT_2ND_ARCH)/config_fragment
	echo "# CONFIG_BCM7145 is not set" >> $(LINUX_OUT_2ND_ARCH)/config_fragment
	echo "CONFIG_CROSS_COMPILE=\"arm-linux-gnueabihf-\"" >> $(LINUX_OUT_2ND_ARCH)/config_fragment
	echo "CONFIG_BCM$(KCONFIG_CHIP)=y" >> $(LINUX_OUT_2ND_ARCH)/config_fragment
	-@if [ "$(HW_GPU_MMU_SUPPORT)" == "y" ]; then \
		echo "CONFIG_DRM_BRCM_V3D=y" >> $(LINUX_OUT_1ST_ARCH)/config_fragment; \
	fi
	cd $(LINUX) && scripts/kconfig/merge_config.sh -O $(LINUX_OUT_2ND_ARCH) arch/arm/configs/brcmstb_defconfig $(LINUX_OUT_2ND_ARCH)/config_fragment
	rm -f $(LINUX_OUT_2ND_ARCH)/config_fragment
	cd $(LINUX) && KBUILD_OUTPUT=$(LINUX_OUT_2ND_ARCH) $(MAKE) $(KERNEL_2ND_IMG)
	@echo "'$@' completed"

endif

else

build_kernel:
	@echo "'$@' started"
	mkdir -p ${LINUX_OUT_1ST_ARCH}
	-@if [ -f $(AUTOCONF_1ST_ARCH) ]; then \
		cp -pv $(AUTOCONF_1ST_ARCH) $(AUTOCONF_1ST_ARCH)_refsw; \
	fi
	cp ${BCM_VENDOR_STB_ROOT}/bcm_platform/signing/verity_dev_key.der.x509 ${LINUX_OUT_1ST_ARCH}/
	rm -f $(LINUX_OUT_1ST_ARCH)/config_fragment
	echo "# CONFIG_BCM3390A0 is not set" > $(LINUX_OUT_1ST_ARCH)/config_fragment
	echo "# CONFIG_BCM7145 is not set" >> $(LINUX_OUT_1ST_ARCH)/config_fragment
	echo "CONFIG_CROSS_COMPILE=\"arm-linux-gnueabihf-\"" >> $(LINUX_OUT_1ST_ARCH)/config_fragment
	echo "CONFIG_BCM$(KCONFIG_CHIP)=y" >> $(LINUX_OUT_1ST_ARCH)/config_fragment
	cd $(LINUX) && scripts/kconfig/merge_config.sh -O $(LINUX_OUT_1ST_ARCH) arch/arm/configs/brcmstb_defconfig $(LINUX_OUT_1ST_ARCH)/config_fragment
	rm -f $(LINUX_OUT_1ST_ARCH)/config_fragment
	cd $(LINUX) && KBUILD_OUTPUT=$(LINUX_OUT_1ST_ARCH) $(MAKE) $(KERNEL_IMG)
	-@if [ -f $(AUTOCONF_1ST_ARCH)_refsw ]; then \
		if [ `diff -q $(AUTOCONF_1ST_ARCH)_refsw $(AUTOCONF_1ST_ARCH) | wc -l` -eq 0 ]; then \
			echo "'generated/autoconf.h' is unchanged"; \
			cp -pv $(AUTOCONF_1ST_ARCH)_refsw $(AUTOCONF_1ST_ARCH); \
		fi; \
		rm -f $(AUTOCONF_1ST_ARCH)_refsw; \
	fi
	cp -pv $(LINUX_OUT_1ST_ARCH)/arch/arm/boot/$(KERNEL_IMG) $(KERNEL_OUT_DIR_ABS)/kernel
	@echo "'$@' completed"

build_kernel_2nd_arch:
	@echo "'$@' no-op"

endif

$(KERNEL_OUT_DIR)/kernel: build_kernel
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
