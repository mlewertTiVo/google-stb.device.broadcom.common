# define the following to force build output out of source tree.
#
#   specifies the root of the out folder location, final
#   output location will be <root>/$(notdir $(PWD)).
#
#   eg: 1) OUT_DIR_COMMON_BASE=/home/${USER}/android_build
#       2) source tree is /home/${USER}/android-X
#
#       location will be: /home/${USER}/android_build/android-X/...
#
#export OUT_DIR_COMMON_BASE=

ifeq (${LOCAL_PRODUCT_OUT},)
$(error please define LOCAL_PRODUCT_OUT)
endif
export TARGET_BOARD_PLATFORM                 := ${LOCAL_PRODUCT_OUT}

# filter rules for build inclusions based on boards supported.  when adding a new
# board to the system, you may want to add it here too.
#
export BCM_RBOARDS                           := avko% banff% cypress% dawson% elfin% fundy% grouse% hudson%
export BCM_DBOARDS                           := b4% b5% b6% b7%
export BCM_CBOARDS                           ?= fbx% c71kw% sapphire% pearl%

export BCM_VENDOR_STB_ROOT                   := vendor/broadcom

# this section defines all the cross compilation and compiler data.
#
export ANDROID                               := $(shell pwd)
export ANDROID_TOP                           := ${ANDROID}

ifeq ($(HOST_OS),darwin)
export GPERF_BCM                             := gperf
else
export GPERF_BCM                             := ${ANDROID}/device/broadcom/common/prebuilts/gperf
endif
export B_KNB_TOOLCHAIN                       := ${ANDROID}/prebuilts/gcc/linux-x86/arm/stb/stbgcc-6.3-1.3/bin
export TZ_TOOLCHAIN                          := ${ANDROID}/prebuilts/gcc/linux-x86/tzos/gcc-aarch64-tzos-musl-5.3

ifeq ($(LOCAL_ARM_AARCH64),y)
ifeq ($(LOCAL_ARM_AARCH64_NOT_ABI_COMPATIBLE),y)
export B_REFSW_ARCH_1ST_ARCH                 := arm-linux
export B_REFSW_TOOLCHAIN_ARCH_1ST_ARCH       := arm-linux
export B_REFSW_CROSS_COMPILE_PATH_1ST_ARCH   := ${ANDROID_TOP}/prebuilts/gcc/linux-x86/arm/arm-linux-androideabi-4.9/bin
export P_REFSW_CC                            := ${B_REFSW_CROSS_COMPILE_PATH_1ST_ARCH}/arm-linux-androideabi-
export B_REFSW_PREBUILT_LIBGCC_1ST_ARCH      := prebuilts/gcc/linux-x86/arm/arm-linux-androideabi-4.9/lib/gcc/arm-linux-androideabi/4.9.x/libgcc.a
ifeq ($(LOCAL_ARM_AARCH64_COMPAT_32_BIT),y)
export B_REFSW_KERNEL_ARCH_1ST_ARCH          := aarch64-linux
export B_REFSW_KERNEL_CROSS_COMPILE_1ST_ARCH := aarch64-linux-
export P_REFSW_DRV_ARCH                      := arm64
else
export B_REFSW_KERNEL_ARCH_1ST_ARCH          := arm-linux
export B_REFSW_KERNEL_CROSS_COMPILE_1ST_ARCH := arm-linux-
export P_REFSW_DRV_ARCH                      := arm
endif
else
export B_REFSW_ARCH_1ST_ARCH                 := aarch64-linux
export B_REFSW_TOOLCHAIN_ARCH_1ST_ARCH       := aarch64-linux
export B_REFSW_CROSS_COMPILE_PATH_1ST_ARCH   := ${ANDROID_TOP}/prebuilts/gcc/linux-x86/aarch64/aarch64-linux-android-4.9/bin
export B_REFSW_PREBUILT_LIBGCC_1ST_ARCH      := prebuilts/gcc/linux-x86/aarch64/aarch64-linux-android-4.9/lib/gcc/aarch64-linux-android/4.9.x/libgcc.a
export P_REFSW_CC                            := ${B_REFSW_CROSS_COMPILE_PATH_1ST_ARCH}/aarch64-linux-android-
export B_REFSW_ARCH_2ND_ARCH                 := arm-linux
export B_REFSW_KERNEL_CROSS_COMPILE_2ND_ARCH := arm-linux-
export B_REFSW_TOOLCHAIN_ARCH_2ND_ARCH       := arm-linux
export B_REFSW_PREBUILT_LIBGCC_2ND_ARCH      := prebuilts/gcc/linux-x86/arm/arm-linux-androideabi-4.9/lib/gcc/arm-linux-androideabi/4.9.x/libgcc.a
export B_REFSW_CROSS_COMPILE_PATH_2ND_ARCH   := ${ANDROID_TOP}/prebuilts/gcc/linux-x86/arm/arm-linux-androideabi-4.9/bin
export P_REFSW_CC_2ND_ARCH                   := ${B_REFSW_CROSS_COMPILE_PATH_2ND_ARCH}/arm-linux-androideabi-
export B_REFSW_KERNEL_ARCH_1ST_ARCH          := aarch64-linux
export B_REFSW_KERNEL_CROSS_COMPILE_1ST_ARCH := aarch64-linux-
export P_REFSW_DRV_ARCH                      := arm64
endif
else
export B_REFSW_ARCH_1ST_ARCH                 := arm-linux
export B_REFSW_TOOLCHAIN_ARCH_1ST_ARCH       := arm-linux
export B_REFSW_CROSS_COMPILE_PATH_1ST_ARCH   := ${ANDROID_TOP}/prebuilts/gcc/linux-x86/arm/arm-linux-androideabi-4.9/bin
export P_REFSW_CC                            := ${B_REFSW_CROSS_COMPILE_PATH_1ST_ARCH}/arm-linux-androideabi-
export B_REFSW_PREBUILT_LIBGCC_1ST_ARCH      := prebuilts/gcc/linux-x86/arm/arm-linux-androideabi-4.9/lib/gcc/arm-linux-androideabi/4.9.x/libgcc.a
export B_REFSW_KERNEL_ARCH_1ST_ARCH          := arm-linux
export B_REFSW_KERNEL_CROSS_COMPILE_1ST_ARCH := arm-linux-
export P_REFSW_DRV_ARCH                      := arm
endif
export B_REFSW_USES_CLANG                    ?= y
ifeq ($(B_REFSW_USES_CLANG),y)
   export P_REFSW_CC_CLANG_VER               := clang-4579689
   export P_REFSW_CC_CLANG                   := ${ANDROID_TOP}/prebuilts/clang/host/linux-x86/${P_REFSW_CC_CLANG_VER}/bin
endif
export B_REFSW_CCACHE                        := ${ANDROID_TOP}/prebuilts/misc/linux-x86/ccache/ccache
export USE_CCACHE

export LOCAL_LINUX_VERSION                   ?= -4.9
export LOCAL_LINUX_VERSION_NODASH            ?= 4.9
export LINUX                                 := ${ANDROID_TOP}/kernel/private/bcm-97xxx/linux${LOCAL_LINUX_VERSION}
export REFSW_BASE_DIR                        := ${ANDROID}/${BCM_VENDOR_STB_ROOT}/refsw
export ROCKFORD                              := ${ANDROID}/${BCM_VENDOR_STB_ROOT}/refsw/rockford

# this section defines the middleware configuration generic to all devices, first we define some
# variations which may be overriden by local device custom.
#
export BDSP_MS10_SUPPORT                     ?= n
export BDSP_MS11_SUPPORT                     ?= n
export BDSP_MS12_SUPPORT                     ?= n
export NEXUS_HDMI_INPUT_SUPPORT              ?= y
export ANDROID_ENABLE_BT                     ?= usb
export ANDROID_ENABLE_DHD_SECDMA             ?= n
export BOLT_IMG_TO_USE_OVERRIDE              ?= bolt-bb.bin
export BOLT_IMG_TO_USE_OVERRIDE_2ND          ?=
export BROADCOM_WIFI_CHIPSET                 ?= 43570a2
export LOCAL_NVI_LAYOUT                      ?= n
export LOCAL_DEVICE_GPT_O_LAYOUT             ?= n
export LOCAL_ARM_TRUSTZONE_USE               ?= n
export LOCAL_DEVICE_BOOT                     ?= 33554432    # 32M
export LOCAL_DEVICE_RECOVERY_LEGACY          ?= 33554432    # 32M
ifneq ($(LOCAL_NVI_LAYOUT),y)
export LOCAL_DEVICE_SYSTEM_LEGACY            ?= 1602224128  # 1528M
export LOCAL_DEVICE_VENDOR_LEGACY            ?= 234881024   # 224M
ifeq ($(LOCAL_DEVICE_GPT_O_LAYOUT),y)
ifeq ($(LOCAL_ARM_TRUSTZONE_USE),y)
export LOCAL_DEVICE_SYSTEM_AB                ?= 1468006400  # 1400M
else
export LOCAL_DEVICE_SYSTEM_AB                ?= 1486880768  # 1418M
endif
export LOCAL_DEVICE_SYSTEM_XL                := y
else
export LOCAL_DEVICE_SYSTEM_AB                ?= 950009856   # 906M
endif
ifeq ($(LOCAL_ARM_TRUSTZONE_USE),y)
export LOCAL_DEVICE_VENDOR_AB                ?= 89128960    # 85M
else
export LOCAL_DEVICE_VENDOR_AB                ?= 104857600   # 100M
endif
else
export LOCAL_DEVICE_SYSTEM_LEGACY            ?= 1283457024  # 1224M
ifeq ($(LOCAL_DEVICE_GPT_O_LAYOUT),y)
export LOCAL_DEVICE_SYSTEM_AB                ?= 1486880768  # 1418M
export LOCAL_DEVICE_SYSTEM_XL                := y
else
export LOCAL_DEVICE_SYSTEM_AB                ?= 1054867456  # 1006M
endif
endif
export LOCAL_DEVICE_USERDATA_FS              ?= ext4
export LOCAL_DEVICE_SYSTEM_VERITY_PARTITION  ?= /dev/block/by-name/system
export LOCAL_DEVICE_VENDOR_VERITY_PARTITION  ?= /dev/block/by-name/vendor
export LOCAL_DEVICE_SAGE_DEV_N_PROD          ?= n
export LOCAL_DEVICE_RTS_MODE                 ?= 5
export LOCAL_DEVICE_USE_VERITY               ?= n
export LOCAL_DEVICE_BGRCPKT_PLANES           ?= 2
export LOCAL_DEVICE_MKBOOTIMG_ARGS           ?= --ramdisk_offset 0x02200000
export LOCAL_DEVICE_USE_AVB                  ?= n
export LOCAL_DEVICE_PROPERTIES_LEGACY        ?= y
export LOCAL_DEVICE_LOWRAM                   ?= n
export LOCAL_DEVICE_MEDIA_NO_HW_AUDIO        ?= n
export LOCAL_DEVICE_KMCERT_DEFAULT_DEV       ?= device/broadcom/common/kmgk/km.zd.bcm.generic.bin
export LOCAL_DEVICE_KMCERT_DEFAULT_PROD      ?= device/broadcom/common/kmgk/km.zb.cus.generic.bin
export LOCAL_DEVICE_HWCFG_TYPE               ?= cramfs

export HW_ENCODER_SUPPORT                    ?= y
export HW_WIFI_NIC_SUPPORT                   ?= n
export HW_TZ_SUPPORT                         ?= n
export HW_AB_UPDATE_SUPPORT                  ?= n
export HW_WIFI_NIC_DUAL_SUPPORT              ?= n
export HAL_HWC_VERSION                       ?= v-2.0
export HW_GPU_MMU_SUPPORT                    ?= n
export HW_DTU_SUPPORT                        ?= n
export BCM_APP_CUSTOM                        ?= y
export HW_HVD_REVISION                       ?= R
export HW_HVD_REDUX                          ?= n
export HAL_GR_VERSION                        ?= v-0.x
export DTCP_IP_SAGE_SUPPORT                  ?= n
export HW_GPU_VULKAN_SUPPORT                 ?= n
export LOCAL_DEVICE_USE_FIXED_SLOT           ?= n
export BOLT_ZEUS_VER                         ?= zeus42
export LOCAL_DEVICE_MSD_SUPPORT              ?= n
export LOCAL_DEVICE_PAK_BINARY               ?=
export LOCAL_DEVICE_PAK_BINARY_ALT           ?=
export HW_THERMAL_CONFIG_SUPPORT             ?= y
export LOCAL_DTBO_SUPPORT                    ?= n
export LOCAL_DEVICE_DTBO_IMAGE               ?=
export HW_CAMERA_SUPPORT                     ?= y

export BCM_GPT_CONFIG_FILE                   := $(LOCAL_DEVICE_GPT)
export ANDROID_BUILD                         := y
export ANDROID_SUPPORTS_DTVKIT               := n
export BROADCOM_DHD_SOURCE_PATH              := ${ANDROID}/${BCM_VENDOR_STB_ROOT}/drivers/bcmdhd
export BROADCOM_NIC_SCRIPT_PATH              := ${ANDROID}/${BCM_VENDOR_STB_ROOT}/drivers/bcmnic
export BROADCOM_NIC_SOURCE_PATH              := ${ANDROID}/${BCM_VENDOR_STB_ROOT}/refsw/BSEAV/connectivity/wlan/core
export BROADCOM_NIC_DUAL_SOURCE_PATH         := ${ANDROID}/${BCM_VENDOR_STB_ROOT}/drivers/bcmnic_dual
export HLS_PROTOCOL_SUPPORT                  := y

export NEXUS_POWER_MANAGEMENT                ?= y
export NEXUS_USE_PRECOMPILED_HEADERS         := n
export NEXUS_ANDROID_SUPPORT                 := y
export NEXUS_MODE                            := proxy  # fixed!
export NEXUS_KEYPAD_SUPPORT                  := n
export NEXUS_LOGGER_EXTERNAL                 := y
export NEXUS_LOGGER_LOCATION                 := ${ANDROID}/${BCM_VENDOR_STB_ROOT}/bcm_platform/nxif/nxlogger
export NEXUS_PLATFORM_7241_WIFI              := n
export NEXUS_REPLACE_BOILERPLATE             := y
export NEXUS_SHARED_LIB                      := y
export PVR_SUPPORT                           := y
export SHAREABLE                             := y
export SHELL
export SMP                                   := y
export SSL_SUPPORT                           := y
export LIVEMEDIA_SUPPORT                     := n
export ANDROID_USES_BORINGSSL                := y
export NEXUS_C_STD                           := c99
export NEXUS_EXPORT_FILE                     := ${ANDROID}/${BCM_VENDOR_STB_ROOT}/bcm_platform/nxif/nexus_export_file.txt
export NEXUS_DISPLAY_EXTENSION_INC           += $(NEXUS_TOP)/extensions/display/dynrng/dynrng.inc
export GMS_PACKAGE_ROOT                      := vendor/broadcom/prebuilts/gms/
export VENDOR_PLAYREADY_ROOT                 := vendor/broadcom/playready

# if enabling region verification, enable this to dump firmware for
# offline signing.
#
export NEXUS_REGION_VERIFICATION_DUMP_FIRMWARE_RAW ?= n

# some massaging for security support, make it simple to remove as it often requires to
# be disabled for new device bring up.
#
export ANDROID_SUPPORTS_WIDEVINE        ?= y
export ANDROID_ENABLE_HDMI_HDCP         ?= y
export ANDROID_SUPPORTS_PLAYREADY       ?= y
export ANDROID_PLAYREADY_VERSION        ?= 2.5

ifneq ($(ANDROID_SUPPORTS_PLAYREADY),n)
ifneq ($(wildcard $(VENDOR_PLAYREADY_ROOT)),)
    export ANDROID_SUPPORTS_PLAYREADY    := y
else
    export ANDROID_SUPPORTS_PLAYREADY    := n
endif
endif
export ANDROID_SUPPORTS_RPMB            ?= y
export ANDROID_SUPPORTS_KEYMASTER       ?= y
export ANDROID_DEVICE_SUPPORTS_BP3      ?= n

ifneq ($(filter $(ANDROID_SUPPORTS_WIDEVINE) $(ANDROID_SUPPORTS_PLAYREADY) $(ANDROID_ENABLE_HDMI_HDCP) \
                $(ANDROID_SUPPORTS_RPMB) $(ANDROID_SUPPORTS_KEYMASTER) $(ANDROID_SUPPORTS_MEDIACAS),y),)
    export SAGE_SUPPORT                  := y
    export SAGE_BINARIES_AVAILABLE       := y
    export NEXUS_SECURITY_SUPPORT        := y
    export KEYLADDER_SUPPORT             := y
    export NEXUS_COMMON_CRYPTO_SUPPORT   := y
    export BMRC_ALLOW_XPT_TO_ACCESS_KERNEL := y
    ifeq ($(ANDROID_ENABLE_HDMI_HDCP), y)
        export NEXUS_HDCP_SUPPORT    := y
    endif
    ifeq ($(ANDROID_SUPPORTS_PLAYREADY), y)
        export MSDRM_PRDY_SUPPORT     := y
        export MSDRM_PRDY_SDK_VERSION := 2.5
    endif
    ifeq ($(SAGE_VERSION),2x)
        export SAGE_SECURE_MODE ?= 5
    endif
endif

ifeq ($(HW_TZ_SUPPORT),y)
include device/broadcom/common/lk/config.mk
include device/broadcom/common/bl31/config.mk
endif

include device/broadcom/common/middleware/bindist.mk

