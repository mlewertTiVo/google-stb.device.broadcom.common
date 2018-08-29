export SHELL

include $(dir $(lastword $(MAKEFILE_LIST)))bindist.mk
include $(dir $(lastword $(MAKEFILE_LIST)))definitions.mk
include $(dir $(lastword $(MAKEFILE_LIST)))targets.mk

NEXUS_ARCH_ENV := B_REFSW_KERNEL_CROSS_COMPILE=${B_REFSW_KERNEL_CROSS_COMPILE_1ST_ARCH}
NEXUS_ARCH_ENV += B_REFSW_TOOLCHAIN_ARCH=${B_REFSW_TOOLCHAIN_ARCH_1ST_ARCH}
NEXUS_ARCH_ENV += B_REFSW_OBJ_ROOT=${B_REFSW_OBJ_ROOT_1ST_ARCH}
NEXUS_ARCH_ENV += B_REFSW_ANDROID_LIB=${B_REFSW_ANDROID_LIB_1ST_ARCH}
NEXUS_ARCH_ENV += NEXUS_BIN_DIR=${NEXUS_BIN_DIR_1ST_ARCH}
NEXUS_ARCH_ENV += LINUX_OUT=${LINUX_OUT_1ST_ARCH}
NEXUS_ARCH_ENV += ANDROID_PREBUILT_LIBGCC=${B_REFSW_PREBUILT_LIBGCC_1ST_ARCH}
NEXUS_ARCH_KERN_ENV := ${NEXUS_ARCH_ENV}
NEXUS_ARCH_KERN_ENV += B_REFSW_ARCH=${B_REFSW_KERNEL_ARCH_1ST_ARCH}
NEXUS_ARCH_ENV += B_REFSW_ARCH=${B_REFSW_ARCH_1ST_ARCH}

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

ifeq ($(BCHP_VER_LOWER),)
BCHP_VER_LOWER := $(shell echo ${BCHP_VER} | tr [:upper:] [:lower:])
endif
ifeq ($(BCHP_VER_BOLT),)
BCHP_VER_BOLT := ${BCHP_VER_LOWER}
endif

# Include Nexus platform application Makefile include
# platform_app.inc modifies the PWD variable used by android.  Save it and restore afterward.
PWD_BEFORE_PLATFORM_APP := $(PWD)
include ${NEXUS_TOP}/platforms/$(PLATFORM)/build/platform_app.inc
PWD := $(PWD_BEFORE_PLATFORM_APP)

# filter out flags clashing with Android build system
FILTER_OUT_NEXUS_CFLAGS := -march=armv7-a -Wstrict-prototypes
NEXUS_CFLAGS := $(filter-out $(FILTER_OUT_NEXUS_CFLAGS), $(NEXUS_CFLAGS))

NEXUS_DEPS := \
	${PRODUCT_OUT}/obj/lib/libc.so \
	${PRODUCT_OUT}/obj/lib/libc++.so \
	${PRODUCT_OUT}/obj/lib/libcutils.so \
	${PRODUCT_OUT}/obj/lib/libdl.so \
	${PRODUCT_OUT}/obj/lib/liblog.so \
	${PRODUCT_OUT}/obj/lib/libm.so \
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
		ln -s ${P_REFSW_CC_CLANG}/clang.real ${B_REFSW_TOOLCHAINS_INSTALL}clang.real; \
		ln -s ${P_REFSW_CC_CLANG}/clang++.real ${B_REFSW_TOOLCHAINS_INSTALL}clang++.real; \
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

ifneq ($(BCM_DIST_KNLIMG_BINS),y)
.PHONY: clean_nexus
clean_nexus:
	rm -rf ${B_REFSW_OBJ_ROOT_1ST_ARCH}
	rm -rf ${B_REFSW_OBJ_ROOT_2ND_ARCH}

.PHONY: clean_refsw
clean_refsw: clean_nexus clean_bootloaderimg clean_lk
	rm -rf ${BRCMSTB_ANDROID_OUT_PATH}/target/product/${LOCAL_PRODUCT_OUT}/obj/FAKE/refsw/
	rm -rf ${BRCMSTB_ANDROID_OUT_PATH}/target/product/${LOCAL_PRODUCT_OUT}/obj/EXECUTABLES/nxserver_*
	rm -rf ${BRCMSTB_ANDROID_OUT_PATH}/target/product/${LOCAL_PRODUCT_OUT}/obj/EXECUTABLES/nxmini_*

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

.PHONY: bindist_build
bindist_build: bindist_core_build
	@if [ "${HW_WIFI_SUPPORT}" != "n" ]; then \
		if [ "${HW_WIFI_NIC_SUPPORT}" == "y" ]; then \
			if [ ! -d "${B_NIC_OBJ_ROOT}" ]; then \
				mkdir -p ${B_NIC_OBJ_ROOT}; \
			fi; \
			cp -faR ${BROADCOM_NIC_SOURCE_PATH}/src ${B_NIC_OBJ_ROOT}  && cp ${BROADCOM_NIC_SCRIPT_PATH}/*.sh ${B_NIC_OBJ_ROOT}; \
			cp -faR ${BROADCOM_NIC_SOURCE_PATH}/components ${B_NIC_OBJ_ROOT}; \
			if [[ "${LOCAL_ARM_AARCH64_COMPAT_32_BIT}" == "y" || "${LOCAL_ANDROID_64BIT}" == "y" ]]; then \
				cd ${B_NIC_OBJ_ROOT} && source ./setenv-android-stb7271v8.sh && PATH=${B_KNB_TOOLCHAIN}:$$PATH SHORTER_PATH=1 ./build-drv-nic.sh ${BRCM_NIC_TARGET_NAME}; \
			else \
				cd ${B_NIC_OBJ_ROOT} && source ./setenv-android-stb7271.sh && PATH=${B_KNB_TOOLCHAIN}:$$PATH SHORTER_PATH=1 ./build-drv-nic.sh ${BRCM_NIC_TARGET_NAME}; \
			fi; \
		fi; \
		if [ "${HW_WIFI_NIC_DUAL_SUPPORT}" == "y" ]; then \
			if [ ! -d "${B_NIC_DUAL_OBJ_ROOT}" ]; then \
				mkdir -p ${B_NIC_DUAL_OBJ_ROOT}; \
			fi; \
			cp -faR ${BROADCOM_NIC_DUAL_SOURCE_PATH}/* ${B_NIC_DUAL_OBJ_ROOT}  && cp ${BROADCOM_NIC_DUAL_SOURCE_PATH}/*.sh ${B_NIC_DUAL_OBJ_ROOT}; \
			cd ${B_NIC_DUAL_OBJ_ROOT} && source ./setenv-android-stb7445.sh ${BRCM_NIC_DUAL_CHIPVER} && PATH=${B_KNB_TOOLCHAIN}:$$PATH LINUX_OUT=${LINUX_OUT_1ST_ARCH} ./build-drv.sh ${BRCM_NIC_DUAL_TARGET}; \
		fi; \
		if [[ "${HW_WIFI_NIC_SUPPORT}" != "y" && "${HW_WIFI_NIC_DUAL_SUPPORT}" != "y" ]]; then \
			if [ ! -d "${B_DHD_OBJ_ROOT}" ]; then \
				mkdir -p ${B_DHD_OBJ_ROOT}; \
			fi; \
			cp -faR ${BROADCOM_DHD_SOURCE_PATH}/dhd ${B_DHD_OBJ_ROOT} && cp ${BROADCOM_DHD_SOURCE_PATH}/*.sh ${B_DHD_OBJ_ROOT}; \
			if [[ "${LOCAL_ARM_AARCH64_COMPAT_32_BIT}" == "y" || "${LOCAL_ANDROID_64BIT}" == "y" ]]; then \
				cd ${B_DHD_OBJ_ROOT} && source ./setenv-android-stb72xx.sh ${BROADCOM_WIFI_CHIPSET} && PATH=${B_KNB_TOOLCHAIN}:$$PATH LINUX_OUT=${LINUX_OUT_1ST_ARCH} BRCM_DHD_TARGET_NVRAM_PATH=${BRCM_DHD_TARGET_NVRAM_PATH} ./bfd-drv-cfg80211.sh; \
			else \
				cd ${B_DHD_OBJ_ROOT} && source ./setenv-android-stb7445.sh ${BROADCOM_WIFI_CHIPSET} && PATH=${B_KNB_TOOLCHAIN}:$$PATH LINUX_OUT=${LINUX_OUT_1ST_ARCH} BRCM_DHD_TARGET_NVRAM_PATH=${BRCM_DHD_TARGET_NVRAM_PATH} ./bfd-drv-cfg80211.sh; \
			fi; \
		fi; \
	fi
	@echo "'$@' completed"

.PHONY: bindist_core_build
bindist_core_build: build_kernel build_dtboimg $(NEXUS_DEPS)
	@echo "'$@' started"
	$(call setup_nexus_toolchains,1st_arch)
	@if [ ! -d "${NEXUS_BIN_DIR_1ST_ARCH}" ]; then \
		mkdir -p ${NEXUS_BIN_DIR_1ST_ARCH}; \
	fi
	@if [ ! -d "${B_REFSW_OBJ_ROOT_1ST_ARCH}/k_drivers/" ]; then \
		mkdir -p ${B_REFSW_OBJ_ROOT_1ST_ARCH}/k_drivers/; \
	fi
	PATH=${B_KNB_TOOLCHAIN}:$$PATH $(MAKE) $(NEXUS_ARCH_ENV) -C $(NEXUS_TOP)/nxclient/server server
	cp -faR $(BRCMSTB_ANDROID_DRIVER_PATH)/droid_pm ${B_REFSW_OBJ_ROOT_1ST_ARCH}/k_drivers/ && \
	PATH=${B_KNB_TOOLCHAIN}:$$PATH $(MAKE) $(NEXUS_ARCH_KERN_ENV) ARCH=${P_REFSW_DRV_ARCH} -C ${B_REFSW_OBJ_ROOT_1ST_ARCH}/k_drivers/droid_pm INSTALL_DIR=$(NEXUS_BIN_DIR_1ST_ARCH) install
	cp -faR $(BRCMSTB_ANDROID_DRIVER_PATH)/fbdev ${B_REFSW_OBJ_ROOT_1ST_ARCH}/k_drivers/ && \
	PATH=${B_KNB_TOOLCHAIN}:$$PATH $(MAKE) $(NEXUS_ARCH_KERN_ENV) ARCH=${P_REFSW_DRV_ARCH} -C ${B_REFSW_OBJ_ROOT_1ST_ARCH}/k_drivers/fbdev INSTALL_DIR=$(NEXUS_BIN_DIR_1ST_ARCH) install
	cp -faR $(BRCMSTB_ANDROID_DRIVER_PATH)/nx_ashmem ${B_REFSW_OBJ_ROOT_1ST_ARCH}/k_drivers/ && \
	PATH=${B_KNB_TOOLCHAIN}:$$PATH $(MAKE) $(NEXUS_ARCH_KERN_ENV) ARCH=${P_REFSW_DRV_ARCH} -C ${B_REFSW_OBJ_ROOT_1ST_ARCH}/k_drivers/nx_ashmem NEXUS_MODE=driver INSTALL_DIR=$(NEXUS_BIN_DIR_1ST_ARCH) install
	@echo "'$@' completed"

.PHONY: nexus_build
nexus_build: clean_recovery_ramdisk build_bootloaderimg build_lk bindist_build
	@echo "'$@' started"
	@if [ "${LOCAL_GATOR_SUPPORT}" == "y" ]; then \
		mkdir -p ${B_REFSW_OBJ_ROOT_1ST_ARCH}/k_drivers/gator && cp -faR $(BRCMSTB_ANDROID_DRIVER_PATH)/gator/driver ${B_REFSW_OBJ_ROOT_1ST_ARCH}/k_drivers/gator && \
		PATH=${B_KNB_TOOLCHAIN}:$$PATH $(MAKE) $(NEXUS_ARCH_KERN_ENV) ARCH=${P_REFSW_DRV_ARCH} -C $(LINUX_OUT_1ST_ARCH) M=${B_REFSW_OBJ_ROOT_1ST_ARCH}/k_drivers/gator/driver modules && \
		cp ${B_REFSW_OBJ_ROOT_1ST_ARCH}/k_drivers/gator/driver/gator.ko $(NEXUS_BIN_DIR_1ST_ARCH); \
	fi
	@echo "'$@' completed"

.PHONY: nexus_build_2nd_arch
ifeq ($(TARGET_2ND_ARCH),arm)
nexus_build_2nd_arch: $(NEXUS_DEPS_2ND_ARCH) build_kernel_2nd_arch nexus_build
	$(call setup_nexus_toolchains,2nd_arch)
	@echo "'$@' started"
	@if [ ! -d "${NEXUS_BIN_DIR_2ND_ARCH}" ]; then \
		mkdir -p ${NEXUS_BIN_DIR_2ND_ARCH}; \
	fi
	PATH=${B_KNB_TOOLCHAIN}:$$PATH $(MAKE) $(NEXUS_2ND_ARCH_ENV) -C $(NEXUS_TOP)/nxclient/server server
	@echo "'$@' completed"
else
nexus_build_2nd_arch:
	@echo "'$@' no-op"
endif
endif

ifneq ($(BCM_DIST_BLIMG_BINS),y)
.PHONY: clean_bolt
clean_bolt: clean_android_bsu
	rm -rf $(B_BOLT_OBJ_ROOT)
	rm -f $(PRODUCT_OUT_FROM_TOP)/bolt*.bin

.PHONY: clean_bolt_vb
clean_bolt_vb: clean_android_bsu_vb
	rm -rf $(B_BOLT_VB_OBJ_ROOT)
	rm -f $(PRODUCT_OUT_FROM_TOP)/bolt*.bin

.PHONY: build_bolt
build_bolt:
	@echo "'$@' started"
	@if [ ! -d "${B_BOLT_OBJ_ROOT}" ]; then \
		mkdir -p ${B_BOLT_OBJ_ROOT}; \
	fi
	@if [ "${B_BOLT_CUSTOM_OVERRIDE}" != "" ]; then \
		cp -faR ${B_BOLT_CUSTOM_OVERRIDE}/* $(BOLT_DIR)/custom; \
	fi
	@if [ "${B_BOLT_CFG_OVERRIDE}" != "" ]; then \
		PATH=${B_KNB_TOOLCHAIN}:$$PATH $(MAKE) -C $(BOLT_DIR) $(BCHP_CHIP)$(BCHP_VER_BOLT) CFG=${B_BOLT_CFG_OVERRIDE} ODIR=$(B_BOLT_OBJ_ROOT) GEN=$(B_BOLT_OBJ_ROOT); \
	else \
		PATH=${B_KNB_TOOLCHAIN}:$$PATH $(MAKE) -C $(BOLT_DIR) $(BCHP_CHIP)$(BCHP_VER_BOLT) ODIR=$(B_BOLT_OBJ_ROOT) GEN=$(B_BOLT_OBJ_ROOT); \
	fi
	cp -pv $(B_BOLT_OBJ_ROOT)/$(BOLT_IMG_TO_USE_OVERRIDE) $(PRODUCT_OUT_FROM_TOP)/$(BOLT_IMG_TO_USE_OVERRIDE);
	@if [ "${BOLT_IMG_TO_USE_OVERRIDE_2ND}" != "" ]; then \
		cp -pv $(B_BOLT_OBJ_ROOT)/$(BOLT_IMG_TO_USE_OVERRIDE_2ND) $(PRODUCT_OUT_FROM_TOP)/$(BOLT_IMG_TO_USE_OVERRIDE_2ND); \
	fi
	@echo "'$@' completed"

.PHONY: build_bolt_vb
build_bolt_vb:
	@echo "'$@' started"
	@if [ ! -d "${B_BOLT_VB_OBJ_ROOT}" ]; then \
		mkdir -p ${B_BOLT_VB_OBJ_ROOT}; \
	fi
	@if [ "${B_BOLT_CUSTOM_OVERRIDE}" != "" ]; then \
		cp -faR ${B_BOLT_CUSTOM_OVERRIDE}/* $(BOLT_DIR_VB)/custom; \
	fi
	@if [ "${B_BOLT_CFG_OVERRIDE}" != "" ]; then \
		PATH=${B_KNB_TOOLCHAIN}:$$PATH $(MAKE) -C $(BOLT_DIR_VB) $(BCHP_CHIP)$(BCHP_VER_BOLT) CFG=${B_BOLT_CFG_OVERRIDE} SECURE_BOOT=y SINGLE_BOARD=$(BOLT_BOARD_VB) ODIR=$(B_BOLT_VB_OBJ_ROOT) GEN=$(B_BOLT_VB_OBJ_ROOT); \
	else \
		PATH=${B_KNB_TOOLCHAIN}:$$PATH $(MAKE) -C $(BOLT_DIR_VB) $(BCHP_CHIP)$(BCHP_VER_BOLT) SECURE_BOOT=y SINGLE_BOARD=$(BOLT_BOARD_VB) ODIR=$(B_BOLT_VB_OBJ_ROOT) GEN=$(B_BOLT_VB_OBJ_ROOT); \
	fi
	cp -pv $(B_BOLT_VB_OBJ_ROOT)/$(BOLT_IMG_TO_USE_OVERRIDE) $(PRODUCT_OUT_FROM_TOP)/$(BOLT_IMG_TO_USE_OVERRIDE).vb || :
	cp -pv $(B_BOLT_VB_OBJ_ROOT)/external_bfw*_avs_memsys.bin $(PRODUCT_OUT_FROM_TOP)/ || :
	@echo "'$@' completed"

.PHONY: clean_android_bsu
clean_android_bsu:
	rm -f $(PRODUCT_OUT_FROM_TOP)/android_bsu.elf

.PHONY: clean_android_bsu_vb
clean_android_bsu_vb:
	rm -f $(PRODUCT_OUT_FROM_TOP)/android_bsu-vb.elf

.PHONY: build_android_bsu
build_android_bsu: build_bolt gptbin
	@echo "'$@' started"
	cp -pv $(PRODUCT_OUT_FROM_TOP)/gpt.bin.gen.c $(B_BOLT_OBJ_ROOT)/gpt.bin.gen.c
	PATH=${B_KNB_TOOLCHAIN}:$$PATH $(MAKE) -C $(ANDROID_BSU_DIR) $(BCHP_CHIP)$(BCHP_VER_BOLT) ODIR=$(B_BOLT_OBJ_ROOT) GEN=$(B_BOLT_OBJ_ROOT)
	cp -pv $(B_BOLT_OBJ_ROOT)/android_bsu.elf $(PRODUCT_OUT_FROM_TOP)/android_bsu.elf || :
	@echo "'$@' completed"

.PHONY: build_android_bsu_vb
build_android_bsu_vb: build_bolt_vb gptbin
	@echo "'$@' started"
	cp -pv $(PRODUCT_OUT_FROM_TOP)/gpt.bin.gen.c $(B_BOLT_VB_OBJ_ROOT)/gpt.bin.gen.c
	PATH=${B_KNB_TOOLCHAIN}:$$PATH $(MAKE) -C $(ANDROID_BSU_DIR_VB) $(BCHP_CHIP)$(BCHP_VER_BOLT) SECURE_BOOT=y SINGLE_BOARD=$(BOLT_BOARD_VB) ODIR=$(B_BOLT_VB_OBJ_ROOT) GEN=$(B_BOLT_VB_OBJ_ROOT)
	cp -pv $(B_BOLT_VB_OBJ_ROOT)/android_bsu.elf $(PRODUCT_OUT_FROM_TOP)/android_bsu-vb.elf || :
	@echo "'$@' completed"

.PHONY: build_bootloaderimg
ifeq ($(HW_TZ_SUPPORT),y)
build_bootloaderimg: build_android_bsu build_bl31
	@echo "'$@' started"
	cp $(PRODUCT_OUT_FROM_TOP)/$(BOLT_IMG_TO_USE_OVERRIDE) $(PRODUCT_OUT_FROM_TOP)/orig.$(BOLT_IMG_TO_USE_OVERRIDE)
	@if [ "${BOLT_IMG_TO_USE_OVERRIDE_2ND}" != "" ]; then \
		cp $(PRODUCT_OUT_FROM_TOP)/$(BOLT_IMG_TO_USE_OVERRIDE_2ND) $(PRODUCT_OUT_FROM_TOP)/orig.$(BOLT_IMG_TO_USE_OVERRIDE_2ND); \
	fi
	@if [ "${LOCAL_DEVICE_SAGE_DEV_N_PROD}" == "y" ]; then \
		$(ANDROID_BSU_DIR)/scripts/bootloaderimg.py $(PRODUCT_OUT_FROM_TOP)/$(BOLT_IMG_TO_USE_OVERRIDE) $(PRODUCT_OUT_FROM_TOP)/android_bsu.elf $(PRODUCT_OUT_FROM_TOP)/bl31.bin $(PRODUCT_OUT_FROM_TOP)/bootloader.dev.img; \
		cp $(PRODUCT_OUT_FROM_TOP)/$(BOLT_IMG_TO_USE_OVERRIDE) $(PRODUCT_OUT_FROM_TOP)/alt.$(BOLT_IMG_TO_USE_OVERRIDE); \
		if [ -e "${BOLT_IMG_SWAP_BBL}" ]; then \
			$(PRODUCT_OUT_FROM_TOP)/obj/FAKE/bolt/scripts/patcher.pl -p ${BOLT_IMG_SWAP_BBL} -i $(PRODUCT_OUT_FROM_TOP)/alt.$(BOLT_IMG_TO_USE_OVERRIDE) -o $(PRODUCT_OUT_FROM_TOP)/swap.bbl.$(BOLT_IMG_TO_USE_OVERRIDE) -z $(BOLT_ZEUS_VER) -t bbl; \
			cp $(PRODUCT_OUT_FROM_TOP)/swap.bbl.$(BOLT_IMG_TO_USE_OVERRIDE) $(PRODUCT_OUT_FROM_TOP)/alt.$(BOLT_IMG_TO_USE_OVERRIDE); \
		fi; \
		if [ -e "${BOLT_IMG_SWAP_BFW}" ]; then \
			$(PRODUCT_OUT_FROM_TOP)/obj/FAKE/bolt/scripts/patcher.pl -p ${BOLT_IMG_SWAP_BFW} -i $(PRODUCT_OUT_FROM_TOP)/alt.$(BOLT_IMG_TO_USE_OVERRIDE) -o $(PRODUCT_OUT_FROM_TOP)/swap.bfw.$(BOLT_IMG_TO_USE_OVERRIDE) -z $(BOLT_ZEUS_VER) -t bfw; \
			cp $(PRODUCT_OUT_FROM_TOP)/swap.bfw.$(BOLT_IMG_TO_USE_OVERRIDE) $(PRODUCT_OUT_FROM_TOP)/alt.$(BOLT_IMG_TO_USE_OVERRIDE); \
		fi; \
		if [ -e "${BOLT_IMG_SWAP_RD}" ]; then \
			$(PRODUCT_OUT_FROM_TOP)/obj/FAKE/bolt/scripts/patcher.pl -p ${BOLT_IMG_SWAP_RD} -i $(PRODUCT_OUT_FROM_TOP)/alt.$(BOLT_IMG_TO_USE_OVERRIDE) -o $(PRODUCT_OUT_FROM_TOP)/swap.rd.$(BOLT_IMG_TO_USE_OVERRIDE) -z $(BOLT_ZEUS_VER) -t reserveddata; \
			cp $(PRODUCT_OUT_FROM_TOP)/swap.rd.$(BOLT_IMG_TO_USE_OVERRIDE) $(PRODUCT_OUT_FROM_TOP)/alt.$(BOLT_IMG_TO_USE_OVERRIDE); \
		fi; \
		$(ANDROID_BSU_DIR)/scripts/bootloaderimg.py $(PRODUCT_OUT_FROM_TOP)/alt.$(BOLT_IMG_TO_USE_OVERRIDE) $(PRODUCT_OUT_FROM_TOP)/android_bsu.elf $(PRODUCT_OUT_FROM_TOP)/bl31.bin $(PRODUCT_OUT_FROM_TOP)/bootloader.prod.img; \
		rm $(PRODUCT_OUT_FROM_TOP)/alt.$(BOLT_IMG_TO_USE_OVERRIDE); \
	else \
		$(ANDROID_BSU_DIR)/scripts/bootloaderimg.py $(PRODUCT_OUT_FROM_TOP)/$(BOLT_IMG_TO_USE_OVERRIDE) $(PRODUCT_OUT_FROM_TOP)/android_bsu.elf $(PRODUCT_OUT_FROM_TOP)/bl31.bin $(PRODUCT_OUT_FROM_TOP)/bootloader.img; \
		if [ "${BOLT_IMG_TO_USE_OVERRIDE_2ND}" != "" ]; then \
			$(ANDROID_BSU_DIR)/scripts/bootloaderimg.py $(PRODUCT_OUT_FROM_TOP)/$(BOLT_IMG_TO_USE_OVERRIDE_2ND) $(PRODUCT_OUT_FROM_TOP)/android_bsu.elf $(PRODUCT_OUT_FROM_TOP)/bl31.bin $(PRODUCT_OUT_FROM_TOP)/bootloader.2nd.img; \
		fi; \
	fi
	@echo "'$@' completed"
else
build_bootloaderimg: build_android_bsu
	@echo "'$@' started"
	cp $(PRODUCT_OUT_FROM_TOP)/$(BOLT_IMG_TO_USE_OVERRIDE) $(PRODUCT_OUT_FROM_TOP)/orig.$(BOLT_IMG_TO_USE_OVERRIDE)
	@if [ "${BOLT_IMG_TO_USE_OVERRIDE_2ND}" != "" ]; then \
		cp $(PRODUCT_OUT_FROM_TOP)/$(BOLT_IMG_TO_USE_OVERRIDE_2ND) $(PRODUCT_OUT_FROM_TOP)/orig.$(BOLT_IMG_TO_USE_OVERRIDE_2ND); \
	fi
	@if [ "${LOCAL_DEVICE_SAGE_DEV_N_PROD}" == "y" ]; then \
		$(ANDROID_BSU_DIR)/scripts/bootloaderimg.py $(PRODUCT_OUT_FROM_TOP)/$(BOLT_IMG_TO_USE_OVERRIDE) $(PRODUCT_OUT_FROM_TOP)/android_bsu.elf $(PRODUCT_OUT_FROM_TOP)/bootloader.dev.img; \
		cp $(PRODUCT_OUT_FROM_TOP)/$(BOLT_IMG_TO_USE_OVERRIDE) $(PRODUCT_OUT_FROM_TOP)/alt.$(BOLT_IMG_TO_USE_OVERRIDE); \
		if [ -e "${BOLT_IMG_SWAP_BBL}" ]; then \
			$(PRODUCT_OUT_FROM_TOP)/obj/FAKE/bolt/scripts/patcher.pl -p ${BOLT_IMG_SWAP_BBL} -i $(PRODUCT_OUT_FROM_TOP)/alt.$(BOLT_IMG_TO_USE_OVERRIDE) -o $(PRODUCT_OUT_FROM_TOP)/swap.bbl.$(BOLT_IMG_TO_USE_OVERRIDE) -z $(BOLT_ZEUS_VER) -t bbl; \
			cp $(PRODUCT_OUT_FROM_TOP)/swap.bbl.$(BOLT_IMG_TO_USE_OVERRIDE) $(PRODUCT_OUT_FROM_TOP)/alt.$(BOLT_IMG_TO_USE_OVERRIDE); \
		fi; \
		if [ -e "${BOLT_IMG_SWAP_BFW}" ]; then \
			$(PRODUCT_OUT_FROM_TOP)/obj/FAKE/bolt/scripts/patcher.pl -p ${BOLT_IMG_SWAP_BFW} -i $(PRODUCT_OUT_FROM_TOP)/alt.$(BOLT_IMG_TO_USE_OVERRIDE) -o $(PRODUCT_OUT_FROM_TOP)/swap.bfw.$(BOLT_IMG_TO_USE_OVERRIDE) -z $(BOLT_ZEUS_VER) -t bfw; \
			cp $(PRODUCT_OUT_FROM_TOP)/swap.bfw.$(BOLT_IMG_TO_USE_OVERRIDE) $(PRODUCT_OUT_FROM_TOP)/alt.$(BOLT_IMG_TO_USE_OVERRIDE); \
		fi; \
		if [ -e "${BOLT_IMG_SWAP_RD}" ]; then \
			$(PRODUCT_OUT_FROM_TOP)/obj/FAKE/bolt/scripts/patcher.pl -p ${BOLT_IMG_SWAP_RD} -i $(PRODUCT_OUT_FROM_TOP)/alt.$(BOLT_IMG_TO_USE_OVERRIDE) -o $(PRODUCT_OUT_FROM_TOP)/swap.rd.$(BOLT_IMG_TO_USE_OVERRIDE) -z $(BOLT_ZEUS_VER) -t reserveddata; \
			cp $(PRODUCT_OUT_FROM_TOP)/swap.rd.$(BOLT_IMG_TO_USE_OVERRIDE) $(PRODUCT_OUT_FROM_TOP)/alt.$(BOLT_IMG_TO_USE_OVERRIDE); \
		fi; \
		$(ANDROID_BSU_DIR)/scripts/bootloaderimg.py $(PRODUCT_OUT_FROM_TOP)/alt.$(BOLT_IMG_TO_USE_OVERRIDE) $(PRODUCT_OUT_FROM_TOP)/android_bsu.elf $(PRODUCT_OUT_FROM_TOP)/bootloader.prod.img; \
		rm $(PRODUCT_OUT_FROM_TOP)/alt.$(BOLT_IMG_TO_USE_OVERRIDE); \
	else \
		$(ANDROID_BSU_DIR)/scripts/bootloaderimg.py $(PRODUCT_OUT_FROM_TOP)/$(BOLT_IMG_TO_USE_OVERRIDE) $(PRODUCT_OUT_FROM_TOP)/android_bsu.elf $(PRODUCT_OUT_FROM_TOP)/bootloader.img; \
		if [ "${BOLT_IMG_TO_USE_OVERRIDE_2ND}" != "" ]; then \
			$(ANDROID_BSU_DIR)/scripts/bootloaderimg.py $(PRODUCT_OUT_FROM_TOP)/$(BOLT_IMG_TO_USE_OVERRIDE_2ND) $(PRODUCT_OUT_FROM_TOP)/android_bsu.elf $(PRODUCT_OUT_FROM_TOP)/bootloader.2nd.img; \
		fi; \
	fi
	@echo "'$@' completed"
endif

.PHONY: build_bootloaderimg_vb
build_bootloaderimg_vb: build_android_bsu_vb
	@echo "'$@' started"
	@if [[ -e "${BRCMSTB_ANDROID_VENDOR_PATH}/bcm_platform/signing/bimg/tool" && -e "${BRCMSTB_ANDROID_VENDOR_PATH}/bcm_platform/signing/bimg/$(BCHP_CHIP)" ]]; then \
		if [ "${LOCAL_DEVICE_SAGE_DEV_N_PROD}" == "y" ]; then \
			LD_LIBRARY_PATH=${BRCMSTB_ANDROID_VENDOR_PATH}/bcm_platform/signing/bimg/tool ${BRCMSTB_ANDROID_VENDOR_PATH}/bcm_platform/signing/bimg/tool/imagetool -L bolt -P Generic -O ${BRCMSTB_ANDROID_VENDOR_PATH}/bcm_platform/signing/bimg/$(BCHP_CHIP)/bolt.dev.cfg; \
			LD_LIBRARY_PATH=${BRCMSTB_ANDROID_VENDOR_PATH}/bcm_platform/signing/bimg/tool ${BRCMSTB_ANDROID_VENDOR_PATH}/bcm_platform/signing/bimg/tool/imagetool -L kernel -P Generic -O ${BRCMSTB_ANDROID_VENDOR_PATH}/bcm_platform/signing/bimg/$(BCHP_CHIP)/bsu.dev.cfg; \
			$(ANDROID_BSU_DIR)/scripts/bootloaderimg.py $(PRODUCT_OUT_FROM_TOP)/bolt-vb.dev.signed.bin $(PRODUCT_OUT_FROM_TOP)/android_bsu-vb.dev.signed.elf $(PRODUCT_OUT_FROM_TOP)/bootloader.vb.signed.dev.img; \
			cp $(PRODUCT_OUT_FROM_TOP)/$(BOLT_IMG_TO_USE_OVERRIDE).vb $(PRODUCT_OUT_FROM_TOP)/alt.$(BOLT_IMG_TO_USE_OVERRIDE).vb; \
			if [ -e "${BOLT_IMG_SWAP_BBL}" ]; then \
				$(PRODUCT_OUT_FROM_TOP)/obj/FAKE/bolt/scripts/patcher.pl -p ${BOLT_IMG_SWAP_BBL} -i $(PRODUCT_OUT_FROM_TOP)/alt.$(BOLT_IMG_TO_USE_OVERRIDE).vb -o $(PRODUCT_OUT_FROM_TOP)/swap.bbl.$(BOLT_IMG_TO_USE_OVERRIDE).vb -z $(BOLT_ZEUS_VER) -t bbl; \
				cp $(PRODUCT_OUT_FROM_TOP)/swap.bbl.$(BOLT_IMG_TO_USE_OVERRIDE).vb $(PRODUCT_OUT_FROM_TOP)/alt.$(BOLT_IMG_TO_USE_OVERRIDE).vb; \
			fi; \
			if [ -e "${BOLT_IMG_SWAP_BFW}" ]; then \
				$(PRODUCT_OUT_FROM_TOP)/obj/FAKE/bolt/scripts/patcher.pl -p ${BOLT_IMG_SWAP_BFW} -i $(PRODUCT_OUT_FROM_TOP)/alt.$(BOLT_IMG_TO_USE_OVERRIDE).vb -o $(PRODUCT_OUT_FROM_TOP)/swap.bfw.$(BOLT_IMG_TO_USE_OVERRIDE).vb -z $(BOLT_ZEUS_VER) -t bfw; \
				cp $(PRODUCT_OUT_FROM_TOP)/swap.bfw.$(BOLT_IMG_TO_USE_OVERRIDE).vb $(PRODUCT_OUT_FROM_TOP)/alt.$(BOLT_IMG_TO_USE_OVERRIDE).vb; \
			fi; \
			if [ -e "${BOLT_IMG_SWAP_RD}" ]; then \
				$(PRODUCT_OUT_FROM_TOP)/obj/FAKE/bolt/scripts/patcher.pl -p ${BOLT_IMG_SWAP_RD} -i $(PRODUCT_OUT_FROM_TOP)/alt.$(BOLT_IMG_TO_USE_OVERRIDE).vb -o $(PRODUCT_OUT_FROM_TOP)/swap.rd.$(BOLT_IMG_TO_USE_OVERRIDE).vb -z $(BOLT_ZEUS_VER) -t reserveddata; \
				cp $(PRODUCT_OUT_FROM_TOP)/swap.rd.$(BOLT_IMG_TO_USE_OVERRIDE).vb $(PRODUCT_OUT_FROM_TOP)/alt.$(BOLT_IMG_TO_USE_OVERRIDE).vb; \
			fi; \
			LD_LIBRARY_PATH=${BRCMSTB_ANDROID_VENDOR_PATH}/bcm_platform/signing/bimg/tool ${BRCMSTB_ANDROID_VENDOR_PATH}/bcm_platform/signing/bimg/tool/imagetool -L bolt -P Generic -O ${BRCMSTB_ANDROID_VENDOR_PATH}/bcm_platform/signing/bimg/$(BCHP_CHIP)/bolt.prod.cfg; \
			LD_LIBRARY_PATH=${BRCMSTB_ANDROID_VENDOR_PATH}/bcm_platform/signing/bimg/tool ${BRCMSTB_ANDROID_VENDOR_PATH}/bcm_platform/signing/bimg/tool/imagetool -L kernel -P Generic -O ${BRCMSTB_ANDROID_VENDOR_PATH}/bcm_platform/signing/bimg/$(BCHP_CHIP)/bsu.prod.cfg; \
			$(ANDROID_BSU_DIR)/scripts/bootloaderimg.py $(PRODUCT_OUT_FROM_TOP)/bolt-vb.prod.signed.bin $(PRODUCT_OUT_FROM_TOP)/android_bsu-vb.prod.signed.elf $(PRODUCT_OUT_FROM_TOP)/bootloader.vb.signed.prod.img; \
			rm $(PRODUCT_OUT_FROM_TOP)/alt.$(BOLT_IMG_TO_USE_OVERRIDE).vb; \
		else \
			LD_LIBRARY_PATH=${BRCMSTB_ANDROID_VENDOR_PATH}/bcm_platform/signing/bimg/tool ${BRCMSTB_ANDROID_VENDOR_PATH}/bcm_platform/signing/bimg/tool/imagetool -L bolt -P Generic -O ${BRCMSTB_ANDROID_VENDOR_PATH}/bcm_platform/signing/bimg/$(BCHP_CHIP)/bolt.cfg; \
			LD_LIBRARY_PATH=${BRCMSTB_ANDROID_VENDOR_PATH}/bcm_platform/signing/bimg/tool ${BRCMSTB_ANDROID_VENDOR_PATH}/bcm_platform/signing/bimg/tool/imagetool -L kernel -P Generic -O ${BRCMSTB_ANDROID_VENDOR_PATH}/bcm_platform/signing/bimg/$(BCHP_CHIP)/bsu.cfg; \
			$(ANDROID_BSU_DIR)/scripts/bootloaderimg.py $(PRODUCT_OUT_FROM_TOP)/bolt-vb.signed.bin $(PRODUCT_OUT_FROM_TOP)/android_bsu-vb.signed.elf $(PRODUCT_OUT_FROM_TOP)/bootloader.vb.signed.img; \
		fi; \
	else \
		echo "Missing signing tool: ${BRCMSTB_ANDROID_VENDOR_PATH}/bcm_platform/signing/bimg/tool; or signing package for device: ${BRCMSTB_ANDROID_VENDOR_PATH}/bcm_platform/signing/bimg/$(BCHP_CHIP)"; \
	fi
	@echo "'$@' completed"

.PHONY: clean_bootloaderimg
clean_bootloaderimg: clean_bolt clean_android_bsu clean_bl31
	rm -f $(PRODUCT_OUT_FROM_TOP)/bootloader.img

.PHONY: clean_bootloaderimg_vb
clean_bootloaderimg_vb: clean_bolt_vb clean_android_bsu_vb
	rm -f $(PRODUCT_OUT_FROM_TOP)/bootloader.vb.signed.img
else
.PHONY: clean_bootloaderimg
clean_bootloaderimg:
	@echo "'$@' no-op using bins"

.PHONY: build_bootloaderimg
build_bootloaderimg:

# This would be much simpler with copy-many-files, but this file is loaded too early for some reason.
define copy-bootloader
ifneq ($(wildcard $(BCM_BINDIST_BL_ROOT)/$(1)),)
build_bootloaderimg: $(PRODUCT_OUT)/$(1)
$(PRODUCT_OUT)/$(1): $(BCM_BINDIST_BL_ROOT)/$(1)
	cp $$< $$@
endif
endef

ifeq ($(LOCAL_DEVICE_SAGE_DEV_N_PROD),y)
$(eval $(call copy-bootloader,bootloader.dev.img))
$(eval $(call copy-bootloader,bootloader.prod.img))
else
$(eval $(call copy-bootloader,bootloader.img))
endif
endif

.PHONY: build_lk
ifneq ($(LKROOT),)
build_lk:
	@echo "'$@' started"
	@if [ ! -d "${B_LK_OBJ_ROOT}" ]; then \
		mkdir -p ${B_LK_OBJ_ROOT}; \
	fi
	PATH=${B_KNB_TOOLCHAIN}:$$PATH $(MAKE) -f ${LKROOT}/makefile BUILDROOT=${B_LK_OBJ_ROOT} ${LOCAL_LK_DEVICE}
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
	PATH=${B_KNB_TOOLCHAIN}:$$PATH CROSS_COMPILE=aarch64-linux-gnu- $(MAKE) -f Makefile PLAT=${LOCAL_BL31_DEVICE} SPD=trusty bl31
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

.PHONY: build_dtboimg
ifeq ($(LOCAL_DTBO_SUPPORT),y)
build_dtboimg: mkdtimg $(PRODUCT_OUT)/bcm.dtb
	out/host/$(HOST_OS)-$(HOST_PREBUILT_ARCH)/bin/mkdtimg create $(PRODUCT_OUT)/dtbo.img $(PRODUCT_OUT)/bcm.dtb;
else
build_dtboimg:
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

.PHONY: clean_recovery_ramdisk
clean_recovery_ramdisk :
	@echo "'$@' started"
	rm -rf ${BRCMSTB_ANDROID_OUT_PATH}/target/product/${LOCAL_PRODUCT_OUT}/root/system/*
	rm -rf ${BRCMSTB_ANDROID_OUT_PATH}/target/product/${LOCAL_PRODUCT_OUT}/root/vendor/*
	rm -rf ${BRCMSTB_ANDROID_OUT_PATH}/target/product/${LOCAL_PRODUCT_OUT}/root/sbin/nxmini
	@echo "'$@' completed"

export URSR_TOP := ${REFSW_BASE_DIR}
export COMMON_DRM_TOP := $(URSR_TOP)/BSEAV/lib/security/common_drm
export PLAYREADY_ROOT := $(REFSW_BASE_DIR)/prsrcs/2.5/
export PLAYREADY_DIR := $(PLAYREADY_ROOT)/source/linux
export _NTROOT=${PLAYREADY_ROOT}
export PRDY_TOP := $(REFSW_BASE_DIR)/prsrcs
export PLAYREADY_HOST_BUILD := y

.PHONY: clean_security_user
clean_security_user :
	$(MAKE) -C $(REFSW_BASE_DIR)/prsrcs/2.5/source clean
	$(MAKE) -C $(REFSW_BASE_DIR)/prsrcs/3.0/source clean

# build all the needed libs, then check them into the source tree as 'prebuilts'.
#
.PHONY: security_user
security_user:
	$(call setup_nexus_toolchains,1st_arch)
	@echo "'$@' started"
	$(MAKE) $(NEXUS_ARCH_ENV) -C $(REFSW_BASE_DIR)/prsrcs/2.5/source all
	$(MAKE) $(NEXUS_ARCH_ENV) -C $(REFSW_BASE_DIR)/prsrcs/3.0/source all
	$(MAKE) -C $(REFSW_BASE_DIR)/prsrcs/3.0/source/linux/libraries clean
	$(MAKE) $(NEXUS_ARCH_ENV) -C $(REFSW_BASE_DIR)/prsrcs/3.0/source/linux/libraries all
	@echo "'$@' completed"

.PHONY: security_user_2nd_arch
ifeq ($(TARGET_2ND_ARCH),arm)
security_user_2nd_arch:
	$(call setup_nexus_toolchains,2nd_arch)
	@echo "'$@' started"
	$(MAKE) $(NEXUS_2ND_ARCH_ENV) -C $(REFSW_BASE_DIR)/prsrcs/2.5/source all
	$(MAKE) $(NEXUS_2ND_ARCH_ENV) -C $(REFSW_BASE_DIR)/secsrcs/third_party/android/drm/widevine/OEMCrypto
	$(MAKE) $(NEXUS_2ND_ARCH_ENV) -C $(REFSW_BASE_DIR)/prsrcs/3.0/source all
	$(MAKE) $(NEXUS_2ND_ARCH_ENV) -C $(REFSW_BASE_DIR)/prsrcs/3.0/source/linux/libraries clean
	$(MAKE) $(NEXUS_2ND_ARCH_ENV) -C $(REFSW_BASE_DIR)/prsrcs/3.0/source/linux/libraries all
	@echo "'$@' completed"
else
security_user_2nd_arch:
	@echo "'$@' no-op"
endif

ifeq ($(ANDROID_SUPPORTS_DTVKIT),y)
include device/broadcom/common/middleware/dtvkit.mk
endif
