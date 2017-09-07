ifeq ($(LOCAL_ARM_AARCH64),y)
ifneq ($(LOCAL_ARM_AARCH64_NOT_ABI_COMPATIBLE),y)
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)
endif
endif

# pre-emptive overwrite of module inherited from 'embedded.mk' product hierarchy:
#   - this is needed to wok around hardware limitations on number of simultaneous usb
#     endpoint available on the devices.
#   - at the present time, the limitation is the same for all hw variants, eventually it won't
#     be...
#
PRODUCT_COPY_FILES += device/broadcom/common/rcs/init.usb.configfs.bcm.rc:root/init.usb.configfs.rc

# To prevent from including GMS twice in Google's internal source.
ifeq ($(wildcard vendor/unbundled_google),)
PRODUCT_USE_PREBUILT_GMS := yes
endif

# Only include google_aware.xml if building on Google internal structure.
ifneq ($(wildcard $(TOPDIR)vendor/google/products/gms.mk),)
PRODUCT_COPY_FILES += $(TOPDIR)device/broadcom/common/rcs/google_aware.xml:system/etc/permissions/google_aware.xml
endif

$(call inherit-product, $(SRC_TARGET_DIR)/product/languages_full.mk)
$(call inherit-product, device/google/atv/products/atv_base.mk)
include device/broadcom/common/settings.mk
# include the gms packages and configuration
# TODO: FiX GMS package and configuration locations for intenal and extenal builds
ifeq ($(PRODUCT_USE_PREBUILT_GMS),yes)
$(call inherit-product-if-exists, ${GMS_PACKAGE_ROOT}/google/products/gms.mk)
else
$(call inherit-product-if-exists, ${GMS_PACKAGE_ROOT}/google/products/gms.mk)
endif
include device/broadcom/common/middleware/definitions.mk

ifneq ($(BCM_DIST_KNLIMG_BINS),y)
ifeq ($(TARGET_BUILD_VARIANT),user)
export B_REFSW_DEBUG       ?= n
export B_REFSW_DEBUG_LEVEL :=
else
export B_REFSW_DEBUG       ?= y
export B_REFSW_DEBUG_LEVEL := msg
export NEXUS_EXTRA_CFLAGS  := -DNEXUS_P_TRACE=1 -DNEXUS_P_SYNC_TRACE=1
endif
# allow only one mode for binary distribution.
else
export B_REFSW_DEBUG       ?= y
export B_REFSW_DEBUG_LEVEL := msg
export NEXUS_EXTRA_CFLAGS  := -DNEXUS_P_TRACE=1 -DNEXUS_P_SYNC_TRACE=1
endif

PRODUCT_CHARACTERISTICS := tv
PRODUCT_MANUFACTURER    := broadcom

ifneq ($(wildcard device/google/atv/permissions/tv_core_hardware.xml),)
# purposefully swap overlay layout to override some settings from the ATV setup.
DEVICE_PACKAGE_OVERLAYS := device/broadcom/common/overlay
DEVICE_PACKAGE_OVERLAYS += device/google/atv/overlay
else
DEVICE_PACKAGE_OVERLAYS := device/broadcom/common/overlay
endif
ifneq ($(LOCAL_DEVICE_OVERLAY),)
DEVICE_PACKAGE_OVERLAYS := $(LOCAL_DEVICE_OVERLAY) $(DEVICE_PACKAGE_OVERLAYS)
endif

PRODUCT_AAPT_CONFIG      := normal large xlarge tvdpi hdpi xhdpi xxhdpi
PRODUCT_AAPT_PREF_CONFIG ?= xhdpi
TARGET_CPU_SMP           := true

PRODUCT_COPY_FILES       += device/broadcom/common/bootanimation.zip:system/media/bootanimation.zip
PRODUCT_COPY_FILES       += device/broadcom/common/keylayout/nexus_silver_remote.kl:system/usr/keylayout/NexusIrHandler.kl
PRODUCT_COPY_FILES       += frameworks/av/media/libstagefright/data/media_codecs_google_audio.xml:system/etc/media_codecs_google_audio.xml
PRODUCT_COPY_FILES       += frameworks/av/media/libstagefright/data/media_codecs_google_video.xml:system/etc/media_codecs_google_video.xml
PRODUCT_COPY_FILES       += frameworks/av/media/libstagefright/data/media_codecs_google_tv.xml:system/etc/media_codecs_google_tv.xml
PRODUCT_COPY_FILES       += frameworks/native/data/etc/android.hardware.ethernet.xml:system/etc/permissions/android.hardware.ethernet.xml
PRODUCT_COPY_FILES       += frameworks/native/data/etc/android.hardware.hdmi.cec.xml:system/etc/permissions/android.hardware.hdmi.cec.xml
PRODUCT_COPY_FILES       += frameworks/native/data/etc/android.hardware.screen.landscape.xml:system/etc/permissions/android.hardware.screen.landscape.xml
PRODUCT_COPY_FILES       += frameworks/native/data/etc/android.hardware.usb.accessory.xml:system/etc/permissions/android.hardware.usb.accessory.xml
PRODUCT_COPY_FILES       += frameworks/native/data/etc/android.hardware.usb.host.xml:system/etc/permissions/android.hardware.usb.host.xml
PRODUCT_COPY_FILES       += frameworks/native/data/etc/android.software.live_tv.xml:system/etc/permissions/android.software.live_tv.xml
PRODUCT_COPY_FILES       += frameworks/native/data/etc/android.software.webview.xml:system/etc/permissions/android.software.webview.xml
PRODUCT_COPY_FILES       += device/broadcom/common/permissions/nrdp.xml:system/etc/permissions/nrdp.xml
PRODUCT_COPY_FILES       += ${BCM_VENDOR_STB_ROOT}/bcm_platform/nxif/libnexusir/irkeymap/broadcom_black.ikm:$(TARGET_COPY_OUT_VENDOR)/usr/irkeymap/broadcom_black.ikm
PRODUCT_COPY_FILES       += ${BCM_VENDOR_STB_ROOT}/bcm_platform/nxif/libnexusir/irkeymap/broadcom_silver.ikm:$(TARGET_COPY_OUT_VENDOR)/usr/irkeymap/broadcom_silver.ikm
PRODUCT_COPY_FILES       += ${BCM_VENDOR_STB_ROOT}/bcm_platform/hals/power/sopass.key:data/misc/nexus/sopass.key
PRODUCT_COPY_FILES       += frameworks/av/services/audiopolicy/config/r_submix_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/r_submix_audio_policy_configuration.xml
PRODUCT_COPY_FILES       += frameworks/av/services/audiopolicy/config/usb_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/usb_audio_policy_configuration.xml
PRODUCT_COPY_FILES       += frameworks/av/services/audiopolicy/config/audio_policy_volumes.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_policy_volumes.xml
PRODUCT_COPY_FILES       += frameworks/av/services/audiopolicy/config/default_volume_tables.xml:$(TARGET_COPY_OUT_VENDOR)/etc/default_volume_tables.xml
ifneq ($(filter usb uart,$(ANDROID_ENABLE_BT)),)
PRODUCT_COPY_FILES       += device/broadcom/common/media/audio_policy_btusb.conf:$(TARGET_COPY_OUT_VENDOR)/etc/audio_policy.conf
PRODUCT_COPY_FILES       += device/broadcom/common/media/audio_policy_btusb_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_policy_configuration.xml
PRODUCT_COPY_FILES       += frameworks/av/services/audiopolicy/config/a2dp_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/a2dp_audio_policy_configuration.xml
else
PRODUCT_COPY_FILES       += device/broadcom/common/media/audio_policy.conf:$(TARGET_COPY_OUT_VENDOR)/etc/audio_policy.conf
PRODUCT_COPY_FILES       += device/broadcom/common/media/audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_policy_configuration.xml
endif
PRODUCT_COPY_FILES       += device/broadcom/common/rcs/gps.conf:$(TARGET_COPY_OUT_VENDOR)/etc/gps.conf
# all those are defined per device, in the device configuration.
PRODUCT_COPY_FILES       += ${LOCAL_DEVICE_RCS}
PRODUCT_COPY_FILES       += ${LOCAL_DEVICE_MEDIA}
PRODUCT_COPY_FILES       += ${LOCAL_DEVICE_RECOVERY_RCS}
PRODUCT_COPY_FILES       += ${LOCAL_DEVICE_FSTAB}
PRODUCT_COPY_FILES       += ${LOCAL_DEVICE_AON_GPIO}
PRODUCT_COPY_FILES       += ${LOCAL_DEVICE_KEY_POLL}

PRODUCT_COPY_FILES       += ${BCM_VENDOR_STB_ROOT}/bcm_platform/nxif/libnexusir/irkeymap/humax_q02.ikm:$(TARGET_COPY_OUT_VENDOR)/usr/irkeymap/vendor_0001.ikm
PRODUCT_COPY_FILES       += ${BCM_VENDOR_STB_ROOT}/bcm_platform/nxif/libnexusir/irkeymap/directv_rc7x.ikm:$(TARGET_COPY_OUT_VENDOR)/usr/irkeymap/vendor_0002.ikm

ifneq ($(BCM_DIST_KNLIMG_BINS), y)
PRODUCT_COPY_FILES       += ${NEXUS_BIN_DIR_1ST_ARCH}/nx_ashmem.ko:$(TARGET_COPY_OUT_VENDOR)/lib/modules/nx_ashmem.ko
PRODUCT_COPY_FILES       += ${NEXUS_BIN_DIR_1ST_ARCH}/nexus.ko:$(TARGET_COPY_OUT_VENDOR)/lib/modules/nexus.ko
PRODUCT_COPY_FILES       += ${NEXUS_BIN_DIR_1ST_ARCH}/droid_pm.ko:$(TARGET_COPY_OUT_VENDOR)/lib/modules/droid_pm.ko
PRODUCT_COPY_FILES       += ${NEXUS_BIN_DIR_1ST_ARCH}/gator.ko:$(TARGET_COPY_OUT_VENDOR)/lib/modules/gator.ko
else
PRODUCT_COPY_FILES       += ${BCM_BINDIST_ROOT}/knlimg/${LOCAL_LINUX_VERSION_NODASH}/mods/$(TARGET_BOARD_PLATFORM)/nx_ashmem.ko:$(TARGET_COPY_OUT_VENDOR)/lib/modules/nx_ashmem.ko
PRODUCT_COPY_FILES       += ${BCM_BINDIST_ROOT}/knlimg/${LOCAL_LINUX_VERSION_NODASH}/mods/$(TARGET_BOARD_PLATFORM)/nexus.ko:$(TARGET_COPY_OUT_VENDOR)/lib/modules/nexus.ko
PRODUCT_COPY_FILES       += ${BCM_BINDIST_ROOT}/knlimg/${LOCAL_LINUX_VERSION_NODASH}/mods/$(TARGET_BOARD_PLATFORM)/droid_pm.ko:$(TARGET_COPY_OUT_VENDOR)/lib/modules/droid_pm.ko
endif

ifeq ($(SAGE_SUPPORT),y)
ifeq ($(SAGE_VERSION),2x)
SAGE_BINARY_EXT      ?= _dev
SAGE_BL_BINARY_PATH  ?= $(BSEAV_TOP)/lib/security/sage/bin/2x/$(BCHP_CHIP)$(BCHP_VER)
PRODUCT_COPY_FILES   += ${SAGE_BL_BINARY_PATH}/sage_bl${SAGE_BINARY_EXT}.bin:$(TARGET_COPY_OUT_VENDOR)/bin/sage_bl${SAGE_BINARY_EXT}.bin
SAGE_APP_BINARY_PATH ?= $(SAGE_BL_BINARY_PATH)/securemode$(SAGE_SECURE_MODE)
PRODUCT_COPY_FILES   += ${SAGE_APP_BINARY_PATH}/sage_os_app${SAGE_BINARY_EXT}.bin:$(TARGET_COPY_OUT_VENDOR)/bin/sage_os_app${SAGE_BINARY_EXT}.bin
else
ifeq ($(LOCAL_DEVICE_SAGE_DEV_N_PROD),y)
SAGE_BINARY_EXT      := _dev
SAGE_BL_BINARY_PATH  := $(BSEAV_TOP)/lib/security/sage/bin/$(BCHP_CHIP)$(BCHP_VER)/dev
PRODUCT_COPY_FILES   += ${SAGE_BL_BINARY_PATH}/sage_bl${SAGE_BINARY_EXT}.bin:$(TARGET_COPY_OUT_VENDOR)/bin/sage_bl${SAGE_BINARY_EXT}.bin
SAGE_APP_BINARY_PATH := $(SAGE_BL_BINARY_PATH)
PRODUCT_COPY_FILES   += ${SAGE_APP_BINARY_PATH}/sage_framework${SAGE_BINARY_EXT}.bin:$(TARGET_COPY_OUT_VENDOR)/bin/sage_framework${SAGE_BINARY_EXT}.bin
PRODUCT_COPY_FILES   += ${SAGE_APP_BINARY_PATH}/sage_ta_antirollback${SAGE_BINARY_EXT}.bin:$(TARGET_COPY_OUT_VENDOR)/bin/sage_ta_antirollback${SAGE_BINARY_EXT}.bin
PRODUCT_COPY_FILES   += ${SAGE_APP_BINARY_PATH}/sage_ta_hdcp22${SAGE_BINARY_EXT}.bin:$(TARGET_COPY_OUT_VENDOR)/bin/sage_ta_hdcp22${SAGE_BINARY_EXT}.bin
PRODUCT_COPY_FILES   += ${SAGE_APP_BINARY_PATH}/sage_ta_secure_video${SAGE_BINARY_EXT}.bin:$(TARGET_COPY_OUT_VENDOR)/bin/sage_ta_secure_video${SAGE_BINARY_EXT}.bin
PRODUCT_COPY_FILES   += ${SAGE_APP_BINARY_PATH}/sage_ta_utility${SAGE_BINARY_EXT}.bin:$(TARGET_COPY_OUT_VENDOR)/bin/sage_ta_utility${SAGE_BINARY_EXT}.bin
PRODUCT_COPY_FILES   += ${SAGE_APP_BINARY_PATH}/sage_ta_bp3${SAGE_BINARY_EXT}.bin:$(TARGET_COPY_OUT_VENDOR)/bin/sage_ta_bp3${SAGE_BINARY_EXT}.bin
ifeq ($(ANDROID_SUPPORTS_WIDEVINE),y)
PRODUCT_COPY_FILES   += ${SAGE_APP_BINARY_PATH}/sage_ta_widevine${SAGE_BINARY_EXT}.bin:$(TARGET_COPY_OUT_VENDOR)/bin/sage_ta_widevine${SAGE_BINARY_EXT}.bin
endif
PRODUCT_COPY_FILES   += ${SAGE_APP_BINARY_PATH}/sage_ta_manufacturing${SAGE_BINARY_EXT}.bin:$(TARGET_COPY_OUT_VENDOR)/bin/sage_ta_manufacturing${SAGE_BINARY_EXT}.bin
ifeq ($(ANDROID_SUPPORTS_PLAYREADY),y)
PRODUCT_COPY_FILES   += ${SAGE_APP_BINARY_PATH}/sage_ta_playready_25${SAGE_BINARY_EXT}.bin:$(TARGET_COPY_OUT_VENDOR)/bin/sage_ta_playready_25${SAGE_BINARY_EXT}.bin
PRODUCT_COPY_FILES   += ${SAGE_APP_BINARY_PATH}/sage_ta_playready_30${SAGE_BINARY_EXT}.bin:$(TARGET_COPY_OUT_VENDOR)/bin/sage_ta_playready_30${SAGE_BINARY_EXT}.bin
endif
SAGE_BINARY_EXT2      :=
SAGE_BL_BINARY_PATH2  := $(BSEAV_TOP)/lib/security/sage/bin/$(BCHP_CHIP)$(BCHP_VER)
PRODUCT_COPY_FILES    += ${SAGE_BL_BINARY_PATH2}/sage_bl${SAGE_BINARY_EXT2}.bin:$(TARGET_COPY_OUT_VENDOR)/bin/sage_bl${SAGE_BINARY_EXT2}.bin
SAGE_APP_BINARY_PATH2 := $(SAGE_BL_BINARY_PATH2)
PRODUCT_COPY_FILES    += ${SAGE_APP_BINARY_PATH2}/sage_framework${SAGE_BINARY_EXT2}.bin:$(TARGET_COPY_OUT_VENDOR)/bin/sage_framework${SAGE_BINARY_EXT2}.bin
PRODUCT_COPY_FILES    += ${SAGE_APP_BINARY_PATH2}/sage_ta_antirollback${SAGE_BINARY_EXT2}.bin:$(TARGET_COPY_OUT_VENDOR)/bin/sage_ta_antirollback${SAGE_BINARY_EXT2}.bin
PRODUCT_COPY_FILES    += ${SAGE_APP_BINARY_PATH2}/sage_ta_hdcp22${SAGE_BINARY_EXT2}.bin:$(TARGET_COPY_OUT_VENDOR)/bin/sage_ta_hdcp22${SAGE_BINARY_EXT2}.bin
PRODUCT_COPY_FILES    += ${SAGE_APP_BINARY_PATH2}/sage_ta_secure_video${SAGE_BINARY_EXT2}.bin:$(TARGET_COPY_OUT_VENDOR)/bin/sage_ta_secure_video${SAGE_BINARY_EXT2}.bin
PRODUCT_COPY_FILES    += ${SAGE_APP_BINARY_PATH2}/sage_ta_utility${SAGE_BINARY_EXT2}.bin:$(TARGET_COPY_OUT_VENDOR)/bin/sage_ta_utility${SAGE_BINARY_EXT2}.bin
PRODUCT_COPY_FILES    += ${SAGE_APP_BINARY_PATH2}/sage_ta_bp3${SAGE_BINARY_EXT2}.bin:$(TARGET_COPY_OUT_VENDOR)/bin/sage_ta_bp3${SAGE_BINARY_EXT2}.bin
ifeq ($(ANDROID_SUPPORTS_WIDEVINE),y)
PRODUCT_COPY_FILES    += ${SAGE_APP_BINARY_PATH2}/sage_ta_widevine${SAGE_BINARY_EXT2}.bin:$(TARGET_COPY_OUT_VENDOR)/bin/sage_ta_widevine${SAGE_BINARY_EXT2}.bin
endif
PRODUCT_COPY_FILES    += ${SAGE_APP_BINARY_PATH2}/sage_ta_manufacturing${SAGE_BINARY_EXT2}.bin:$(TARGET_COPY_OUT_VENDOR)/bin/sage_ta_manufacturing${SAGE_BINARY_EXT2}.bin
ifeq ($(ANDROID_SUPPORTS_PLAYREADY),y)
PRODUCT_COPY_FILES    += ${SAGE_APP_BINARY_PATH2}/sage_ta_playready_25${SAGE_BINARY_EXT2}.bin:$(TARGET_COPY_OUT_VENDOR)/bin/sage_ta_playready_25${SAGE_BINARY_EXT2}.bin
PRODUCT_COPY_FILES    += ${SAGE_APP_BINARY_PATH2}/sage_ta_playready_30${SAGE_BINARY_EXT2}.bin:$(TARGET_COPY_OUT_VENDOR)/bin/sage_ta_playready_30${SAGE_BINARY_EXT2}.bin
endif
else
SAGE_BINARY_EXT      ?= _dev
SAGE_BL_BINARY_PATH  ?= $(BSEAV_TOP)/lib/security/sage/bin/$(BCHP_CHIP)$(BCHP_VER)/dev
PRODUCT_COPY_FILES   += ${SAGE_BL_BINARY_PATH}/sage_bl${SAGE_BINARY_EXT}.bin:$(TARGET_COPY_OUT_VENDOR)/bin/sage_bl${SAGE_BINARY_EXT}.bin
SAGE_APP_BINARY_PATH ?= $(SAGE_BL_BINARY_PATH)
PRODUCT_COPY_FILES   += ${SAGE_APP_BINARY_PATH}/sage_framework${SAGE_BINARY_EXT}.bin:$(TARGET_COPY_OUT_VENDOR)/bin/sage_framework${SAGE_BINARY_EXT}.bin
PRODUCT_COPY_FILES   += ${SAGE_APP_BINARY_PATH}/sage_ta_antirollback${SAGE_BINARY_EXT}.bin:$(TARGET_COPY_OUT_VENDOR)/bin/sage_ta_antirollback${SAGE_BINARY_EXT}.bin
PRODUCT_COPY_FILES   += ${SAGE_APP_BINARY_PATH}/sage_ta_hdcp22${SAGE_BINARY_EXT}.bin:$(TARGET_COPY_OUT_VENDOR)/bin/sage_ta_hdcp22${SAGE_BINARY_EXT}.bin
PRODUCT_COPY_FILES   += ${SAGE_APP_BINARY_PATH}/sage_ta_secure_video${SAGE_BINARY_EXT}.bin:$(TARGET_COPY_OUT_VENDOR)/bin/sage_ta_secure_video${SAGE_BINARY_EXT}.bin
PRODUCT_COPY_FILES   += ${SAGE_APP_BINARY_PATH}/sage_ta_utility${SAGE_BINARY_EXT}.bin:$(TARGET_COPY_OUT_VENDOR)/bin/sage_ta_utility${SAGE_BINARY_EXT}.bin
PRODUCT_COPY_FILES   += ${SAGE_APP_BINARY_PATH}/sage_ta_bp3${SAGE_BINARY_EXT}.bin:$(TARGET_COPY_OUT_VENDOR)/bin/sage_ta_bp3${SAGE_BINARY_EXT}.bin
ifeq ($(ANDROID_SUPPORTS_WIDEVINE),y)
PRODUCT_COPY_FILES   += ${SAGE_APP_BINARY_PATH}/sage_ta_widevine${SAGE_BINARY_EXT}.bin:$(TARGET_COPY_OUT_VENDOR)/bin/sage_ta_widevine${SAGE_BINARY_EXT}.bin
endif
PRODUCT_COPY_FILES   += ${SAGE_APP_BINARY_PATH}/sage_ta_manufacturing${SAGE_BINARY_EXT}.bin:$(TARGET_COPY_OUT_VENDOR)/bin/sage_ta_manufacturing${SAGE_BINARY_EXT}.bin
ifeq ($(ANDROID_SUPPORTS_PLAYREADY),y)
PRODUCT_COPY_FILES   += ${SAGE_APP_BINARY_PATH}/sage_ta_playready_25${SAGE_BINARY_EXT}.bin:$(TARGET_COPY_OUT_VENDOR)/bin/sage_ta_playready_25${SAGE_BINARY_EXT}.bin
PRODUCT_COPY_FILES   += ${SAGE_APP_BINARY_PATH}/sage_ta_playready_30${SAGE_BINARY_EXT}.bin:$(TARGET_COPY_OUT_VENDOR)/bin/sage_ta_playready_30${SAGE_BINARY_EXT}.bin
endif
endif
endif
endif

ifneq ($(HW_WIFI_SUPPORT),n)
ifeq ($(HW_WIFI_NIC_SUPPORT),y)
$(call inherit-product-if-exists, device/broadcom/common/connectivity/bcmnic-device.mk)
else
ifeq ($(HW_WIFI_NIC_DUAL_SUPPORT),y)
$(call inherit-product-if-exists, device/broadcom/common/connectivity/bcmnic-dual-device.mk)
else
$(call inherit-product-if-exists, device/broadcom/common/connectivity/bcmdhd-device.mk)
endif
endif
endif
ifneq ($(filter usb uart,$(ANDROID_ENABLE_BT)),)
$(call inherit-product-if-exists, device/broadcom/common/connectivity/bcmbt-device.mk)
endif

$(call inherit-product-if-exist, $(LOCAL_DEVICE_REFERENCE_BUILD))
$(call inherit-product, frameworks/native/build/tablet-10in-xhdpi-2048-dalvik-heap.mk)

ifeq ($(LOCAL_DEVICE_USE_VERITY),y)
$(call inherit-product, build/target/product/verity.mk)
PRODUCT_SUPPORTS_BOOT_SIGNER    := false
PRODUCT_SYSTEM_VERITY_PARTITION := $(LOCAL_DEVICE_SYSTEM_VERITY_PARTITION)
ifneq ($(LOCAL_NVI_LAYOUT),y)
PRODUCT_VENDOR_VERITY_PARTITION := $(LOCAL_DEVICE_VENDOR_VERITY_PARTITION)
endif
RODUCT_PACKAGES                 += slideshow verity_warning_images
PRODUCT_COPY_FILES              += frameworks/native/data/etc/android.software.verified_boot.xml:system/etc/permissions/android.software.verified_boot.xml
endif

# packages for the system image content.
PRODUCT_PACKAGES += \
    wpa_supplicant \
    dhcpcd.conf \
    wificond

ifeq ($(wildcard ${GMS_PACKAGE_ROOT}/google/Android.mk),)
PRODUCT_PACKAGES += \
   Browser \
   Calculator \
   Camera2 \
   Contacts \
   Clock \
   DeskClock \
   DevTools \
   DocumentsUI \
   DownloadProviderUi \
   Gallery2 \
   Launcher3 \
   Music \
   QuickSearchBox \
   LatinIME

ifneq ($(wildcard device/google/atv/permissions/tv_core_hardware.xml),)
PRODUCT_PACKAGES += \
   BcmTvSettingsLauncher
else
PRODUCT_PACKAGES += \
   Settings
endif
endif

PRODUCT_PACKAGES += \
    e2fsck \
    gatord \
    gptbin \
    hfrvideo \
    makehwcfg \
    netcoal \
    nxdispfmt \
    nxlogger \
    nxserver \
    togplm

# device supported hal's.
PRODUCT_PACKAGES += \
    audio.primary.$(TARGET_BOARD_PLATFORM) \
    bootctrl.$(TARGET_BOARD_PLATFORM) \
    gralloc.$(TARGET_BOARD_PLATFORM) \
    hdmi_cec.$(TARGET_BOARD_PLATFORM) \
    hwcomposer.$(TARGET_BOARD_PLATFORM) \
    lights.$(TARGET_BOARD_PLATFORM) \
    memtrack.$(TARGET_BOARD_PLATFORM) \
    power.$(TARGET_BOARD_PLATFORM) \
    thermal.$(TARGET_BOARD_PLATFORM) \
    tv_input.$(TARGET_BOARD_PLATFORM)

PRODUCT_PACKAGES += \
   android.hardware.audio@2.0-impl \
   android.hardware.audio.effect@2.0-impl \
   android.hardware.bluetooth@1.0-impl \
   android.hardware.drm@1.0-impl \
   android.hardware.graphics.allocator@2.0-impl \
   android.hardware.graphics.allocator@2.0-service \
   android.hardware.graphics.bufferqueue@1.0 \
   android.hardware.graphics.common@1.0 \
   android.hardware.graphics.composer@2.1-impl \
   android.hardware.graphics.mapper@2.0-impl \
   android.hardware.keymaster@3.0-impl \
   android.hardware.light@2.0-impl \
   android.hardware.memtrack@1.0-impl \
   android.hardware.power@1.0-impl \
   android.hardware.thermal@1.0-impl \
   android.hardware.tv.input@1.0-impl \
   android.hardware.tv.cec@1.0-impl \
   android.hardware.usb@1.0-service

ifneq ($(HW_AB_UPDATE_SUPPORT),n)
PRODUCT_PACKAGES += \
   android.hardware.boot@1.0-impl
endif

ifneq ($(HW_WIFI_SUPPORT),n)
PRODUCT_PACKAGES += \
   android.hardware.wifi@1.0 \
   android.hardware.wifi.supplicant@1.0
endif

PRODUCT_PACKAGES += \
    audio.usb.default \
    audio.r_submix.default \
    libaudiopolicymanagerdefault \
    libaudiopolicymanager \
    libbt-vendor \
    hwcbinder \
    libhwcbinder \
    libhwcconv \
    libGLES_nexus \
    libnexusir \
    libpmlibservice \
    libstagefrighthw \
    pmlibserver \
    send_cec \
    TvProvider

# bcm custom test apps, can be compiled out.
ifeq ($(BCM_APP_CUSTOM),y)
PRODUCT_PACKAGES += \
    BcmAdjustScreenOffset \
    BcmCustomizer \
    BcmHdmiTvInput \
    BcmSidebandViewer \
    BcmTVInput
else
PRODUCT_PACKAGES += \
    BcmCustomizerBase
endif

PRODUCT_PACKAGES += \
    BcmPlayAutoInstallConfig

ifneq ($(filter $(ANDROID_SUPPORTS_WIDEVINE) $(ANDROID_SUPPORTS_PLAYREADY),y),)
PRODUCT_PROPERTY_OVERRIDES  += drm.service.enabled=true
PRODUCT_PACKAGES            += libbcrypt libdrmrootfs libcmndrm libcmndrm_tl libsrai
ifeq ($(ANDROID_SUPPORTS_WIDEVINE),y)
PRODUCT_PACKAGES            += liboemcrypto libwvdrmengine
endif
ifeq ($(ANDROID_SUPPORTS_PLAYREADY),y)
PRODUCT_PACKAGES            += libcmndrmprdy libplayreadydrmplugin libplayreadypk_host libplayready30pk
endif
endif

ifeq ($(HW_AB_UPDATE_SUPPORT),y)
PRODUCT_PACKAGES            += update_engine update_engine_client update_verifier
endif

$(call inherit-product-if-exists, ${BCM_VENDOR_STB_ROOT}/bcm_platform/device-vendor.mk)
