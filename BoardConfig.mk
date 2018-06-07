# armv8 platforms.
ifeq ($(LOCAL_ARM_AARCH64),y)
# abi not compatible for 32/64 bit nexus (runs as armv7)!
ifeq ($(LOCAL_ARM_AARCH64_NOT_ABI_COMPATIBLE),y)
include device/broadcom/common/BoardConfig32.mk
else
ifeq ($(LOCAL_ARM_AARCH64_COMPAT_32_BIT),y)
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
endif
# legacy armv7 platforms.
else
include device/broadcom/common/BoardConfig32.mk
endif

TARGET_NO_BOOTLOADER         := true
TARGET_NO_KERNEL             := false
TARGET_NO_RADIOIMAGE         := true
HAVE_HTC_AUDIO_DRIVER        := true
USE_OPENGL_RENDERER          := true
BOARD_USES_GENERIC_AUDIO     := false
USE_LEGACY_AUDIO_POLICY      := 0
USE_CUSTOM_AUDIO_POLICY      := 0
USE_XML_AUDIO_POLICY_CONF    := 1
BOARD_VNDK_VERSION           := current

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
endif

ifeq ($(ANDROID_SUPPORTS_WIDEVINE),y)
BOARD_WIDEVINE_OEMCRYPTO_LEVEL := 3
endif

TARGET_USERIMAGES_USE_EXT4         := true
BOARD_BOOTIMAGE_PARTITION_SIZE     := $(LOCAL_DEVICE_BOOT)
ifneq ($(HW_AB_UPDATE_SUPPORT),y)
ifeq ($(LOCAL_DEVICE_FORCED_NAB),y)
BOARD_RECOVERYIMAGE_PARTITION_SIZE := 67108864   # 64M
BOARD_CACHEIMAGE_PARTITION_SIZE    := 536870912  # 512M
BOARD_CACHEIMAGE_FILE_SYSTEM_TYPE  := ext4
BOARD_SYSTEMIMAGE_PARTITION_SIZE   := $(LOCAL_DEVICE_SYSTEM_AB)  # align with a|b ref.
BOARD_VENDORIMAGE_PARTITION_SIZE   := $(LOCAL_DEVICE_VENDOR_AB)  # align with a|b ref.
else
BOARD_RECOVERYIMAGE_PARTITION_SIZE := $(LOCAL_DEVICE_RECOVERY_LEGACY)
BOARD_CACHEIMAGE_PARTITION_SIZE    := 268435456  # 256M
BOARD_CACHEIMAGE_FILE_SYSTEM_TYPE  := ext4
BOARD_SYSTEMIMAGE_PARTITION_SIZE   := $(LOCAL_DEVICE_SYSTEM_LEGACY)
ifneq ($(LOCAL_NVI_LAYOUT),y)
BOARD_VENDORIMAGE_PARTITION_SIZE   := $(LOCAL_DEVICE_VENDOR_LEGACY)
endif
endif
else
BOARD_CACHEIMAGE_PARTITION_SIZE    := 10485760   # 10M
BOARD_CACHEIMAGE_FILE_SYSTEM_TYPE  := ext4
BOARD_SYSTEMIMAGE_PARTITION_SIZE   := $(LOCAL_DEVICE_SYSTEM_AB)
ifneq ($(LOCAL_NVI_LAYOUT),y)
BOARD_VENDORIMAGE_PARTITION_SIZE   := $(LOCAL_DEVICE_VENDOR_AB)
endif
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
ifneq ($(LOCAL_NVI_LAYOUT),y)
ifeq ($(LOCAL_VENDORIMAGE_SQUASHFS),y)
BOARD_VENDORIMAGE_JOURNAL_SIZE        := 0
BOARD_VENDORIMAGE_SQUASHFS_COMPRESSOR := lz4
BOARD_VENDORIMAGE_FILE_SYSTEM_TYPE    := squashfs
else
BOARD_VENDORIMAGE_FILE_SYSTEM_TYPE    := ext4
endif
endif

BOARD_ROOT_EXTRA_FOLDERS  := eio
BOARD_ROOT_EXTRA_SYMLINKS :=

ifeq ($(HW_AB_UPDATE_SUPPORT),y)
AB_OTA_UPDATER    := true
ifneq ($(LOCAL_NVI_LAYOUT),y)
AB_OTA_PARTITIONS := boot system vendor
else
AB_OTA_PARTITIONS := boot system
endif
BOARD_BUILD_SYSTEM_ROOT_IMAGE := true
BOARD_USES_RECOVERY_AS_BOOT   := true
endif

TARGET_FS_CONFIG_GEN += device/broadcom/common/config.fs

ifeq ($(LOCAL_DEVICE_KERNEL_CMDLINE),)
$(error please define a valid kernel boot configuration)
endif
BOARD_KERNEL_CMDLINE := $(LOCAL_DEVICE_KERNEL_CMDLINE)
BOARD_KERNEL_CMDLINE += cgroup.memory=nokmem
BOARD_MKBOOTIMG_ARGS := $(LOCAL_DEVICE_MKBOOTIMG_ARGS)

ifeq ($(HW_AB_UPDATE_SUPPORT),y)
TARGET_NO_RECOVERY             := true
TARGET_RECOVERY_WIPE           := device/broadcom/common/recovery/recovery.wipe
TARGET_RECOVERY_FSTAB          := $(LOCAL_DEVICE_RECOVERY_FSTAB)
else
TARGET_RECOVERY_FSTAB          := $(LOCAL_DEVICE_RECOVERY_FSTAB)
TARGET_RECOVERY_UPDATER_LIBS   := librecovery_updater_ext
TARGET_RELEASETOOLS_EXTENSIONS := device/broadcom/common
endif
TARGET_RECOVERY_UI_LIB         := librecovery_ui_ext
TARGET_RECOVERY_PIXEL_FORMAT   := "RGBX_8888"

ifeq ($(LOCAL_DEVICE_FULL_TREBLE),y)
BOARD_SEPOLICY_DIRS += device/broadcom/common/sepolicy/treble
else
BOARD_SEPOLICY_DIRS += device/broadcom/common/sepolicy/legacy
endif
BOARD_SEPOLICY_DIRS += $(LOCAL_DEVICE_SEPOLICY_BLOCK)
ifeq ($(ANDROID_DEVICE_SUPPORTS_BP3),y)
BOARD_SEPOLICY_M4DEFS += target_bp3=true
else
BOARD_SEPOLICY_M4DEFS += target_bp3=false
endif
ifdef PRODUCT_SHIPPING_API_LEVEL
ifeq ($(call math_lt,27,$(PRODUCT_SHIPPING_API_LEVEL)),)
BOARD_SEPOLICY_M4DEFS += target_nxsysprop=true
endif
else
# warning: assume legacy configuration.
BOARD_SEPOLICY_M4DEFS += target_nxsysprop=true
endif

NUM_FRAMEBUFFER_SURFACE_BUFFERS := 3

TARGET_BOARD_KERNEL_HEADERS := device/broadcom/common/kernel-headers

ifneq ($(LOCAL_NVI_LAYOUT),y)
# use vendor.img outside of system.img scope.
TARGET_COPY_OUT_VENDOR := vendor
endif

ifeq ($(HAL_HWC_VERSION),v-2.0)
TARGET_USES_HWC2         := true
endif

ifneq ($(LOCAL_DEVICE_FULL_TREBLE),y)
SF_START_GRAPHICS_ALLOCATOR_SERVICE := true
endif

include device/broadcom/common/middleware/build.mk

MALLOC_SVELTE := true

ifeq ($(LOCAL_DEVICE_USE_AVB),y)
BOARD_AVB_ENABLE := true
endif

ifneq ($(LOCAL_NVI_LAYOUT),y)
BOARD_PROPERTY_OVERRIDES_SPLIT_ENABLED := true
endif

ifeq ($(LOCAL_DEVICE_SYSTEM_XL),y)
# devices with large enough system partitions can allow
# dexpreopt of apk's.  only a|b devices with 'o' gpt layout
# can afford this in our reference.
else
DONT_DEXPREOPT_PREBUILTS       := true
DONT_UNCOMPRESS_PRIV_APPS_DEXS := true
endif
