# armv8 platforms.
ifeq ($(LOCAL_ARM_AARCH64),y)
# abi not compatible for 32/64 bit nexus (runs as armv7)!
ifeq ($(LOCAL_ARM_AARCH64_NOT_ABI_COMPATIBLE),y)
include device/broadcom/common/BoardConfig32.mk
else
# yeah!
include device/broadcom/common/BoardConfig64.mk
ifeq ($(LOCAL_ANDROID_64BIT),y)
TARGET_PREFER_32_BIT_APPS   :=
TARGET_SUPPORTS_32_BIT_APPS :=
TARGET_SUPPORTS_64_BIT_APPS := true
endif
endif
# legacy armv7 platforms.
else
include device/broadcom/common/BoardConfig32.mk
endif

TARGET_NO_BOOTLOADER         := true
TARGET_NO_KERNEL             := false
TARGET_NO_RADIOIMAGE         := true
HAVE_HTC_AUDIO_DRIVER        := true
export TARGET_BOARD_PLATFORM := ${ANDROID_PRODUCT_OUT}
USE_OPENGL_RENDERER          := true
BOARD_USES_GENERIC_AUDIO     := false
USE_LEGACY_AUDIO_POLICY      := 0
USE_CUSTOM_AUDIO_POLICY      := 1
USE_XML_AUDIO_POLICY_CONF    := 1

# Wifi related defines
BOARD_WLAN_DEVICE                      := bcmdhd
BOARD_WLAN_DEVICE_REV                  := bcm4334_b1
WPA_SUPPLICANT_VERSION                 := VER_0_8_X
BOARD_WPA_SUPPLICANT_DRIVER            := NL80211
BOARD_WPA_SUPPLICANT_PRIVATE_LIB       := lib_driver_cmd_bcmdhd

# BT
ifneq ($(filter usb uart,$(ANDROID_ENABLE_BT)),)
BOARD_HAVE_BLUETOOTH := true
BOARD_HAVE_BLUETOOTH_BCM := true
BOARD_BLUETOOTH_BDROID_BUILDCFG_INCLUDE_DIR := device/broadcom/common/bluetooth
BOARD_CUSTOM_BT_CONFIG := ${LOCAL_DEVICE_BT_CONFIG}
else
PRODUCT_PROPERTY_OVERRIDES += config.disable_bluetooth=true
endif

ifeq ($(ANDROID_SUPPORTS_WIDEVINE),y)
BOARD_WIDEVINE_OEMCRYPTO_LEVEL := 3
endif

TARGET_USERIMAGES_USE_EXT4         := true
BOARD_BOOTIMAGE_PARTITION_SIZE     := $(LOCAL_DEVICE_BOOT)
ifneq ($(HW_AB_UPDATE_SUPPORT),y)
BOARD_CACHEIMAGE_PARTITION_SIZE    := 268435456  # 256M
BOARD_CACHEIMAGE_FILE_SYSTEM_TYPE  := ext4
BOARD_RECOVERYIMAGE_PARTITION_SIZE := $(LOCAL_DEVICE_RECOVERY_LEGACY)
BOARD_SYSTEMIMAGE_PARTITION_SIZE   := $(LOCAL_DEVICE_SYSTEM_LEGACY)
else
BOARD_CACHEIMAGE_PARTITION_SIZE    := 10485760   # 10M
BOARD_CACHEIMAGE_FILE_SYSTEM_TYPE  := ext4
BOARD_SYSTEMIMAGE_PARTITION_SIZE   := $(LOCAL_DEVICE_SYSTEM_AB)
endif
BOARD_USERDATAIMAGE_PARTITION_SIZE := $(LOCAL_DEVICE_USERDATA)
BOARD_FLASH_BLOCK_SIZE             := 512
BOARD_KERNEL_BASE                  := 0x00008000
BOARD_KERNEL_PAGESIZE              := 4096
ifeq ($(LOCAL_SYSTEMIMAGE_SQUASHFS),y)
BOARD_SYSTEMIMAGE_JOURNAL_SIZE        := 0
BOARD_SYSTEMIMAGE_SQUASHFS_COMPRESSOR := lz4
BOARD_SYSTEMIMAGE_FILE_SYSTEM_TYPE    := squashfs
endif

BOARD_ROOT_EXTRA_FOLDERS  := eio hwcfg
BOARD_ROOT_EXTRA_SYMLINKS :=

ifeq ($(HW_AB_UPDATE_SUPPORT),y)
AB_OTA_UPDATER    := true
AB_OTA_PARTITIONS := boot system
BOARD_BUILD_SYSTEM_ROOT_IMAGE := true
BOARD_USES_RECOVERY_AS_BOOT   := true
endif

ifeq ($(LOCAL_DEVICE_KERNEL_CMDLINE),)
$(error please define a valid kernel boot configuration)
endif
BOARD_KERNEL_CMDLINE := $(LOCAL_DEVICE_KERNEL_CMDLINE)
BOARD_MKBOOTIMG_ARGS := --ramdisk_offset 0x02200000

ifeq ($(HW_AB_UPDATE_SUPPORT),y)
TARGET_NO_RECOVERY             := true
TARGET_RECOVERY_WIPE           := device/broadcom/common/recovery/recovery.wipe
TARGET_RECOVERY_FSTAB          := $(LOCAL_DEVICE_RECOVERY_FSTAB)
else
TARGET_RECOVERY_FSTAB          := $(LOCAL_DEVICE_RECOVERY_FSTAB)
TARGET_RECOVERY_UI_LIB         := librecovery_ui_ext
TARGET_RECOVERY_UPDATER_LIBS   := librecovery_updater_ext
TARGET_RELEASETOOLS_EXTENSIONS := device/broadcom/common
TARGET_RECOVERY_PIXEL_FORMAT   := "RGBX_8888"
endif

BOARD_SEPOLICY_DIRS += device/broadcom/common/sepolicy
BOARD_SEPOLICY_DIRS += $(LOCAL_DEVICE_SEPOLICY_BLOCK)
BOARD_SECCOMP_POLICY += device/broadcom/common/seccomp

NUM_FRAMEBUFFER_SURFACE_BUFFERS := 3

TARGET_BOARD_KERNEL_HEADERS := device/broadcom/common/kernel-headers

ifeq ($(LOCAL_USE_CLANG),n)
USE_CLANG_PLATFORM_BUILD := false
else
USE_CLANG_PLATFORM_BUILD := true
endif

ifeq ($(HAL_HWC_VERSION),v-2.0)
TARGET_USES_HWC2         := true
endif

include device/broadcom/common/middleware/build.mk

# Don't dex preopt prebuilt apps that will be updated from Play Store
DONT_DEXPREOPT_PREBUILTS := true

