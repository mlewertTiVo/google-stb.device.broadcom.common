ifeq ($(LOCAL_ARM_AARCH64),y)
ifneq ($(LOCAL_ARM_AARCH64_NOT_ABI_COMPATIBLE),y)
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)
endif
endif

$(call inherit-product, $(SRC_TARGET_DIR)/product/core_minimal.mk)
$(call inherit-product-if-exists, frameworks/webview/chromium/chromium.mk)
$(call inherit-product-if-exists, frameworks/base/data/fonts/fonts.mk)
$(call inherit-product-if-exists, external/roboto-fonts/fonts.mk)

include device/broadcom/common/settings.mk
include device/broadcom/common/middleware/definitions.mk

ifeq ($(TARGET_BUILD_VARIANT),user)
export B_REFSW_DEBUG ?= n
export B_REFSW_DEBUG_LEVEL :=
else
export B_REFSW_DEBUG ?= y
export B_REFSW_DEBUG_LEVEL := msg
export NEXUS_EXTRA_CFLAGS := -DNEXUS_P_TRACE=1 -DNEXUS_P_SYNC_TRACE=1
endif

PRODUCT_LOCALES         := en_US
PRODUCT_CHARACTERISTICS := tv
PRODUCT_MANUFACTURER    := broadcom

DEVICE_PACKAGE_OVERLAYS := device/broadcom/common/overlay
ifneq ($(LOCAL_DEVICE_OVERLAY),)
DEVICE_PACKAGE_OVERLAYS := $(LOCAL_DEVICE_OVERLAY) $(DEVICE_PACKAGE_OVERLAYS)
endif

PRODUCT_AAPT_CONFIG      := normal large xlarge tvdpi hdpi xhdpi xxhdpi
PRODUCT_AAPT_PREF_CONFIG := xhdpi
TARGET_CPU_SMP           := true

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
PRODUCT_COPY_FILES       += ${NEXUS_BIN_DIR_1ST_ARCH}/nx_ashmem.ko:vendor/lib/modules/nx_ashmem.ko
PRODUCT_COPY_FILES       += ${NEXUS_BIN_DIR_1ST_ARCH}/nexus.ko:vendor/lib/modules/nexus.ko
PRODUCT_COPY_FILES       += ${NEXUS_BIN_DIR_1ST_ARCH}/droid_pm.ko:vendor/lib/modules/droid_pm.ko
PRODUCT_COPY_FILES       += ${NEXUS_BIN_DIR_1ST_ARCH}/gator.ko:vendor/lib/modules/gator.ko
PRODUCT_COPY_FILES       += ${BCM_VENDOR_STB_ROOT}/bcm_platform/nxif/libnexusir/irkeymap/broadcom_black.ikm:system/usr/irkeymap/broadcom_black.ikm
PRODUCT_COPY_FILES       += ${BCM_VENDOR_STB_ROOT}/bcm_platform/nxif/libnexusir/irkeymap/broadcom_silver.ikm:system/usr/irkeymap/broadcom_silver.ikm
PRODUCT_COPY_FILES       += ${BCM_VENDOR_STB_ROOT}/bcm_platform/hals/power/sopass.key:data/misc/nexus/sopass.key
PRODUCT_COPY_FILES       += frameworks/av/services/audiopolicy/config/r_submix_audio_policy_configuration.xml:system/etc/r_submix_audio_policy_configuration.xml
PRODUCT_COPY_FILES       += frameworks/av/services/audiopolicy/config/usb_audio_policy_configuration.xml:system/etc/usb_audio_policy_configuration.xml
PRODUCT_COPY_FILES       += frameworks/av/services/audiopolicy/config/audio_policy_volumes.xml:system/etc/audio_policy_volumes.xml
PRODUCT_COPY_FILES       += frameworks/av/services/audiopolicy/config/default_volume_tables.xml:system/etc/default_volume_tables.xml
ifneq ($(filter usb uart,$(ANDROID_ENABLE_BT)),)
PRODUCT_COPY_FILES       += device/broadcom/common/media/audio_policy_btusb.conf:system/etc/audio_policy.conf
PRODUCT_COPY_FILES       += device/broadcom/common/media/audio_policy_btusb_configuration.xml:system/etc/audio_policy_configuration.xml
PRODUCT_COPY_FILES       += frameworks/av/services/audiopolicy/config/a2dp_audio_policy_configuration.xml:system/etc/a2dp_audio_policy_configuration.xml
else
PRODUCT_COPY_FILES       += device/broadcom/common/media/audio_policy.conf:system/etc/audio_policy.conf
PRODUCT_COPY_FILES       += device/broadcom/common/media/audio_policy_configuration.xml:system/etc/audio_policy_configuration.xml
endif
PRODUCT_COPY_FILES       += device/broadcom/common/rcs/gps.conf:system/etc/gps.conf
PRODUCT_COPY_FILES       += system/core/rootdir/init.zygote32.rc:root/init.zygote32.rc
# all those are defined per device, in the device configuration.
PRODUCT_COPY_FILES       += ${LOCAL_DEVICE_RCS}
PRODUCT_COPY_FILES       += ${LOCAL_DEVICE_MEDIA}
PRODUCT_COPY_FILES       += ${LOCAL_DEVICE_RECOVERY_RCS}
PRODUCT_COPY_FILES       += ${LOCAL_DEVICE_FSTAB}
PRODUCT_COPY_FILES       += ${LOCAL_DEVICE_AON_GPIO}
PRODUCT_COPY_FILES       += ${LOCAL_DEVICE_KEY_POLL}

ifeq ($(SAGE_SUPPORT),y)
ifeq ($(SAGE_VERSION),2x)
SAGE_BL_BINARY_PATH  := $(BSEAV_TOP)/lib/security/sage/bin/2x/$(BCHP_CHIP)$(BCHP_VER)
PRODUCT_COPY_FILES   += ${SAGE_BL_BINARY_PATH}/sage_bl.bin:system/bin/sage_bl.bin
PRODUCT_COPY_FILES   += ${SAGE_BL_BINARY_PATH}/sage_bl_dev.bin:system/bin/sage_bl_dev.bin
SAGE_APP_BINARY_PATH := $(SAGE_BL_BINARY_PATH)/securemode$(SAGE_SECURE_MODE)
PRODUCT_COPY_FILES   += ${SAGE_APP_BINARY_PATH}/sage_os_app.bin:system/bin/sage_os_app.bin
PRODUCT_COPY_FILES   += ${SAGE_APP_BINARY_PATH}/sage_os_app_dev.bin:system/bin/sage_os_app_dev.bin
else
SAGE_BL_BINARY_PATH  := $(BSEAV_TOP)/lib/security/sage/bin/$(BCHP_CHIP)$(BCHP_VER)
PRODUCT_COPY_FILES   += ${SAGE_BL_BINARY_PATH}/sage_bl.bin:system/bin/sage_bl.bin
PRODUCT_COPY_FILES   += ${SAGE_BL_BINARY_PATH}/dev/sage_bl_dev.bin:system/bin/sage_bl_dev.bin
SAGE_APP_BINARY_PATH := $(SAGE_BL_BINARY_PATH)
PRODUCT_COPY_FILES   += ${SAGE_APP_BINARY_PATH}/sage_framework.bin:system/bin/sage_framework.bin
PRODUCT_COPY_FILES   += ${SAGE_APP_BINARY_PATH}/sage_ta_antirollback.bin:system/bin/sage_ta_antirollback.bin
PRODUCT_COPY_FILES   += ${SAGE_APP_BINARY_PATH}/sage_ta_adobe.bin:system/bin/sage_ta_adobe.bin
PRODUCT_COPY_FILES   += ${SAGE_APP_BINARY_PATH}/sage_ta_dtcpip.bin:system/bin/sage_ta_dtcpip.bin
PRODUCT_COPY_FILES   += ${SAGE_APP_BINARY_PATH}/sage_ta_edrm.bin:system/bin/sage_ta_edrm.bin
PRODUCT_COPY_FILES   += ${SAGE_APP_BINARY_PATH}/sage_ta_hdcp22.bin:system/bin/sage_ta_hdcp22.bin
PRODUCT_COPY_FILES   += ${SAGE_APP_BINARY_PATH}/sage_ta_netflix.bin:system/bin/sage_ta_netflix.bin
PRODUCT_COPY_FILES   += ${SAGE_APP_BINARY_PATH}/sage_ta_secure_video.bin:system/bin/sage_ta_secure_video.bin
PRODUCT_COPY_FILES   += ${SAGE_APP_BINARY_PATH}/sage_ta_utility.bin:system/bin/sage_ta_utility.bin
PRODUCT_COPY_FILES   += ${SAGE_APP_BINARY_PATH}/sage_ta_widevine.bin:system/bin/sage_ta_widevine.bin
PRODUCT_COPY_FILES   += ${SAGE_APP_BINARY_PATH}/dev/sage_framework_dev.bin:system/bin/sage_framework_dev.bin
PRODUCT_COPY_FILES   += ${SAGE_APP_BINARY_PATH}/dev/sage_ta_adobe_dev.bin:system/bin/sage_ta_adobe_dev.bin
PRODUCT_COPY_FILES   += ${SAGE_APP_BINARY_PATH}/dev/sage_ta_antirollback_dev.bin:system/bin/sage_ta_antirollback_dev.bin
PRODUCT_COPY_FILES   += ${SAGE_APP_BINARY_PATH}/dev/sage_ta_dtcpip_dev.bin:system/bin/sage_ta_dtcpip_dev.bin
PRODUCT_COPY_FILES   += ${SAGE_APP_BINARY_PATH}/dev/sage_ta_edrm_dev.bin:system/bin/sage_ta_edrm_dev.bin
PRODUCT_COPY_FILES   += ${SAGE_APP_BINARY_PATH}/dev/sage_ta_hdcp22_dev.bin:system/bin/sage_ta_hdcp22_dev.bin
PRODUCT_COPY_FILES   += ${SAGE_APP_BINARY_PATH}/dev/sage_ta_netflix_dev.bin:system/bin/sage_ta_netflix_dev.bin
PRODUCT_COPY_FILES   += ${SAGE_APP_BINARY_PATH}/dev/sage_ta_secure_video_dev.bin:system/bin/sage_ta_secure_video_dev.bin
PRODUCT_COPY_FILES   += ${SAGE_APP_BINARY_PATH}/dev/sage_ta_utility_dev.bin:system/bin/sage_ta_utility_dev.bin
PRODUCT_COPY_FILES   += ${SAGE_APP_BINARY_PATH}/dev/sage_ta_widevine_dev.bin:system/bin/sage_ta_widevine_dev.bin
ifeq ($(ANDROID_SUPPORTS_PLAYREADY),y)
PRODUCT_COPY_FILES   += ${SAGE_APP_BINARY_PATH}/sage_ta_playready_25.bin:system/bin/sage_ta_playready_25.bin
PRODUCT_COPY_FILES   += ${SAGE_APP_BINARY_PATH}/sage_ta_playready_30.bin:system/bin/sage_ta_playready_30.bin
PRODUCT_COPY_FILES   += ${SAGE_APP_BINARY_PATH}/dev/sage_ta_playready_25_dev.bin:system/bin/sage_ta_playready_25_dev.bin
PRODUCT_COPY_FILES   += ${SAGE_APP_BINARY_PATH}/dev/sage_ta_playready_30_dev.bin:system/bin/sage_ta_playready_30_dev.bin
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

# packages for the system image content.
PRODUCT_PACKAGES += \
    wpa_supplicant \
    dhcpcd.conf

PRODUCT_PACKAGES += \
    busybox \
    e2fsck \
    gatord \
    gptbin \
    hfrvideo \
    makehwcfg \
    netcoal \
    nxdispfmt \
    nxlogger \
    nxserver

# device supported hal's.
PRODUCT_PACKAGES += \
    audio.primary.$(TARGET_BOARD_PLATFORM) \
    bootctrl.$(TARGET_BOARD_PLATFORM) \
    camera.$(TARGET_BOARD_PLATFORM) \
    gralloc.$(TARGET_BOARD_PLATFORM) \
    hdmi_cec.$(TARGET_BOARD_PLATFORM) \
    hwcomposer.$(TARGET_BOARD_PLATFORM) \
    memtrack.$(TARGET_BOARD_PLATFORM) \
    power.$(TARGET_BOARD_PLATFORM) \
    tv_input.$(TARGET_BOARD_PLATFORM)

PRODUCT_PACKAGES += \
    audio.primary.default \
    audio_policy.default \
    audio.usb.default \
    audio.r_submix.default \
    audio.atvr.default \
    libaudiopolicymanagerdefault \
    libaudiopolicymanager \
    BcmKeyInterceptor \
    BcmOtaUpdater \
    BcmSplash \
    hwcbinder \
    libhwcbinder \
    libhwcconv \
    libjni_adjustScreenOffset \
    libGLES_nexus \
    libnexusir \
    libpmlibservice \
    libstagefright_bcm \
    libstagefrighthw \
    local_time.default \
    pmlibserver \
    power.default \
    send_cec

ifneq ($(filter $(ANDROID_SUPPORTS_WIDEVINE) $(ANDROID_SUPPORTS_PLAYREADY),y),)
PRODUCT_PROPERTY_OVERRIDES  += drm.service.enabled=true
PRODUCT_PACKAGES            += libbcrypt libdrmrootfs libcmndrm libcmndrm_tl libsrai
ifeq ($(ANDROID_SUPPORTS_WIDEVINE),y)
PRODUCT_PACKAGES            += liboemcrypto libwvdrmengine
endif
ifeq ($(ANDROID_SUPPORTS_PLAYREADY),y)
PRODUCT_PACKAGES            += libcmndrmprdy libplayreadydrmplugin libplayreadypk_host
endif
endif

$(call inherit-product-if-exists, ${BCM_VENDOR_STB_ROOT}/bcm_platform/device-vendor.mk)

