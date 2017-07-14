SHELL := /bin/bash
export SHELL

include $(dir $(lastword $(MAKEFILE_LIST)))definitions.mk
include $(dir $(lastword $(MAKEFILE_LIST)))targets.mk

NEXUS_ARCH_ENV := B_REFSW_ARCH=${B_REFSW_ARCH_1ST_ARCH}
NEXUS_ARCH_ENV += B_REFSW_KERNEL_CROSS_COMPILE=${B_REFSW_KERNEL_CROSS_COMPILE_1ST_ARCH}
NEXUS_ARCH_ENV += B_REFSW_TOOLCHAIN_ARCH=${B_REFSW_TOOLCHAIN_ARCH_1ST_ARCH}
NEXUS_ARCH_ENV += B_REFSW_OBJ_ROOT=${B_REFSW_OBJ_ROOT_1ST_ARCH}
NEXUS_ARCH_ENV += B_REFSW_ANDROID_LIB=${B_REFSW_ANDROID_LIB_1ST_ARCH}
NEXUS_ARCH_ENV += NEXUS_BIN_DIR=${NEXUS_BIN_DIR_1ST_ARCH}
NEXUS_ARCH_ENV += LINUX_OUT=${LINUX_OUT_1ST_ARCH}
NEXUS_ARCH_ENV += ANDROID_PREBUILT_LIBGCC=${B_REFSW_PREBUILT_LIBGCC_1ST_ARCH}

NEXUS_2ND_ARCH_ENV := B_REFSW_ARCH=${B_REFSW_ARCH_2ND_ARCH}
NEXUS_2ND_ARCH_ENV += B_REFSW_KERNEL_CROSS_COMPILE=${B_REFSW_KERNEL_CROSS_COMPILE_2ND_ARCH}
NEXUS_2ND_ARCH_ENV += B_REFSW_TOOLCHAIN_ARCH=${B_REFSW_TOOLCHAIN_ARCH_2ND_ARCH}
NEXUS_2ND_ARCH_ENV += B_REFSW_OBJ_ROOT=${B_REFSW_OBJ_ROOT_2ND_ARCH}
NEXUS_2ND_ARCH_ENV += B_REFSW_ANDROID_LIB=${B_REFSW_ANDROID_LIB_2ND_ARCH}
NEXUS_2ND_ARCH_ENV += NEXUS_BIN_DIR=${NEXUS_BIN_DIR_2ND_ARCH}
NEXUS_2ND_ARCH_ENV += LINUX_OUT=${LINUX_OUT_2ND_ARCH}
NEXUS_2ND_ARCH_ENV += ANDROID_PREBUILT_LIBGCC=${B_REFSW_PREBUILT_LIBGCC_2ND_ARCH}

BOLT_DIR           := ${BRCMSTB_ANDROID_VENDOR_PATH}/bolt
BOLT_DIR_VB        := ${BRCMSTB_ANDROID_VENDOR_PATH}/bolt-vb
ANDROID_BSU_DIR    := ${BOLT_DIR}/android
ANDROID_BSU_DIR_VB := ${BOLT_DIR_VB}/android

ifeq ($(B_REFSW_DEBUG), n)
    BUILD_TYPE ?= release
    SEC_LIB_MODE ?= retail
else
    BUILD_TYPE ?= debug
    SEC_LIB_MODE ?= debug
endif

ifeq ($(BCHP_VER_LOWER),)
BCHP_VER_LOWER := $(shell echo ${BCHP_VER} | tr [:upper:] [:lower:])
endif

ifeq ($(BOLT_IMG_TO_USE_OVERRIDE),)
BOLT_IMG_TO_USE_OVERRIDE := bolt-bb.bin
endif

# Include Nexus platform application Makefile include
# platform_app.inc modifies the PWD variable used by android.  Save it and restore afterward.
PWD_BEFORE_PLATFORM_APP := $(PWD)
include ${NEXUS_TOP}/platforms/$(PLATFORM)/build/platform_app.inc
PWD := $(PWD_BEFORE_PLATFORM_APP)

# filter out flags clashing with Android build system
FILTER_OUT_NEXUS_CFLAGS := -march=armv7-a -Wstrict-prototypes
NEXUS_CFLAGS := $(filter-out $(FILTER_OUT_NEXUS_CFLAGS), $(NEXUS_CFLAGS))

BRCMSTB_MODEL_NAME := bcm$(BCHP_CHIP)_$(BCHP_VER_LOWER)_$(MODEL_NAME)_$(HARDWARE_REV)
export BRCMSTB_MODEL_NAME

NEXUS_DEPS := \
	${PRODUCT_OUT}/obj/lib/libcutils.so \
	${PRODUCT_OUT}/obj/lib/crtbegin_dynamic.o \
	${PRODUCT_OUT}/obj/lib/crtend_android.o \
	mkbootimg

NEXUS_DEPS_2ND_ARCH := \
	${PRODUCT_OUT}/obj_arm/lib/libcutils.so \
	${PRODUCT_OUT}/obj_arm/lib/crtbegin_dynamic.o \
	${PRODUCT_OUT}/obj_arm/lib/crtend_android.o

NEXUS_APP_CFLAGS := $(addprefix -I,$(NEXUS_APP_INCLUDE_PATHS))
NEXUS_APP_CFLAGS += $(addprefix -D,$(NEXUS_APP_DEFINES))
NEXUS_APP_CFLAGS += -DBSTD_CPU_ENDIAN=BSTD_ENDIAN_LITTLE
NEXUS_APP_CFLAGS += -DB_REFSW_ANDROID
ifeq ($(SAGE_SUPPORT),y)
include ${BCM_VENDOR_STB_ROOT}/refsw/magnum/syslib/sagelib/bsagelib_public.inc
NEXUS_APP_CFLAGS += $(addprefix -D,$(BSAGELIB_DEFINES))
endif
export NEXUS_APP_CFLAGS

define setup_nexus_toolchains
	@if [ -d "${B_REFSW_TOOLCHAINS_INSTALL}" ]; then \
		rm -rf ${B_REFSW_TOOLCHAINS_INSTALL}; \
	fi;
	@mkdir -p ${B_REFSW_TOOLCHAINS_INSTALL};
	@if [ "${B_REFSW_USES_CLANG}" == "y" ] ; then \
		ln -s ${P_REFSW_CC_CLANG}/clang ${B_REFSW_TOOLCHAINS_INSTALL}gcc; \
		ln -s ${P_REFSW_CC_CLANG}/clang ${B_REFSW_TOOLCHAINS_INSTALL}cpp; \
		ln -s ${P_REFSW_CC_CLANG}/clang++ ${B_REFSW_TOOLCHAINS_INSTALL}c++; \
		ln -s ${P_REFSW_CC_CLANG}/clang++ ${B_REFSW_TOOLCHAINS_INSTALL}g++; \
	elif [ "$(1)" == "2nd_arch" ] ; then \
		ln -s ${P_REFSW_CC_2ND_ARCH}gcc ${B_REFSW_TOOLCHAINS_INSTALL}gcc; \
		ln -s ${P_REFSW_CC_2ND_ARCH}cpp ${B_REFSW_TOOLCHAINS_INSTALL}cpp; \
		ln -s ${P_REFSW_CC_2ND_ARCH}c++ ${B_REFSW_TOOLCHAINS_INSTALL}c++; \
		ln -s ${P_REFSW_CC_2ND_ARCH}c++ ${B_REFSW_TOOLCHAINS_INSTALL}g++; \
	else \
		ln -s ${P_REFSW_CC}gcc ${B_REFSW_TOOLCHAINS_INSTALL}gcc; \
		ln -s ${P_REFSW_CC}cpp ${B_REFSW_TOOLCHAINS_INSTALL}cpp; \
		ln -s ${P_REFSW_CC}c++ ${B_REFSW_TOOLCHAINS_INSTALL}c++; \
		ln -s ${P_REFSW_CC}c++ ${B_REFSW_TOOLCHAINS_INSTALL}g++; \
	fi;
	@if [ "$(1)" == "2nd_arch" ] ; then \
		ln -s ${P_REFSW_CC_2ND_ARCH}ar ${B_REFSW_TOOLCHAINS_INSTALL}ar; \
	else \
		ln -s ${P_REFSW_CC}ar ${B_REFSW_TOOLCHAINS_INSTALL}ar; \
	fi;
endef

.PHONY: nexus_build
nexus_build: clean_recovery_ramdisk build_kernel $(NEXUS_DEPS) build_bootloaderimg build_lk
	@echo "'$@' started"
	$(call setup_nexus_toolchains,1st_arch)
	@if [ ! -d "${NEXUS_BIN_DIR_1ST_ARCH}" ]; then \
		mkdir -p ${NEXUS_BIN_DIR_1ST_ARCH}; \
	fi
	@if [ ! -d "${B_REFSW_OBJ_ROOT_1ST_ARCH}/k_drivers/" ]; then \
		mkdir -p ${B_REFSW_OBJ_ROOT_1ST_ARCH}/k_drivers/; \
	fi
	$(MAKE) $(NEXUS_ARCH_ENV) -C $(NEXUS_TOP)/nxclient/server server
	cp -faR $(BRCMSTB_ANDROID_DRIVER_PATH)/droid_pm ${B_REFSW_OBJ_ROOT_1ST_ARCH}/k_drivers/ && \
	$(MAKE) $(NEXUS_ARCH_ENV) ARCH=${P_REFSW_DRV_ARCH} -C ${B_REFSW_OBJ_ROOT_1ST_ARCH}/k_drivers/droid_pm INSTALL_DIR=$(NEXUS_BIN_DIR_1ST_ARCH) install
	cp -faR $(BRCMSTB_ANDROID_DRIVER_PATH)/fbdev ${B_REFSW_OBJ_ROOT_1ST_ARCH}/k_drivers/ && \
	$(MAKE) $(NEXUS_ARCH_ENV) ARCH=${P_REFSW_DRV_ARCH} -C ${B_REFSW_OBJ_ROOT_1ST_ARCH}/k_drivers/fbdev INSTALL_DIR=$(NEXUS_BIN_DIR_1ST_ARCH) install
	cp -faR $(BRCMSTB_ANDROID_DRIVER_PATH)/nx_ashmem ${B_REFSW_OBJ_ROOT_1ST_ARCH}/k_drivers/ && \
	$(MAKE) $(NEXUS_ARCH_ENV) ARCH=${P_REFSW_DRV_ARCH} -C ${B_REFSW_OBJ_ROOT_1ST_ARCH}/k_drivers/nx_ashmem NEXUS_MODE=driver INSTALL_DIR=$(NEXUS_BIN_DIR_1ST_ARCH) install
	mkdir -p ${B_REFSW_OBJ_ROOT_1ST_ARCH}/k_drivers/gator && cp -faR $(BRCMSTB_ANDROID_DRIVER_PATH)/gator/driver ${B_REFSW_OBJ_ROOT_1ST_ARCH}/k_drivers/gator && \
	$(MAKE) $(NEXUS_ARCH_ENV) ARCH=${P_REFSW_DRV_ARCH} -C $(LINUX_OUT_1ST_ARCH) M=${B_REFSW_OBJ_ROOT_1ST_ARCH}/k_drivers/gator/driver modules && \
	cp ${B_REFSW_OBJ_ROOT_1ST_ARCH}/k_drivers/gator/driver/gator.ko $(NEXUS_BIN_DIR_1ST_ARCH)
	@echo "'$@' completed"

.PHONY: nexus_build_2nd_arch
ifeq ($(TARGET_2ND_ARCH),arm)
nexus_build_2nd_arch: $(NEXUS_DEPS_2ND_ARCH) build_kernel_2nd_arch nexus_build
	$(call setup_nexus_toolchains,2nd_arch)
	@echo "'$@' started"
	@if [ ! -d "${NEXUS_BIN_DIR_2ND_ARCH}" ]; then \
		mkdir -p ${NEXUS_BIN_DIR_2ND_ARCH}; \
	fi
	$(MAKE) $(NEXUS_2ND_ARCH_ENV) -C $(NEXUS_TOP)/nxclient/server server
	@echo "'$@' completed"
else
nexus_build_2nd_arch:
	@echo "'$@' no-op"
endif

.PHONY: clean_bolt
clean_bolt: clean_android_bsu
	rm -rf $(B_BOLT_OBJ_ROOT)
	rm -f $(PRODUCT_OUT_FROM_TOP)/bolt-ba.bin
	rm -f $(PRODUCT_OUT_FROM_TOP)/bolt-bb.bin

.PHONY: clean_bolt_vb
clean_bolt_vb: clean_android_bsu_vb
	rm -rf $(B_BOLT_VB_OBJ_ROOT)
	rm -f $(PRODUCT_OUT_FROM_TOP)/bolt-ba-vb.bin
	rm -f $(PRODUCT_OUT_FROM_TOP)/bolt-bb-vb.bin

.PHONY: build_bolt
build_bolt:
	@echo "'$@' started"
	@if [ ! -d "${B_BOLT_OBJ_ROOT}" ]; then \
		mkdir -p ${B_BOLT_OBJ_ROOT}; \
	fi
	$(MAKE) -C $(BOLT_DIR) $(BCHP_CHIP)$(BCHP_VER_LOWER) ODIR=$(B_BOLT_OBJ_ROOT) GEN=$(B_BOLT_OBJ_ROOT)
	cp -pv $(B_BOLT_OBJ_ROOT)/bolt-ba.bin $(PRODUCT_OUT_FROM_TOP)/bolt-ba.bin || :
	cp -pv $(B_BOLT_OBJ_ROOT)/bolt-bb.bin $(PRODUCT_OUT_FROM_TOP)/bolt-bb.bin || :
	@echo "'$@' completed"

.PHONY: build_bolt_vb
build_bolt_vb:
	@echo "'$@' started"
	@if [ ! -d "${B_BOLT_VB_OBJ_ROOT}" ]; then \
		mkdir -p ${B_BOLT_VB_OBJ_ROOT}; \
	fi
	$(MAKE) -C $(BOLT_DIR_VB) $(BCHP_CHIP)$(BCHP_VER_LOWER) SECURE_BOOT=y SINGLE_BOARD=$(BOLT_BOARD_VB) ODIR=$(B_BOLT_VB_OBJ_ROOT) GEN=$(B_BOLT_VB_OBJ_ROOT)
	cp -pv $(B_BOLT_VB_OBJ_ROOT)/bolt-ba.bin $(PRODUCT_OUT_FROM_TOP)/bolt-ba-vb.bin || :
	cp -pv $(B_BOLT_VB_OBJ_ROOT)/bolt-bb.bin $(PRODUCT_OUT_FROM_TOP)/bolt-bb-vb.bin || :
	cp -pv $(B_BOLT_VB_OBJ_ROOT)/external_bfw*_avs_memsys.bin $(PRODUCT_OUT_FROM_TOP)/ || :
	@echo "'$@' completed"

.PHONY: clean_android_bsu
clean_android_bsu:
	rm -f $(PRODUCT_OUT_FROM_TOP)/android_bsu.elf

.PHONY: clean_android_bsu_vb
clean_android_bsu_vb:
	rm -f $(PRODUCT_OUT_FROM_TOP)/android_bsu-vb.elf

.PHONY: build_android_bsu
build_android_bsu: build_bolt
	@echo "'$@' started"
	$(MAKE) -C $(ANDROID_BSU_DIR) $(BCHP_CHIP)$(BCHP_VER_LOWER) ODIR=$(B_BOLT_OBJ_ROOT) GEN=$(B_BOLT_OBJ_ROOT)
	cp -pv $(B_BOLT_OBJ_ROOT)/android_bsu.elf $(PRODUCT_OUT_FROM_TOP)/android_bsu.elf || :
	@echo "'$@' completed"

.PHONY: build_android_bsu_vb
build_android_bsu_vb: build_bolt_vb
	@echo "'$@' started"
	$(MAKE) -C $(ANDROID_BSU_DIR_VB) $(BCHP_CHIP)$(BCHP_VER_LOWER) SECURE_BOOT=y SINGLE_BOARD=$(BOLT_BOARD_VB) ODIR=$(B_BOLT_VB_OBJ_ROOT) GEN=$(B_BOLT_VB_OBJ_ROOT)
	cp -pv $(B_BOLT_VB_OBJ_ROOT)/android_bsu.elf $(PRODUCT_OUT_FROM_TOP)/android_bsu-vb.elf || :
	@echo "'$@' completed"

.PHONY: build_bootloaderimg
ifeq ($(HW_TZ_SUPPORT),y)
build_bootloaderimg: build_android_bsu build_bl31
	@echo "'$@' started"
	$(ANDROID_BSU_DIR)/scripts/bootloaderimg.py $(PRODUCT_OUT_FROM_TOP)/$(BOLT_IMG_TO_USE_OVERRIDE) $(PRODUCT_OUT_FROM_TOP)/android_bsu.elf $(PRODUCT_OUT_FROM_TOP)/bl31.bin $(PRODUCT_OUT_FROM_TOP)/bootloader.img
	@echo "'$@' completed"
else
build_bootloaderimg: build_android_bsu
	@echo "'$@' started"
	$(ANDROID_BSU_DIR)/scripts/bootloaderimg.py $(PRODUCT_OUT_FROM_TOP)/$(BOLT_IMG_TO_USE_OVERRIDE) $(PRODUCT_OUT_FROM_TOP)/android_bsu.elf $(PRODUCT_OUT_FROM_TOP)/bootloader.img
	@echo "'$@' completed"
endif

.PHONY: clean_bootloaderimg
clean_bootloaderimg: clean_bolt clean_android_bsu clean_bl31
	rm -f $(PRODUCT_OUT_FROM_TOP)/bootloader.img

.PHONY: clean_nexus
clean_nexus:
	rm -rf ${B_REFSW_OBJ_ROOT_1ST_ARCH}
	rm -rf ${B_REFSW_OBJ_ROOT_2ND_ARCH}

.PHONY: clean_refsw
clean_refsw: clean_nexus clean_bolt clean_bootloaderimg clean_lk
	@echo "================ MAKE CLEAN"
	rm -rf ${BRCMSTB_ANDROID_OUT_PATH}/target/product/${ANDROID_PRODUCT_OUT}/obj/FAKE/refsw/
	rm -rf ${BRCMSTB_ANDROID_OUT_PATH}/target/product/${ANDROID_PRODUCT_OUT}/obj/EXECUTABLES/nxserver_*
	rm -rf ${BRCMSTB_ANDROID_OUT_PATH}/target/product/${ANDROID_PRODUCT_OUT}/obj/EXECUTABLES/nxmini_*

clean : clean_refsw

REFSW_BUILD_TARGETS := $(REFSW_TARGET_LIST)
$(REFSW_BUILD_TARGETS) : nexus_build
	@echo "'reference software (nexus) build' target: $@"

ifeq ($(TARGET_2ND_ARCH),arm)
REFSW_BUILD_TARGETS_2ND_ARCH := $(REFSW_TARGET_LIST_2ND_ARCH)
$(REFSW_BUILD_TARGETS_2ND_ARCH) : nexus_build_2nd_arch
	@echo "'reference software (nexus) build' target: $@"
endif

.PHONY: nexus_multi_arch
nexus_multi_arch: nexus_build nexus_build_2nd_arch
	@echo "$@"

.PHONY: build_lk
ifneq ($(LKROOT),)
build_lk:
	@echo "'$@' started"
	@if [ ! -d "${B_LK_OBJ_ROOT}" ]; then \
		mkdir -p ${B_LK_OBJ_ROOT}; \
	fi
	$(MAKE) -f ${LKROOT}/makefile BUILDROOT=${B_LK_OBJ_ROOT} ${LOCAL_LK_DEVICE}
	cp ${B_LK_OBJ_ROOT}/build-${LOCAL_LK_DEVICE}/lk.bin $(PRODUCT_OUT_FROM_TOP)/lk-tee.bin
	@echo "'$@' completed"
else
build_lk:
	@echo "'$@' not integrated for this device."
endif

.PHONY: clean_lk
ifneq ($(LKROOT),)
clean_lk:
	rm -rf ${B_LK_OBJ_ROOT};
else
clean_lk:
	@echo "'$@' not integrated for this device."
endif

.PHONY: build_bl31
ifeq ($(HW_TZ_SUPPORT),y)
build_bl31:
	@echo "'$@' started"
	@if [ ! -d "${B_BL31_OBJ_ROOT}" ]; then \
		mkdir -p ${B_BL31_OBJ_ROOT}; \
	fi
	cp -faR $(ARMTFROOT)/* ${B_BL31_OBJ_ROOT} && cd ${B_BL31_OBJ_ROOT} && \
	CROSS_COMPILE=aarch64-linux-gnu- $(MAKE) -f Makefile PLAT=${LOCAL_BL31_DEVICE} SPD=trusty bl31
	cp ${B_BL31_OBJ_ROOT}/build/${LOCAL_BL31_DEVICE}/release/bl31.bin $(PRODUCT_OUT_FROM_TOP)/bl31.bin
	@echo "'$@' completed"
else
build_bl31:
	@echo "'$@' not integrated for this device."
endif

.PHONY: clean_bl31
ifeq ($(HW_TZ_SUPPORT),y)
clean_bl31:
	rm -rf ${B_BL31_OBJ_ROOT};
else
clean_bl31:
	@echo "'$@' not integrated for this device."
endif

.PHONY: nexus_ndk
nexus_ndk:
	$(call setup_nexus_toolchains,1st_arch)
	@echo "'$@' started"
	@if [ ! -d "${NEXUS_BIN_DIR_1ST_ARCH}" ]; then \
		@echo "you must build nexus first..."; \
	else \
		$(MAKE) $(NEXUS_ARCH_ENV) -C $(NEXUS_TOP)/build nexus_headers; \
		$(MAKE) $(NEXUS_ARCH_ENV) -C $(NEXUS_TOP)/nxclient/build nexus_headers; \
	fi
	@echo "'$@' completed"

.PHONY: nexus_ndk_2nd_arch
ifeq ($(TARGET_2ND_ARCH),arm)
nexus_ndk_2nd_arch:
	$(call setup_nexus_toolchains,2nd_arch)
	@echo "'$@' started"
	@if [ ! -d "${NEXUS_BIN_DIR_2ND_ARCH}" ]; then \
		@echo "you must build nexus first..."; \
	else \
		$(MAKE) $(NEXUS_2ND_ARCH_ENV) -C $(NEXUS_TOP)/build nexus_headers; \
		$(MAKE) $(NEXUS_2ND_ARCH_ENV) -C $(NEXUS_TOP)/nxclient/build nexus_headers; \
	fi
	@echo "'$@' completed"
else
nexus_ndk_2nd_arch:
	@echo "'$@' no-op"
endif

# standalone rules to clean/build the security libs from source, this assumes you have
# an environment allowing you to do that, otherwise do not bother.
#
# the libs are built in a NDK-like manner since that is essentially what they correspond
# to in the final android image.
#
# note: the order of the build components is important.
#

clean_recovery_ramdisk :
	@echo "'$@' started"
	rm -rf ${BRCMSTB_ANDROID_OUT_PATH}/target/product/${ANDROID_PRODUCT_OUT}/root/system/*
	rm -rf ${BRCMSTB_ANDROID_OUT_PATH}/target/product/${ANDROID_PRODUCT_OUT}/root/sbin/nxmini
	@echo "'$@' completed"

export URSR_TOP := ${REFSW_BASE_DIR}
export COMMON_DRM_TOP := $(URSR_TOP)/BSEAV/lib/security/common_drm
export PLAYREADY_ROOT := $(REFSW_BASE_DIR)/prsrcs/2.5/
export PLAYREADY_DIR := $(PLAYREADY_ROOT)/source/linux
export _NTROOT=${PLAYREADY_ROOT}
export PRDY_TOP := $(REFSW_BASE_DIR)/prsrcs

clean_security_user :
	$(MAKE) -C $(REFSW_BASE_DIR)/secsrcs/common_drm clean
	rm -f $(REFSW_BASE_DIR)/BSEAV/lib/security/common_drm/drm/common/drm_common.o
	$(MAKE) -C $(REFSW_BASE_DIR)/secsrcs/third_party/android/drm/widevine/OEMCrypto clean
	$(MAKE) -C $(REFSW_BASE_DIR)/prsrcs/2.5/source clean

# build all the needed libs, then check them into the source tree as 'prebuilts'.
#
security_user:
	$(call setup_nexus_toolchains,1st_arch)
	@echo "'$@' started"
	$(MAKE) $(NEXUS_ARCH_ENV) -C $(REFSW_BASE_DIR)/secsrcs/common_drm all
	$(MAKE) $(NEXUS_ARCH_ENV) -C $(REFSW_BASE_DIR)/prsrcs/2.5/source all
	$(MAKE) $(NEXUS_ARCH_ENV) -C $(REFSW_BASE_DIR)/secsrcs/third_party/android/drm/widevine/OEMCrypto
	@echo "'$@' completed"

ifeq ($(TARGET_2ND_ARCH),arm)
security_user_2nd_arch:
	$(call setup_nexus_toolchains,2nd_arch)
	@echo "'$@' started"
	$(MAKE) $(NEXUS_2ND_ARCH_ENV) -C $(REFSW_BASE_DIR)/secsrcs/common_drm all
	$(MAKE) $(NEXUS_2ND_ARCH_ENV) -C $(REFSW_BASE_DIR)/prsrcs/2.5/source all
	$(MAKE) $(NEXUS_2ND_ARCH_ENV) -C $(REFSW_BASE_DIR)/secsrcs/third_party/android/drm/widevine/OEMCrypto
	@echo "'$@' completed"
else
security_user_2nd_arch:
	@echo "'$@' no-op"
endif

ifeq ($(ANDROID_SUPPORTS_DTVKIT),y)
include device/broadcom/common/middleware/dtvkit.mk
endif
ifneq ($(HW_WIFI_SUPPORT),n)
ifeq ($(HW_WIFI_NIC_SUPPORT),y)
include device/broadcom/common/connectivity/bcmnic.mk
else
ifeq ($(HW_WIFI_NIC_DUAL_SUPPORT),y)
include device/broadcom/common/connectivity/bcmnic-dual.mk
else
include device/broadcom/common/connectivity/bcmdhd.mk
endif
endif
endif
