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

ifeq (${ANDROID_PRODUCT_OUT},)
$(error please define ANDROID_PRODUCT_OUT)
endif

# filter rules for build inclusions based on boards supported.  when adding a new
# board to the system, you may want to add it here too.
#
export BCM_RBOARDS                           := avko banff cypress% dawson% elfin
export BCM_DBOARDS                           := bcm7%
export BCM_CBOARDS                           := fbx%

export BCM_VENDOR_STB_ROOT                   := vendor/broadcom

# this section defines all the cross compilation and compiler data.
#
export ANDROID                               := $(shell pwd)
export ANDROID_TOP                           := ${ANDROID}
ifeq ($(LOCAL_ARM_AARCH64),y)
ifeq ($(LOCAL_ARM_AARCH64_NOT_ABI_COMPATIBLE),y)
export B_REFSW_ARCH_1ST_ARCH                 := arm-linux
export B_REFSW_KERNEL_CROSS_COMPILE_1ST_ARCH := arm-linux-
export B_REFSW_TOOLCHAIN_ARCH_1ST_ARCH       := arm-linux
export B_REFSW_CROSS_COMPILE_PATH_1ST_ARCH   := ${ANDROID_TOP}/prebuilts/gcc/linux-x86/arm/arm-linux-androideabi-4.9/bin
export P_REFSW_CC                            := ${B_REFSW_CROSS_COMPILE_PATH_1ST_ARCH}/arm-linux-androideabi-
export P_REFSW_DRV_ARCH                      := arm
export B_REFSW_PREBUILT_LIBGCC_1ST_ARCH      := prebuilts/gcc/linux-x86/arm/arm-linux-androideabi-4.9/lib/gcc/arm-linux-androideabi/4.9/libgcc.a
else
export B_REFSW_ARCH_1ST_ARCH                 := aarch64-linux
export B_REFSW_KERNEL_CROSS_COMPILE_1ST_ARCH := aarch64-linux-
export B_REFSW_TOOLCHAIN_ARCH_1ST_ARCH       := aarch64-linux
export B_REFSW_CROSS_COMPILE_PATH_1ST_ARCH   := ${ANDROID_TOP}/prebuilts/gcc/linux-x86/aarch64/aarch64-linux-android-4.9/bin
export B_REFSW_PREBUILT_LIBGCC_1ST_ARCH      := prebuilts/gcc/linux-x86/aarch64/aarch64-linux-android-4.9/lib/gcc/aarch64-linux-android/4.9/libgcc.a
export P_REFSW_CC                            := ${B_REFSW_CROSS_COMPILE_PATH_1ST_ARCH}/aarch64-linux-android-
export P_REFSW_DRV_ARCH                      := arm64
export B_REFSW_ARCH_2ND_ARCH                 := arm-linux
export B_REFSW_KERNEL_CROSS_COMPILE_2ND_ARCH := arm-linux-
export B_REFSW_TOOLCHAIN_ARCH_2ND_ARCH       := arm-linux
export B_REFSW_PREBUILT_LIBGCC_2ND_ARCH      := prebuilts/gcc/linux-x86/arm/arm-linux-androideabi-4.9/lib/gcc/arm-linux-androideabi/4.9/libgcc.a
export B_REFSW_CROSS_COMPILE_PATH_2ND_ARCH   := ${ANDROID_TOP}/prebuilts/gcc/linux-x86/arm/arm-linux-androideabi-4.9/bin
export P_REFSW_CC_2ND_ARCH                   := ${B_REFSW_CROSS_COMPILE_PATH_2ND_ARCH}/arm-linux-androideabi-
endif
else
export B_REFSW_ARCH_1ST_ARCH                 := arm-linux
export B_REFSW_KERNEL_CROSS_COMPILE_1ST_ARCH := arm-linux-
export B_REFSW_TOOLCHAIN_ARCH_1ST_ARCH       := arm-linux
export B_REFSW_CROSS_COMPILE_PATH_1ST_ARCH   := ${ANDROID_TOP}/prebuilts/gcc/linux-x86/arm/arm-linux-androideabi-4.9/bin
export P_REFSW_CC                            := ${B_REFSW_CROSS_COMPILE_PATH_1ST_ARCH}/arm-linux-androideabi-
export P_REFSW_DRV_ARCH                      := arm
export B_REFSW_PREBUILT_LIBGCC_1ST_ARCH      := prebuilts/gcc/linux-x86/arm/arm-linux-androideabi-4.9/lib/gcc/arm-linux-androideabi/4.9/libgcc.a
endif
export B_REFSW_USES_CLANG                    ?= y
ifeq ($(B_REFSW_USES_CLANG),y)
   export P_REFSW_CC_CLANG                   := ${ANDROID_TOP}/prebuilts/clang/linux-x86/host/3.6/bin
endif
export B_REFSW_CCACHE                        := ${ANDROID_TOP}/prebuilts/misc/linux-x86/ccache/ccache
export USE_CCACHE                            := 1

export LOCAL_LINUX_VERSION                   ?= -4.1
export LINUX                                 := ${ANDROID_TOP}/kernel/private/bcm-97xxx/linux${LOCAL_LINUX_VERSION}
export REFSW_BASE_DIR                        := ${ANDROID}/${BCM_VENDOR_STB_ROOT}/refsw
export ROCKFORD                              := ${ANDROID}/${BCM_VENDOR_STB_ROOT}/refsw/rockford

# this section defines the middleware configuration generic to all devices, first we define some
# variations which may be overriden by local device custom.
#
export BDSP_MS10_SUPPORT                     ?= n
export NEXUS_HDMI_INPUT_SUPPORT              ?= y
export ANDROID_ENABLE_BT                     ?= usb
export ANDROID_ENABLE_DHD_SECDMA             ?= n
export BOLT_IMG_TO_USE_OVERRIDE              ?= bolt-bb.bin
export BROADCOM_WIFI_CHIPSET                 ?= 43570a2
export LOCAL_DEVICE_BOOT                     ?= 33554432    # 32M
export LOCAL_DEVICE_SYSTEM_LEGACY            ?= 1283457024  # 1224M
export LOCAL_DEVICE_SYSTEM_AB                ?= 769654784   # 734M

export HW_ENCODER_SUPPORT                    ?= y
export HW_WIFI_NIC_SUPPORT                   ?= n
export HW_TZ_SUPPORT                         ?= n
export HW_AB_UPDATE_SUPPORT                  ?= n
export HW_WIFI_NIC_DUAL_SUPPORT              ?= n
export HAL_HWC_VERSION                       ?= v-2.0
export HW_GPU_MMU_SUPPORT                    ?= n
export HW_DTU_SUPPORT                        ?= n

export BCM_GPT_CONFIG_FILE                   := $(LOCAL_DEVICE_GPT)
export ANDROID_BUILD                         := y
export ANDROID_SUPPORTS_DTVKIT               := n
export BROADCOM_DHD_SOURCE_PATH              := ${ANDROID}/${BCM_VENDOR_STB_ROOT}/drivers/bcmdhd
export BROADCOM_NIC_SOURCE_PATH              := ${ANDROID}/${BCM_VENDOR_STB_ROOT}/drivers/bcmnic
export BROADCOM_NIC_DUAL_SOURCE_PATH         := ${ANDROID}/${BCM_VENDOR_STB_ROOT}/drivers/bcmnic_dual
export HLS_PROTOCOL_SUPPORT                  := y

export NEXUS_USE_PRECOMPILED_HEADERS         := n
export NEXUS_ANDROID_SUPPORT                 := y
export NEXUS_MODE                            := proxy  # fixed!
export NEXUS_KEYPAD_SUPPORT                  := n
export NEXUS_LOGGER_EXTERNAL                 := y
export NEXUS_PLATFORM_7241_WIFI              := n
export NEXUS_POWER_MANAGEMENT                := y
export NEXUS_REPLACE_BOILERPLATE             := y
export NEXUS_SHARED_LIB                      := y
export PVR_SUPPORT                           := y
export SHAREABLE                             := y
export SHELL                                 := /bin/bash
export SMP                                   := y
export SSL_SUPPORT                           := y
export LIVEMEDIA_SUPPORT                     := n
export DTCP_IP_SUPPORT                       := y
export ANDROID_USES_BORINGSSL                := y
export NEXUS_C_STD                           := c99
export NEXUS_EXPORT_FILE                     := ${ANDROID}/${BCM_VENDOR_STB_ROOT}/bcm_platform/nxif/nexus_export_file.txt
export GMS_PACKAGE_ROOT                      := vendor/broadcom/prebuilts/gms/

# some massaging for security support, make it simple to remove as it often requires to
# be disabled for new device bring up.
#
export ANDROID_SUPPORTS_WIDEVINE             ?= y
export ANDROID_ENABLE_HDMI_HDCP              ?= y
ifneq ($(ANDROID_SUPPORTS_PLAYREADY),n)
ifneq ($(wildcard vendor/broadcom/playready),)
	export ANDROID_SUPPORTS_PLAYREADY    := y
else
	export ANDROID_SUPPORTS_PLAYREADY    := n
endif
endif

ifneq ($(filter $(ANDROID_SUPPORTS_WIDEVINE) $(ANDROID_SUPPORTS_PLAYREADY) $(ANDROID_ENABLE_HDMI_HDCP),y),)
	export SAGE_SUPPORT                  := y
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

