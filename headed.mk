ifeq ($(LOCAL_ARM_AARCH64),y)
ifneq ($(LOCAL_ARM_AARCH64_NOT_ABI_COMPATIBLE),y)
ifneq ($(LOCAL_ARM_AARCH64_COMPAT_32_BIT),y)
ifeq ($(LOCAL_ANDROID_64BIT_ONLY),y)
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit_only.mk)
else
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)
endif
endif
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

# prior to android-p
$(call inherit-product-if-exists, $(SRC_TARGET_DIR)/product/locales_full.mk)
# android-p onward
$(call inherit-product-if-exists, $(SRC_TARGET_DIR)/product/languages_full.mk)

$(call inherit-product, device/google/atv/products/atv_base.mk)
include device/broadcom/common/settings.mk
$(call inherit-product-if-exists, ${GMS_PACKAGE_ROOT}/google/products/gms.mk)
include device/broadcom/common/middleware/definitions.mk

ifneq ($(BCM_DIST_KNLIMG_BINS),y)
export B_REFSW_DEBUG       ?= y
ifeq ($(TARGET_BUILD_VARIANT),user)
export B_REFSW_DEBUG_LEVEL := wrn
else
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
PRODUCT_COPY_FILES       += device/broadcom/common/keylayout/nexus_silver_remote.kl:$(TARGET_COPY_OUT_VENDOR)/usr/keylayout/NexusIrHandler.kl
PRODUCT_COPY_FILES       += device/broadcom/common/keylayout/Smart_Remote_S.kl:$(TARGET_COPY_OUT_VENDOR)/usr/keylayout/Smart_Remote_S.kl
PRODUCT_COPY_FILES       += device/broadcom/common/keylayout/ARRIS_RCU.kl:$(TARGET_COPY_OUT_VENDOR)/usr/keylayout/ARRIS_RCU.kl
ifeq ($(LOCAL_DOLBY_SUPPORT),y)
PRODUCT_COPY_FILES       += device/broadcom/common/media/media_codecs_frag_dolby.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_dolby.xml
else
PRODUCT_COPY_FILES       += device/broadcom/common/media/media_codecs_frag_empty.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_dolby.xml
endif
ifeq ($(LOCAL_DEVICE_MEDIA_NO_HW_AUDIO),y)
PRODUCT_COPY_FILES       += frameworks/av/media/libstagefright/data/media_codecs_google_audio.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_google_audio.xml
else
PRODUCT_COPY_FILES       += device/broadcom/common/media/media_codecs_google_audio_no_aac.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_google_audio.xml
endif
PRODUCT_COPY_FILES       += frameworks/av/media/libstagefright/data/media_codecs_google_video_le.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_google_video.xml
PRODUCT_COPY_FILES       += frameworks/av/media/libstagefright/data/media_codecs_google_tv.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_google_tv.xml
PRODUCT_COPY_FILES       += frameworks/native/data/etc/android.hardware.ethernet.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.ethernet.xml
PRODUCT_COPY_FILES       += frameworks/native/data/etc/android.hardware.hdmi.cec.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.hdmi.cec.xml
PRODUCT_COPY_FILES       += frameworks/native/data/etc/android.hardware.screen.landscape.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.screen.landscape.xml
PRODUCT_COPY_FILES       += frameworks/native/data/etc/android.hardware.usb.host.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.usb.host.xml
PRODUCT_COPY_FILES       += frameworks/native/data/etc/android.software.live_tv.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.live_tv.xml
PRODUCT_COPY_FILES       += frameworks/native/data/etc/android.software.webview.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.webview.xml
ifeq ($(HW_GPU_VULKAN_SUPPORT),y)
PRODUCT_COPY_FILES       += frameworks/native/data/etc/android.hardware.vulkan.level-0.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.vulkan.level-0.xml
PRODUCT_COPY_FILES       += frameworks/native/data/etc/android.hardware.vulkan.version-1_0_3.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.vulkan.version-1_0_3.xml
endif
ifeq ($(HW_CAMERA_SUPPORT),y)
PRODUCT_COPY_FILES       += frameworks/native/data/etc/android.hardware.camera.external.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.external.xml
PRODUCT_COPY_FILES       += device/broadcom/common/media/external_camera_config.xml:$(TARGET_COPY_OUT_VENDOR)/etc/external_camera_config.xml
endif
PRODUCT_COPY_FILES       += device/broadcom/common/permissions/atv-bcm.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/atv-bcm.xml
PRODUCT_COPY_FILES       += device/broadcom/common/jwl:$(TARGET_COPY_OUT_VENDOR)/usr/jwl
ifneq ($(HW_THERMAL_CONFIG_SUPPORT),n)
PRODUCT_COPY_FILES       += device/broadcom/common/thermal/thermal.default.cfg:$(TARGET_COPY_OUT_VENDOR)/usr/thermal/default.cfg
endif
PRODUCT_COPY_FILES       += device/broadcom/common/idc/Smart_Remote_S.idc:$(TARGET_COPY_OUT_VENDOR)/usr/idc/Smart_Remote_S.idc
PRODUCT_COPY_FILES       += device/broadcom/common/idc/ARRIS_RCU.idc:$(TARGET_COPY_OUT_VENDOR)/usr/idc/ARRIS_RCU.idc
PRODUCT_COPY_FILES       += device/broadcom/common/idc/virtual-remote.idc:$(TARGET_COPY_OUT_VENDOR)/usr/idc/virtual-remote.idc
PRODUCT_COPY_FILES       += ${BCM_VENDOR_STB_ROOT}/bcm_platform/nxif/libnexusir/irkeymap/broadcom_black.ikm:$(TARGET_COPY_OUT_VENDOR)/usr/irkeymap/broadcom_black.ikm
PRODUCT_COPY_FILES       += ${BCM_VENDOR_STB_ROOT}/bcm_platform/nxif/libnexusir/irkeymap/broadcom_silver.ikm:$(TARGET_COPY_OUT_VENDOR)/usr/irkeymap/broadcom_silver.ikm
PRODUCT_COPY_FILES       += ${BCM_VENDOR_STB_ROOT}/bcm_platform/hals/power/sopass.key:$(TARGET_COPY_OUT_VENDOR)/usr/sopass
PRODUCT_COPY_FILES       += frameworks/av/services/audiopolicy/config/r_submix_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/r_submix_audio_policy_configuration.xml
PRODUCT_COPY_FILES       += frameworks/av/services/audiopolicy/config/usb_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/usb_audio_policy_configuration.xml
PRODUCT_COPY_FILES       += frameworks/av/services/audiopolicy/config/audio_policy_volumes.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_policy_volumes.xml
PRODUCT_COPY_FILES       += frameworks/av/services/audiopolicy/config/default_volume_tables.xml:$(TARGET_COPY_OUT_VENDOR)/etc/default_volume_tables.xml
PRODUCT_COPY_FILES       += frameworks/av/media/libeffects/data/audio_effects.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_effects.xml
ifneq ($(filter usb uart,$(ANDROID_ENABLE_BT)),)
PRODUCT_COPY_FILES       += device/broadcom/common/media/audio_policy_btusb.conf:$(TARGET_COPY_OUT_VENDOR)/etc/audio_policy.conf
ifeq ($(LOCAL_DEVICE_MSD_SUPPORT),y)
PRODUCT_COPY_FILES       += device/broadcom/common/media/audio_policy_btusb_msd_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_policy_configuration.xml
else
PRODUCT_COPY_FILES       += device/broadcom/common/media/audio_policy_btusb_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_policy_configuration.xml
endif
PRODUCT_COPY_FILES       += frameworks/av/services/audiopolicy/config/a2dp_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/a2dp_audio_policy_configuration.xml
else
PRODUCT_COPY_FILES       += device/broadcom/common/media/audio_policy.conf:$(TARGET_COPY_OUT_VENDOR)/etc/audio_policy.conf
ifeq ($(LOCAL_DEVICE_MSD_SUPPORT),y)
PRODUCT_COPY_FILES       += device/broadcom/common/media/audio_policy_msd_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_policy_configuration.xml
else
PRODUCT_COPY_FILES       += device/broadcom/common/media/audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_policy_configuration.xml
endif
endif
PRODUCT_COPY_FILES       += device/broadcom/common/rcs/gps.conf:$(TARGET_COPY_OUT_VENDOR)/etc/gps.conf
# all those are defined per device, in the device configuration.
PRODUCT_COPY_FILES       += ${LOCAL_DEVICE_RCS}

ifneq ($(LOCAL_DEVICE_PAK_BINARY_PROD),)
PRODUCT_COPY_FILES       += device/broadcom/common/pak/$(LOCAL_DEVICE_PAK_BINARY_PROD):$(TARGET_COPY_OUT_VENDOR)/usr/pak/pak.bin
endif
ifneq ($(LOCAL_DEVICE_PAK_BINARY_DEV),)
PRODUCT_COPY_FILES       += device/broadcom/common/pak/$(LOCAL_DEVICE_PAK_BINARY_DEV):$(TARGET_COPY_OUT_VENDOR)/usr/pak/pak_dev.bin
endif

COPY_2_VENDOR  ?= y
ifneq ($(HW_AB_UPDATE_SUPPORT),y)
ifeq ($(LOCAL_NVI_LAYOUT),y)
COPY_2_VENDOR := n
endif
endif
ifneq ($(COPY_2_VENDOR),n)
PRODUCT_COPY_FILES       += device/broadcom/common/rcs/rts/init.rts_$(LOCAL_DEVICE_RTS_MODE).rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/init.rts.rc
else
PRODUCT_COPY_FILES       += device/broadcom/common/rcs/rts/init.rts_$(LOCAL_DEVICE_RTS_MODE).rc:root/init.rts.rc
endif
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
ifeq ($(HW_DVB_SUPPORT),y)
PRODUCT_COPY_FILES       += ${NEXUS_BIN_DIR_1ST_ARCH}/ldvbon.ko:$(TARGET_COPY_OUT_VENDOR)/lib/modules/ldvbon.ko
endif
ifeq ($(LOCAL_GATOR_SUPPORT), y)
PRODUCT_COPY_FILES       += ${NEXUS_BIN_DIR_1ST_ARCH}/gator.ko:$(TARGET_COPY_OUT_VENDOR)/lib/modules/gator.ko
endif
ifeq ($(LOCAL_ARM_TRUSTZONE_USE), y)
PRODUCT_COPY_FILES       += ${NEXUS_BIN_DIR_1ST_ARCH}/bcm_astra.ko:$(TARGET_COPY_OUT_VENDOR)/lib/modules/tee.ko
PRODUCT_COPY_FILES       += ${NEXUS_BIN_DIR_1ST_ARCH}/swxpt.elf:$(TARGET_COPY_OUT_VENDOR)/usr/tee/swxpt.elf
endif
else
PRODUCT_COPY_FILES       += ${BCM_BINDIST_KNL_ROOT}/nx_ashmem.ko:$(TARGET_COPY_OUT_VENDOR)/lib/modules/nx_ashmem.ko
PRODUCT_COPY_FILES       += ${BCM_BINDIST_KNL_ROOT}/nexus.ko:$(TARGET_COPY_OUT_VENDOR)/lib/modules/nexus.ko
PRODUCT_COPY_FILES       += ${BCM_BINDIST_KNL_ROOT}/droid_pm.ko:$(TARGET_COPY_OUT_VENDOR)/lib/modules/droid_pm.ko
ifeq ($(HW_DVB_SUPPORT),y)
PRODUCT_COPY_FILES       += ${BCM_BINDIST_KNL_ROOT}/ldvbon.ko:$(TARGET_COPY_OUT_VENDOR)/lib/modules/ldvbon.ko
endif
endif

ifeq ($(SAGE_SUPPORT),y)
ifeq ($(ANDROID_SUPPORTS_KEYMASTER),y)
PRODUCT_COPY_FILES   += $(LOCAL_DEVICE_KMCERT_DEFAULT):$(TARGET_COPY_OUT_VENDOR)/usr/kmgk/km.zx.bin
PRODUCT_COPY_FILES   += $(LOCAL_DEVICE_KMCERT_CUSTOM):$(TARGET_COPY_OUT_VENDOR)/usr/kmgk/km.xx.cus.bin
endif
ifeq ($(SAGE_VERSION),2x)
SAGE_BINARY_EXT      ?= _dev
SAGE_BL_BINARY_PATH  ?= $(BSEAV_TOP)/lib/security/sage/bin/2x/$(BCHP_CHIP)$(BCHP_VER)
PRODUCT_COPY_FILES   += ${SAGE_BL_BINARY_PATH}/sage_bl${SAGE_BINARY_EXT}.bin:$(TARGET_COPY_OUT_VENDOR)/bin/sage_bl${SAGE_BINARY_EXT}.bin
SAGE_APP_BINARY_PATH ?= $(SAGE_BL_BINARY_PATH)/securemode$(SAGE_SECURE_MODE)
PRODUCT_COPY_FILES   += ${SAGE_APP_BINARY_PATH}/sage_os_app${SAGE_BINARY_EXT}.bin:$(TARGET_COPY_OUT_VENDOR)/bin/sage_os_app${SAGE_BINARY_EXT}.bin
else
ifeq ($(LOCAL_DEVICE_SAGE_DEV_N_PROD),y)
SAGE_BINARY_EXT      ?= _dev
SAGE_BL_BINARY_PATH  ?= ${BCM_VENDOR_STB_ROOT}/prebuilts/sage/${TARGET_SAGE_PLATFORM}/zd
PRODUCT_COPY_FILES   += ${SAGE_BL_BINARY_PATH}/sage_bl${SAGE_BINARY_EXT}.bin:$(TARGET_COPY_OUT_VENDOR)/bin/sage_bl${SAGE_BINARY_EXT}.bin
SAGE_APP_BINARY_PATH ?= $(SAGE_BL_BINARY_PATH)
PRODUCT_COPY_FILES   += ${SAGE_APP_BINARY_PATH}/sage_framework${SAGE_BINARY_EXT}.bin:$(TARGET_COPY_OUT_VENDOR)/bin/sage_framework${SAGE_BINARY_EXT}.bin
PRODUCT_COPY_FILES   += ${SAGE_APP_BINARY_PATH}/sage_ta_antirollback${SAGE_BINARY_EXT}.bin:$(TARGET_COPY_OUT_VENDOR)/bin/sage_ta_antirollback${SAGE_BINARY_EXT}.bin
ifeq ($(DTCP_IP_SAGE_SUPPORT),y)
PRODUCT_COPY_FILES   += ${SAGE_APP_BINARY_PATH}/sage_ta_dtcpip${SAGE_BINARY_EXT}.bin:$(TARGET_COPY_OUT_VENDOR)/bin/sage_ta_dtcpip${SAGE_BINARY_EXT}.bin
endif
PRODUCT_COPY_FILES   += ${SAGE_APP_BINARY_PATH}/sage_ta_hdcp22${SAGE_BINARY_EXT}.bin:$(TARGET_COPY_OUT_VENDOR)/bin/sage_ta_hdcp22${SAGE_BINARY_EXT}.bin
ifeq ($(ANDROID_SUPPORTS_KEYMASTER),y)
PRODUCT_COPY_FILES   += ${SAGE_APP_BINARY_PATH}/sage_ta_keymaster${SAGE_BINARY_EXT}.bin:$(TARGET_COPY_OUT_VENDOR)/bin/sage_ta_keymaster${SAGE_BINARY_EXT}.bin
endif
PRODUCT_COPY_FILES   += ${SAGE_APP_BINARY_PATH}/sage_ta_secure_video${SAGE_BINARY_EXT}.bin:$(TARGET_COPY_OUT_VENDOR)/bin/sage_ta_secure_video${SAGE_BINARY_EXT}.bin
ifeq ($(ANDROID_SUPPORTS_RPMB),y)
PRODUCT_COPY_FILES   += ${SAGE_APP_BINARY_PATH}/sage_ta_ssd${SAGE_BINARY_EXT}.bin:$(TARGET_COPY_OUT_VENDOR)/bin/sage_ta_ssd${SAGE_BINARY_EXT}.bin
endif
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
SAGE_BINARY_EXT2      ?=
SAGE_BL_BINARY_PATH2  ?= ${BCM_VENDOR_STB_ROOT}/prebuilts/sage/${TARGET_SAGE_PLATFORM}/zb
PRODUCT_COPY_FILES    += ${SAGE_BL_BINARY_PATH2}/sage_bl${SAGE_BINARY_EXT2}.bin:$(TARGET_COPY_OUT_VENDOR)/bin/sage_bl${SAGE_BINARY_EXT2}.bin
SAGE_APP_BINARY_PATH2 ?= $(SAGE_BL_BINARY_PATH2)
PRODUCT_COPY_FILES    += ${SAGE_APP_BINARY_PATH2}/sage_framework${SAGE_BINARY_EXT2}.bin:$(TARGET_COPY_OUT_VENDOR)/bin/sage_framework${SAGE_BINARY_EXT2}.bin
PRODUCT_COPY_FILES    += ${SAGE_APP_BINARY_PATH2}/sage_ta_antirollback${SAGE_BINARY_EXT2}.bin:$(TARGET_COPY_OUT_VENDOR)/bin/sage_ta_antirollback${SAGE_BINARY_EXT2}.bin
ifeq ($(DTCP_IP_SAGE_SUPPORT),y)
PRODUCT_COPY_FILES   += ${SAGE_APP_BINARY_PATH2}/sage_ta_dtcpip${SAGE_BINARY_EXT2}.bin:$(TARGET_COPY_OUT_VENDOR)/bin/sage_ta_dtcpip${SAGE_BINARY_EXT2}.bin
endif
PRODUCT_COPY_FILES    += ${SAGE_APP_BINARY_PATH2}/sage_ta_hdcp22${SAGE_BINARY_EXT2}.bin:$(TARGET_COPY_OUT_VENDOR)/bin/sage_ta_hdcp22${SAGE_BINARY_EXT2}.bin
ifeq ($(ANDROID_SUPPORTS_KEYMASTER),y)
PRODUCT_COPY_FILES    += ${SAGE_APP_BINARY_PATH2}/sage_ta_keymaster${SAGE_BINARY_EXT2}.bin:$(TARGET_COPY_OUT_VENDOR)/bin/sage_ta_keymaster${SAGE_BINARY_EXT2}.bin
endif
PRODUCT_COPY_FILES    += ${SAGE_APP_BINARY_PATH2}/sage_ta_secure_video${SAGE_BINARY_EXT2}.bin:$(TARGET_COPY_OUT_VENDOR)/bin/sage_ta_secure_video${SAGE_BINARY_EXT2}.bin
ifeq ($(ANDROID_SUPPORTS_RPMB),y)
PRODUCT_COPY_FILES    += ${SAGE_APP_BINARY_PATH2}/sage_ta_ssd${SAGE_BINARY_EXT2}.bin:$(TARGET_COPY_OUT_VENDOR)/bin/sage_ta_ssd${SAGE_BINARY_EXT2}.bin
endif
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
SAGE_BL_BINARY_PATH  ?= ${BCM_VENDOR_STB_ROOT}/prebuilts/sage/${TARGET_SAGE_PLATFORM}/zd
PRODUCT_COPY_FILES   += ${SAGE_BL_BINARY_PATH}/sage_bl${SAGE_BINARY_EXT}.bin:$(TARGET_COPY_OUT_VENDOR)/bin/sage_bl${SAGE_BINARY_EXT}.bin
SAGE_APP_BINARY_PATH ?= $(SAGE_BL_BINARY_PATH)
PRODUCT_COPY_FILES   += ${SAGE_APP_BINARY_PATH}/sage_framework${SAGE_BINARY_EXT}.bin:$(TARGET_COPY_OUT_VENDOR)/bin/sage_framework${SAGE_BINARY_EXT}.bin
PRODUCT_COPY_FILES   += ${SAGE_APP_BINARY_PATH}/sage_ta_antirollback${SAGE_BINARY_EXT}.bin:$(TARGET_COPY_OUT_VENDOR)/bin/sage_ta_antirollback${SAGE_BINARY_EXT}.bin
ifeq ($(DTCP_IP_SAGE_SUPPORT),y)
PRODUCT_COPY_FILES   += ${SAGE_APP_BINARY_PATH}/sage_ta_dtcpip${SAGE_BINARY_EXT}.bin:$(TARGET_COPY_OUT_VENDOR)/bin/sage_ta_dtcpip${SAGE_BINARY_EXT}.bin
endif
PRODUCT_COPY_FILES   += ${SAGE_APP_BINARY_PATH}/sage_ta_hdcp22${SAGE_BINARY_EXT}.bin:$(TARGET_COPY_OUT_VENDOR)/bin/sage_ta_hdcp22${SAGE_BINARY_EXT}.bin
ifeq ($(ANDROID_SUPPORTS_KEYMASTER),y)
PRODUCT_COPY_FILES   += ${SAGE_APP_BINARY_PATH}/sage_ta_keymaster${SAGE_BINARY_EXT}.bin:$(TARGET_COPY_OUT_VENDOR)/bin/sage_ta_keymaster${SAGE_BINARY_EXT}.bin
endif
PRODUCT_COPY_FILES   += ${SAGE_APP_BINARY_PATH}/sage_ta_secure_video${SAGE_BINARY_EXT}.bin:$(TARGET_COPY_OUT_VENDOR)/bin/sage_ta_secure_video${SAGE_BINARY_EXT}.bin
ifeq ($(ANDROID_SUPPORTS_RPMB),y)
PRODUCT_COPY_FILES   += ${SAGE_APP_BINARY_PATH}/sage_ta_ssd${SAGE_BINARY_EXT}.bin:$(TARGET_COPY_OUT_VENDOR)/bin/sage_ta_ssd${SAGE_BINARY_EXT}.bin
endif
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
ifeq ($(DTCP_IP_SAGE_SUPPORT),y)
PRODUCT_PACKAGES += libb_dtcp_ip
endif
ifeq ($(SAGE_SECURE_LOG_SUPPORT),y)
PRODUCT_PACKAGES += \
   libsageseclog \
   sageseclog
endif
endif

ifneq ($(HW_WIFI_SUPPORT),n)
ifeq ($(HW_WIFI_NIC_SUPPORT),y)
$(call inherit-product-if-exists, device/broadcom/common/connectivity/bcmnic-device.mk)
else
$(call inherit-product-if-exists, device/broadcom/common/connectivity/bcmdhd-device.mk)
endif
endif
ifneq ($(filter usb uart,$(ANDROID_ENABLE_BT)),)
$(call inherit-product-if-exists, device/broadcom/common/connectivity/bcmbt-device.mk)
endif

$(call inherit-product-if-exists, $(LOCAL_DEVICE_REFERENCE_BUILD))
ifneq ($(LOCAL_DEVICE_DALVIK_CONFIG),)
$(call inherit-product, $(LOCAL_DEVICE_DALVIK_CONFIG))
else
$(call inherit-product, frameworks/native/build/tablet-10in-xhdpi-2048-dalvik-heap.mk)
endif

ifneq ($(LOCAL_DEVICE_USE_AVB),y)
ifeq ($(LOCAL_DEVICE_USE_VERITY),y)
$(call inherit-product, build/target/product/verity.mk)
PRODUCT_SUPPORTS_BOOT_SIGNER    := false
PRODUCT_VERITY_SIGNING_KEY      := vendor/broadcom/bcm_platform/signing/verity
PRODUCT_SYSTEM_VERITY_PARTITION := $(LOCAL_DEVICE_SYSTEM_VERITY_PARTITION)
ifneq ($(LOCAL_NVI_LAYOUT),y)
PRODUCT_VENDOR_VERITY_PARTITION := $(LOCAL_DEVICE_VENDOR_VERITY_PARTITION)
endif
PRODUCT_PACKAGES                += slideshow verity_warning_images generate_verity_key
PRODUCT_COPY_FILES              += frameworks/native/data/etc/android.software.verified_boot.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.verified_boot.xml
PRODUCT_COPY_FILES              += vendor/broadcom/bcm_platform/signing/verity.key.pub:root/verity_key
endif
endif

# packages for the system image content.
PRODUCT_PACKAGES += \
    wpa_supplicant \
    wpa_supplicant.conf \
    dhcpcd.conf \
    wificond

ifeq ($(wildcard ${GMS_PACKAGE_ROOT}/google/Android.mk),)
PRODUCT_PACKAGES += \
   Browser \
   Calculator \
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
    gptbin \
    makehwcfg \
    nxdispfmt \
    nxserver \
    teebin

ifeq ($(LOCAL_GATOR_SUPPORT), y)
PRODUCT_PACKAGES += \
    gatord
endif

# device supported hal's.
PRODUCT_PACKAGES += \
    audio.primary.$(TARGET_BOARD_PLATFORM) \
    bootctrl.$(TARGET_BOARD_PLATFORM) \
    gatekeeper.$(TARGET_BOARD_PLATFORM) \
    gralloc.$(TARGET_BOARD_PLATFORM) \
    hdmi_cec.$(TARGET_BOARD_PLATFORM) \
    hwcomposer.$(TARGET_BOARD_PLATFORM) \
    lights.$(TARGET_BOARD_PLATFORM) \
    memtrack.$(TARGET_BOARD_PLATFORM) \
    power.$(TARGET_BOARD_PLATFORM) \
    thermal.$(TARGET_BOARD_PLATFORM) \
    tv_input.$(TARGET_BOARD_PLATFORM)

ifeq ($(HW_GPU_VULKAN_SUPPORT),y)
PRODUCT_PACKAGES += \
    vulkan.$(TARGET_BOARD_PLATFORM)
endif

ifeq ($(ANDROID_SUPPORTS_KEYMASTER),y)
PRODUCT_PACKAGES += \
    keystore.$(TARGET_BOARD_PLATFORM)
endif

PRODUCT_PACKAGES += \
   android.hardware.audio@4.0-impl \
   android.hardware.audio.effect@4.0-impl \
   android.hardware.bluetooth@1.0-impl-bcm \
   android.hardware.bluetooth@1.0-service \
   android.hardware.drm@1.0-impl \
   android.hardware.drm@1.1-service.clearkey \
   android.hardware.gatekeeper@1.0-impl \
   android.hardware.graphics.allocator@2.0-impl \
   android.hardware.graphics.allocator@2.0-service \
   android.hardware.graphics.bufferqueue@1.0 \
   android.hardware.graphics.common@1.0 \
   android.hardware.graphics.composer@2.1-impl \
   android.hardware.graphics.mapper@2.0-impl \
   android.hardware.keymaster@3.0-impl \
   android.hardware.keymaster@3.0-service \
   android.hardware.light@2.0-impl \
   android.hardware.light@2.0-service \
   android.hardware.memtrack@1.0-impl \
   android.hardware.memtrack@1.0-service \
   android.hardware.power@1.0-impl \
   android.hardware.thermal@1.0-impl \
   android.hardware.thermal@1.0-service \
   android.hardware.tv.input@1.0-impl \
   android.hardware.tv.cec@1.0-impl \
   android.hardware.wifi@1.0-bcm

ifneq ($(HW_AB_UPDATE_SUPPORT),n)
PRODUCT_PACKAGES += \
   android.hardware.boot@1.0-impl \
   android.hardware.boot@1.0-service
endif

ifneq ($(HW_WIFI_SUPPORT),n)
PRODUCT_PACKAGES += \
   android.hardware.wifi@1.0 \
   android.hardware.wifi.supplicant@1.0
endif

PRODUCT_PACKAGES += \
   android.hardware.audio@2.0-service \
   android.hardware.drm@1.0-service \
   android.hardware.gatekeeper@1.0-service \
   android.hardware.graphics.composer@2.1-service \
   android.hardware.renderscript@1.0-impl \
   android.hardware.soundtrigger@2.1-impl \
   android.hardware.power@1.0-service \
   android.hardware.tv.cec@1.0-service \
   android.hardware.tv.input@1.0-service \
   bcm.hardware.nexus@1.0-impl \
   bcm.hardware.dspsvcext@1.0-service \
   bcm.hardware.dspsvcext-V1.0-java \
   bcm.hardware.sdbhak@1.0-service \
   bcm.hardware.tvisvcext@1.0-service \
   bcm.hardware.dpthak@1.0-service \
   bcm.hardware.sfhak@1.0-service
ifeq ($(ANDROID_SUPPORTS_WIDEVINE),y)
PRODUCT_PACKAGES += \
   android.hardware.drm@1.1-service.widevine
endif
ifeq ($(ANDROID_SUPPORTS_PLAYREADY),y)
PRODUCT_PACKAGES += \
   android.hardware.drm@1.1-service.playready
endif
ifeq ($(SAGE_SUPPORT),y)
ifneq ($(filter $(ANDROID_DEVICE_SUPPORTS_BP3),y),)
PRODUCT_PACKAGES += \
   bcm.hardware.bp3@1.0-service \
   bcm.hardware.bp3-V1.0-java
endif
endif
ifeq ($(LOCAL_DEVICE_MSD_SUPPORT),y)
PRODUCT_PACKAGES += \
   android.hardware.audio@4.0-service-msd \
   dolby.audio.ms12@1.0.so
endif
PRODUCT_PACKAGES += \
   android.hardware.health@2.0-service.bcm

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
    topv3d \
    TvProvider

ifeq ($(HW_CAMERA_SUPPORT),y)
PRODUCT_PACKAGES += \
   Camera2 \
   android.hardware.camera.provider@2.4-impl \
   android.hardware.camera.provider@2.4-external-service
endif

ifeq ($(HW_GPU_VULKAN_SUPPORT),y)
PRODUCT_PACKAGES += \
    libbcmvulkan_icd
endif

# bcm custom test apps, can be compiled out.
ifeq ($(BCM_APP_CUSTOM),y)
PRODUCT_PACKAGES += \
    BcmAdjustScreenOffset \
    BcmHdmiTvInput \
    BcmSidebandViewer \
    BcmTVInput \
    libbcmtuner \
    libbcmsideband \
    libbcmsidebandviewer_jni

ifeq ($(SAGE_SUPPORT),y)
ifneq ($(filter $(ANDROID_DEVICE_SUPPORTS_BP3),y),)
PRODUCT_PACKAGES += \
    BcmBP3Config
endif
endif

ifeq ($(LOCAL_DEVICE_MSD_SUPPORT),y)
PRODUCT_PACKAGES += \
   DolbyAudioTests
endif
endif

PRODUCT_PACKAGES += \
    BcmCustomizer \
    BcmPlayAutoInstallConfig \
    BcmFwksRro

ifneq ($(filter $(ANDROID_SUPPORTS_WIDEVINE) $(ANDROID_SUPPORTS_PLAYREADY),y),)
PRODUCT_PROPERTY_OVERRIDES  += drm.service.enabled=true
PRODUCT_PACKAGES            += libbcrypt libdrmrootfs libcmndrm libcmndrm_tl libsrai
ifeq ($(ANDROID_SUPPORTS_WIDEVINE),y)
PRODUCT_PACKAGES            += liboemcrypto libwvdrmengine
endif
ifeq ($(ANDROID_SUPPORTS_PLAYREADY),y)
PRODUCT_PACKAGES            += libcmndrmprdy libplayreadydrmplugin_2_5 libplayreadypk_host libprhidl_2_5
ifneq ($(SAGE_VERSION),2x)
PRODUCT_PACKAGES            += libplayreadydrmplugin_3_0 libplayready30pk libprhidl_3_0
endif
endif
endif

ifneq ($(filter $(ANDROID_SUPPORTS_RPMB),y),)
PRODUCT_PACKAGES            += libsagessd
PRODUCT_PACKAGES            += nxssd
endif

ifneq ($(filter $(ANDROID_SUPPORTS_KEYMASTER),y),)
PRODUCT_PACKAGES            += libkmtl
PRODUCT_PACKAGES            += libmfgtl
endif

ifneq ($(TARGET_BUILD_PDK),true)
ifeq ($(HW_AB_UPDATE_SUPPORT),y)
PRODUCT_PACKAGES            += update_engine update_engine_client update_verifier
PRODUCT_PACKAGES            += update_engine_sideload
PRODUCT_STATIC_BOOT_CONTROL_HAL := bootctrl.$(TARGET_BOARD_PLATFORM)
endif
endif

# temporary adding command line support for BP3.
ifeq ($(SAGE_SUPPORT),y)
ifneq ($(filter $(ANDROID_DEVICE_SUPPORTS_BP3),y),)
PRODUCT_PACKAGES += libhost_bp3 bp3
export BP3_PROVISIONING := y
endif
endif

# Netflix support
ifneq (${LOCAL_DEVICE_NRDP_MODEL_GROUP},)
LOCAL_DEVICE_NRDP_VALIDATION ?= ninja_5.1
PRODUCT_PROPERTY_OVERRIDES += \
   ro.vendor.nrdp.modelgroup=${LOCAL_DEVICE_NRDP_MODEL_GROUP} \
   ro.vendor.nrdp.validation=${LOCAL_DEVICE_NRDP_VALIDATION}
PRODUCT_PROPERTY_OVERRIDES += \
   ro.vendor.nrdp.audio.mixer.buffersize=2048
PRODUCT_COPY_FILES += device/broadcom/common/permissions/nrdp.xml:system/etc/permissions/nrdp.xml
PRODUCT_COPY_FILES += device/broadcom/common/sysconfig/netflix.xml:system/etc/sysconfig/netflix.xml
PRODUCT_PACKAGES += \
    BcmNrdpHelper
endif

PRODUCT_COPY_FILES += device/broadcom/common/pub.libs/treble/public.libraries.broadcom.txt:$(TARGET_COPY_OUT_VENDOR)/etc/public.libraries.txt

$(call inherit-product-if-exists, ${BCM_VENDOR_STB_ROOT}/bcm_platform/device-vendor.mk)

ifeq ($(LOCAL_DEVICE_MSD_SUPPORT),y)
DOLBY_ENABLE          := true
DOLBY_MS12_VERSION    := 2.3.0
DOLBY_AUDIO_DUMP      := true
ARM_PREBUILTS_VARIANT := float
PRODUCT_COPY_FILES  += vendor/dolby/msd/device/common/msd_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/msd_audio_policy_configuration.xml:dolby
PRODUCT_COPY_FILES  += vendor/dolby/msd/device/common/com.dolby.android.audio.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/permissions/com.dolby.android.audio.xml:dolby
PRODUCT_COPY_FILES  += vendor/dolby/msd/android.hardware.audio@4.0-service-msd.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/android.hardware.audio@4.0-service-msd.rc:dolby
PRODUCT_COPY_FILES  += vendor/dolby/msdPrebuilt/android.hardware.audio@4.0-service-msd:$(TARGET_COPY_OUT_VENDOR)/bin/hw/android.hardware.audio@4.0-service-msd:dolby
PRODUCT_COPY_FILES  += vendor/dolby/msdPrebuilt/dolby.audio.ms12@1.0.so:$(TARGET_COPY_OUT_VENDOR)/lib/dolby.audio.ms12@1.0.so:dolby
$(call inherit-product-if-exists, vendor/dolby/msd/audio/dolby-product.mk)
include vendor/dolby/msd/audio/dolby-buildspec.mk
endif
