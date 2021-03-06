ifneq ($(REFSW_DEFS_EXPORTED),y)

export PATH                  := ${ANDROID}/vendor/broadcom/prebuilts/stbgcc-4.8-1.6/bin:${PATH}

ifneq ($(ANDROID_PRODUCT_OUT),)
# filter out invalid constructs.
ANDROID_PRODUCT_OUT          := $(notdir $(ANDROID_PRODUCT_OUT))
endif

export BRCMSTB_ANDROID_VENDOR_PATH     := ${ANDROID_TOP}/${BCM_VENDOR_STB_ROOT}
export BRCMSTB_ANDROID_DRIVER_PATH     := ${BRCMSTB_ANDROID_VENDOR_PATH}/drivers

ifeq ($(OUT_DIR_COMMON_BASE),)
BRCMSTB_ANDROID_OUT_PATH     := ${ANDROID_TOP}/out
else
BRCMSTB_ANDROID_OUT_PATH     := ${OUT_DIR_COMMON_BASE}/$(notdir $(PWD))
endif

ifeq ($(PRODUCT_OUT),)
ifeq ($(OUT_DIR_COMMON_BASE),)
export PRODUCT_OUT           := out/target/product/${ANDROID_PRODUCT_OUT}
else
export PRODUCT_OUT           := ${OUT_DIR_COMMON_BASE}/$(notdir $(PWD))/target/product/${ANDROID_PRODUCT_OUT}
endif
endif

ifeq ($(OUT_DIR_COMMON_BASE),)
export PRODUCT_OUT_FROM_TOP  := ${ANDROID_TOP}/${PRODUCT_OUT}
export ANDROID_OUT_DIR       := ${ANDROID_TOP}/out
else
export PRODUCT_OUT_FROM_TOP  := ${PRODUCT_OUT}
export ANDROID_OUT_DIR       := ${OUT_DIR_COMMON_BASE}/$(notdir $(PWD))
endif

export LINUX_OUT_ROOT        := ${ANDROID_OUT_DIR}/target/product/${ANDROID_PRODUCT_OUT}/obj/FAKE/kernel
export LINUX_OUT_1ST_ARCH    := ${LINUX_OUT_ROOT}/1st
export LINUX_OUT_2ND_ARCH    := ${LINUX_OUT_ROOT}/2nd
export LINUX_OUT

NEXUS_TOP                    := ${REFSW_BASE_DIR}/nexus
MAGNUM_TOP                   := ${REFSW_BASE_DIR}/magnum
ROCKFORD_TOP                 := ${REFSW_BASE_DIR}/rockford
BSEAV_TOP                    := ${REFSW_BASE_DIR}/BSEAV
B_REFSW_TOOLCHAINS_INSTALL   := ${BRCMSTB_ANDROID_OUT_PATH}/target/product/${ANDROID_PRODUCT_OUT}/obj/FAKE/refsw/toolchains/
B_REFSW_OBJ_ROOT_1ST_ARCH    := ${BRCMSTB_ANDROID_OUT_PATH}/target/product/${ANDROID_PRODUCT_OUT}/obj/FAKE/refsw/obj.$(NEXUS_PLATFORM)
B_REFSW_OBJ_ROOT_2ND_ARCH    := ${BRCMSTB_ANDROID_OUT_PATH}/target/product/${ANDROID_PRODUCT_OUT}/obj/FAKE/refsw/obj_2nd.$(NEXUS_PLATFORM)
B_BOLT_OBJ_ROOT              := ${BRCMSTB_ANDROID_OUT_PATH}/target/product/${ANDROID_PRODUCT_OUT}/obj/FAKE/bolt
B_BOLT_VB_OBJ_ROOT           := ${BRCMSTB_ANDROID_OUT_PATH}/target/product/${ANDROID_PRODUCT_OUT}/obj/FAKE/bolt-vb
B_DHD_OBJ_ROOT               := ${BRCMSTB_ANDROID_OUT_PATH}/target/product/${ANDROID_PRODUCT_OUT}/obj/FAKE/dhd
B_NIC_OBJ_ROOT               := ${BRCMSTB_ANDROID_OUT_PATH}/target/product/${ANDROID_PRODUCT_OUT}/obj/FAKE/nic
B_NIC_DUAL_OBJ_ROOT          := ${BRCMSTB_ANDROID_OUT_PATH}/target/product/${ANDROID_PRODUCT_OUT}/obj/FAKE/nic-dual
B_REFSW_ANDROID_LIB_1ST_ARCH := ${BRCMSTB_ANDROID_OUT_PATH}/target/product/${ANDROID_PRODUCT_OUT}/obj/lib
B_REFSW_ANDROID_LIB_2ND_ARCH := ${BRCMSTB_ANDROID_OUT_PATH}/target/product/${ANDROID_PRODUCT_OUT}/obj_arm/lib
NEXUS_BIN_DIR_1ST_ARCH       := $(B_REFSW_OBJ_ROOT_1ST_ARCH)/nexus/bin
NEXUS_BIN_DIR_2ND_ARCH       := $(B_REFSW_OBJ_ROOT_2ND_ARCH)/nexus/bin
B_LK_OBJ_ROOT                := ${BRCMSTB_ANDROID_OUT_PATH}/target/product/${ANDROID_PRODUCT_OUT}/obj/FAKE/lk
B_BL31_OBJ_ROOT              := ${BRCMSTB_ANDROID_OUT_PATH}/target/product/${ANDROID_PRODUCT_OUT}/obj/FAKE/bl31

# local modules override for android integration of nexus functionalities.
NXCLIENT_SOCKET_INTF         := ${ANDROID}/${BCM_VENDOR_STB_ROOT}/bcm_platform/nxif/nxsocket/nxclient_android_socket.c
NEXUS_PLATFORM_PROXY_INTF    := ${ANDROID}/${BCM_VENDOR_STB_ROOT}/bcm_platform/nxif/nxproxyif/nexus_platform_proxy_intf.c

export B_REFSW_TOOLCHAINS_INSTALL
export B_REFSW_CROSS_COMPILE := ${B_REFSW_TOOLCHAINS_INSTALL}
export NEXUS_TOP
export MAGNUM_TOP
export ROCKFORD_TOP
export BSEAV_TOP
export B_REFSW_OBJ_ROOT_1ST_ARCH B_REFSW_OBJ_ROOT_2ND_ARCH
export NEXUS_BIN_DIR_1ST_ARCH NEXUS_BIN_DIR_2ND_ARCH
export B_BOLT_OBJ_ROOT B_BOLT_VB_OBJ_ROOT
export B_DHD_OBJ_ROOT
export B_NIC_OBJ_ROOT
export B_NIC_DUAL_OBJ_ROOT
export B_REFSW_ANDROID_LIB_1ST_ARCH B_REFSW_ANDROID_LIB_2ND_ARCH
export NXCLIENT_SOCKET_INTF NEXUS_PLATFORM_PROXY_INTF
export B_LK_OBJ_ROOT
export B_BL31_OBJ_ROOT

include ${NEXUS_TOP}/platforms/common/build/nexus_platforms.inc
export BCHP_CHIP

REFSW_DEFS_EXPORTED := y
export REFSW_DEFS_EXPORTED

endif
