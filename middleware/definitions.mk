ifneq ($(REFSW_DEFS_EXPORTED),y)

ifneq ($(LOCAL_PRODUCT_OUT),)
# filter out invalid constructs.
LOCAL_PRODUCT_OUT          := $(notdir $(LOCAL_PRODUCT_OUT))
endif

export BRCMSTB_ANDROID_VENDOR_PATH     := ${ANDROID_TOP}/${BCM_VENDOR_STB_ROOT}
export BRCMSTB_ANDROID_DRIVER_PATH     := ${BRCMSTB_ANDROID_VENDOR_PATH}/drivers

leading_slash = $(filter found, $(firstword $(subst /, ,found$(1))))

ifeq ($(OUT_DIR_COMMON_BASE),)
ifeq (${OUT_DIR},)
OUT_DIR := out
endif
ifeq ($(call leading_slash,${OUT_DIR}), found)
BRCMSTB_ANDROID_OUT_PATH     := ${OUT_DIR}
else
BRCMSTB_ANDROID_OUT_PATH     := ${ANDROID_TOP}/${OUT_DIR}
endif
else
BRCMSTB_ANDROID_OUT_PATH     := ${OUT_DIR_COMMON_BASE}/$(notdir $(PWD))
endif

ifeq ($(PRODUCT_OUT),)
ifeq ($(OUT_DIR_COMMON_BASE),)
export PRODUCT_OUT           := ${OUT_DIR}/target/product/${LOCAL_PRODUCT_OUT}
else
export PRODUCT_OUT           := ${OUT_DIR_COMMON_BASE}/$(notdir $(PWD))/target/product/${LOCAL_PRODUCT_OUT}
endif
endif

ifeq ($(OUT_DIR_COMMON_BASE),)
ifeq ($(call leading_slash,${OUT_DIR}), found)
export PRODUCT_OUT_FROM_TOP  := ${PRODUCT_OUT}
export ANDROID_OUT_DIR       := ${OUT_DIR}
else
export PRODUCT_OUT_FROM_TOP  := ${ANDROID_TOP}/${PRODUCT_OUT}
export ANDROID_OUT_DIR       := ${ANDROID_TOP}/${OUT_DIR}
endif
else
export PRODUCT_OUT_FROM_TOP  := ${PRODUCT_OUT}
export ANDROID_OUT_DIR       := ${OUT_DIR_COMMON_BASE}/$(notdir $(PWD))
endif

export LINUX_OUT_ROOT        := ${ANDROID_OUT_DIR}/target/product/${LOCAL_PRODUCT_OUT}/obj/FAKE/kernel
export LINUX_OUT_1ST_ARCH    := ${LINUX_OUT_ROOT}/1st
export LINUX_OUT_2ND_ARCH    := ${LINUX_OUT_ROOT}/2nd
export LINUX_OUT

NEXUS_TOP                    := ${REFSW_BASE_DIR}/nexus
MAGNUM_TOP                   := ${REFSW_BASE_DIR}/magnum
ROCKFORD_TOP                 := ${REFSW_BASE_DIR}/rockford
BSEAV_TOP                    := ${REFSW_BASE_DIR}/BSEAV
B_REFSW_TOOLCHAINS_INSTALL   := ${BRCMSTB_ANDROID_OUT_PATH}/target/product/${LOCAL_PRODUCT_OUT}/obj/FAKE/refsw/toolchains/
B_REFSW_OBJ_ROOT_1ST_ARCH    := ${BRCMSTB_ANDROID_OUT_PATH}/target/product/${LOCAL_PRODUCT_OUT}/obj/FAKE/refsw/obj.$(NEXUS_PLATFORM)
B_REFSW_OBJ_ROOT_2ND_ARCH    := ${BRCMSTB_ANDROID_OUT_PATH}/target/product/${LOCAL_PRODUCT_OUT}/obj/FAKE/refsw/obj_2nd.$(NEXUS_PLATFORM)
B_BOLT_OBJ_ROOT              := ${BRCMSTB_ANDROID_OUT_PATH}/target/product/${LOCAL_PRODUCT_OUT}/obj/FAKE/bolt
B_BOLT_VB_OBJ_ROOT           := ${BRCMSTB_ANDROID_OUT_PATH}/target/product/${LOCAL_PRODUCT_OUT}/obj/FAKE/bolt-vb
B_DHD_OBJ_ROOT               := ${BRCMSTB_ANDROID_OUT_PATH}/target/product/${LOCAL_PRODUCT_OUT}/obj/FAKE/dhd
B_NIC_OBJ_ROOT               := ${BRCMSTB_ANDROID_OUT_PATH}/target/product/${LOCAL_PRODUCT_OUT}/obj/FAKE/nic
B_NIC_DUAL_OBJ_ROOT          := ${BRCMSTB_ANDROID_OUT_PATH}/target/product/${LOCAL_PRODUCT_OUT}/obj/FAKE/nic-dual
B_REFSW_ANDROID_LIB_1ST_ARCH := ${BRCMSTB_ANDROID_OUT_PATH}/target/product/${LOCAL_PRODUCT_OUT}/obj/lib
B_REFSW_ANDROID_LIB_2ND_ARCH := ${BRCMSTB_ANDROID_OUT_PATH}/target/product/${LOCAL_PRODUCT_OUT}/obj_arm/lib
NEXUS_BIN_DIR_1ST_ARCH       := $(B_REFSW_OBJ_ROOT_1ST_ARCH)/nexus/bin
NEXUS_NXC_BIN_DIR_1ST_ARCH   := $(B_REFSW_OBJ_ROOT_1ST_ARCH)/nexus/nxclient/${B_REFSW_ARCH_1ST_ARCH}/server
NEXUS_BIN_DIR_2ND_ARCH       := $(B_REFSW_OBJ_ROOT_2ND_ARCH)/nexus/bin
NEXUS_NXC_BIN_DIR_2ND_ARCH   := $(B_REFSW_OBJ_ROOT_2ND_ARCH)/nexus/nxclient/${B_REFSW_ARCH_2ND_ARCH}/server
B_LK_OBJ_ROOT                := ${BRCMSTB_ANDROID_OUT_PATH}/target/product/${LOCAL_PRODUCT_OUT}/obj/FAKE/lk
B_BL31_OBJ_ROOT              := ${BRCMSTB_ANDROID_OUT_PATH}/target/product/${LOCAL_PRODUCT_OUT}/obj/FAKE/bl31

B_BOLT_CFG_OVERRIDE          ?=
B_BOLT_CUSTOM_OVERRIDE       ?=

# local modules override for android integration of nexus functionalities.
NEXUS_HAS_SOCKET_DRIVER      := y
ifneq ($(NEXUS_HAS_SOCKET_DRIVER),y)
NXCLIENT_SOCKET_INTF         := ${ANDROID}/${BCM_VENDOR_STB_ROOT}/bcm_platform/nxif/nxsocket/nxclient_android_socket.c
export NXCLIENT_SOCKET_INTF
endif
NEXUS_PLATFORM_PROXY_INTF    := ${ANDROID}/${BCM_VENDOR_STB_ROOT}/bcm_platform/nxif/nxproxyif/nexus_platform_proxy_intf.c
NEXUS_SAGE_BP3_BIN_PATH      := ${ANDROID}/${BCM_VENDOR_STB_ROOT}/bcm_platform/nxif/nxsagebp3/nexus_sage_bp3_bin_path.c

BINDIST_BIN_DIR_1ST_ARCH       := ${ANDROID}/${BCM_BINDIST_LIBS_ROOT}
BINDIST_NXC_BIN_DIR_1ST_ARCH   := ${ANDROID}/${BCM_BINDIST_LIBS_ROOT}

export B_REFSW_TOOLCHAINS_INSTALL
export B_REFSW_CROSS_COMPILE := ${B_REFSW_TOOLCHAINS_INSTALL}
export NEXUS_TOP
export MAGNUM_TOP
export ROCKFORD_TOP
export BSEAV_TOP
export B_REFSW_OBJ_ROOT_1ST_ARCH B_REFSW_OBJ_ROOT_2ND_ARCH
export NEXUS_BIN_DIR_1ST_ARCH NEXUS_BIN_DIR_2ND_ARCH
export NEXUS_NXC_BIN_DIR_1ST_ARCH NEXUS_NXC_BIN_DIR_2ND_ARCH
export B_BOLT_OBJ_ROOT B_BOLT_VB_OBJ_ROOT
export B_DHD_OBJ_ROOT
export B_NIC_OBJ_ROOT
export B_NIC_DUAL_OBJ_ROOT
export B_REFSW_ANDROID_LIB_1ST_ARCH B_REFSW_ANDROID_LIB_2ND_ARCH
export NEXUS_PLATFORM_PROXY_INTF
export B_LK_OBJ_ROOT
export B_BL31_OBJ_ROOT
export B_BOLT_CFG_OVERRIDE B_BOLT_CUSTOM_OVERRIDE
export BINDIST_BIN_DIR_1ST_ARCH BINDIST_NXC_BIN_DIR_1ST_ARCH
export NEXUS_HAS_SOCKET_DRIVER
export NEXUS_SAGE_BP3_BIN_PATH

include ${NEXUS_TOP}/platforms/common/build/nexus_platforms.inc
export BCHP_CHIP

REFSW_DEFS_EXPORTED := y
export REFSW_DEFS_EXPORTED

endif
