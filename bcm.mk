# common properties for all devices.
#
# private|proprietary properties.
#
PRODUCT_PROPERTY_OVERRIDES += \
   ro.nx.ir_remote.mode=CirNec \
   ro.nx.ir_remote.map=broadcom_silver \
   ro.nx.ir_remote.mask=0 \
   ro.nx.ir_remote.initial_timeout=75 \
   ro.nx.ir_remote.timeout=115 \
   ro.nx.ir_remote.wakeup.button=398 \
   ro.nx.ir_remote.name=NexusIrHandler \
   \
   ro.nx.logger_size=4096 \
   ro.v3d.fence.expose=true \
   \
   ro.nx.media.vdec_outportbuf=32 \
   \
   ro.nx.media.vdec_hfrvideo_tunnel=1

#
# if you really want interleave video in best
# effort integration mode (ie. tunneling playback
# only at bomx level), set the below export in your
# device profile.
#
ifneq ($(HW_IVIDEO_MODE_BEST_EFFORT),y)
PRODUCT_PROPERTY_OVERRIDES += \
   ro.nx.media.vdec.fsm1080p=1 \
   ro.nx.media.vdec.progoverride=2
endif
#
# ro.nx.pr.version defaults to 2.5
#
ifneq ($(ANDROID_PLAYREADY_VERSION),3.0)
PRODUCT_PROPERTY_OVERRIDES += \
   ro.nx.pr.version=2.5
else
PRODUCT_PROPERTY_OVERRIDES += \
   ro.nx.pr.version=3.0
endif
#
# proprietary properties not applicable always.
#
# ro.nx.dhd.secdma: secure dhd comms, defaults to 20MB.
#
ifeq ($(ANDROID_ENABLE_DHD_SECDMA),y)
PRODUCT_PROPERTY_OVERRIDES += \
   ro.nx.dhd.secdma=20971520
endif
#
# system inherited|whitelisted properties.
#
PRODUCT_PROPERTY_OVERRIDES += \
   ro.hdmi.device_type=4 \
   persist.sys.hdmi.keep_awake=false \
   ro.hdmi.wake_on_hotplug=false \
   \
   media.stagefright.cache-params=32768/65536/25 \
   \
   ro.gfx.driver.0=gfxdriver-bcmstb

ifeq ($(LOCAL_DEVICE_LOWRAM),y)
PRODUCT_PROPERTY_OVERRIDES += \
   ro.sf.disable_triple_buffer=1
else
PRODUCT_PROPERTY_OVERRIDES += \
   ro.sf.disable_triple_buffer=0
endif
#
# system properties (eg gtvs related).
#
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
   atv.setup.play_background_movie=0 \
   atv.setup.play_background_music=0
#
# system properties (for msd support).
#
ifeq ($(LOCAL_DEVICE_MSD_SUPPORT),y)
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
   audio.offload.min.duration.secs=0 \
   audio.offload.video=true
endif
#
# system properties valid before P split for compatibility on
# legacy platforms.
#
ifeq ($(LOCAL_DEVICE_PROPERTIES_LEGACY),y)
PRODUCT_PROPERTY_OVERRIDES += \
   ro.zygote.disable_gl_preload=true \
   ro.bq.gpu_to_cpu_unsupported=1 \
   \
   vendor.display-size=1920x1080
endif

# pull in specific target based settings.
#
ifeq ($(LOCAL_DEVICE_TYPE),blemmyes)
include device/broadcom/common/headless.mk
else
include device/broadcom/common/headed.mk
endif

# gfx driver identification.
#
PRODUCT_PACKAGES += \
   gfxdriver-bcmstb

PRODUCT_COPY_FILES += \
   device/broadcom/common/seccomp/mediacodec-seccomp.policy:$(TARGET_COPY_OUT_VENDOR)/etc/seccomp_policy/mediacodec.policy

# whitelisting privapp permissions.
#
#PRODUCT_PROPERTY_OVERRIDES += \
#   ro.control_privapp_permissions=enforce

PRODUCT_COPY_FILES += \
   device/broadcom/common/permissions/privapp-permissions-bcm.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/privapp-permissions-bcm.xml \
   device/broadcom/common/permissions/privapp-permissions-bcm-sys.xml:system/etc/permissions/privapp-permissions-bcm-sys.xml

ifneq ($(TARGET_BUILD_PDK),true)
PRODUCT_COPY_FILES += \
   frameworks/base/data/etc/privapp-permissions-platform.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/privapp-permissions-platform.xml
endif

# copy kernel image.
ifeq ($(BCM_DIST_KNLIMG_BINS), y)
ifneq ($(wildcard device/broadcom/${LOCAL_PRODUCT_OUT}-kernel/zImage),)
PRODUCT_COPY_FILES += \
   device/broadcom/${LOCAL_PRODUCT_OUT}-kernel/zImage:kernel
else
PRODUCT_COPY_FILES += \
   ${BCM_BINDIST_KNL_ROOT}/kernel:kernel
endif
endif

# vndk.
#
PRODUCT_PACKAGES += \
   $(LOCAL_PRODUCT_OUT)-vndk \
   vndk_package

ifeq ($(LOCAL_ANDROID_64BIT_ONLY),y)
PRODUCT_FULL_TREBLE_OVERRIDE := false
else
ifeq ($(LOCAL_FULL_TREBLE_NOT_COMPATIBLE),y)
PRODUCT_FULL_TREBLE_OVERRIDE := false
else
PRODUCT_FULL_TREBLE_OVERRIDE := true
endif
endif
ifneq ($(LOCAL_NVI_LAYOUT),y)
PRODUCT_SEPOLICY_SPLIT := true
endif

ifneq ($(wildcard vendor/google/certs),)
PRODUCT_DEFAULT_DEV_CERTIFICATE := vendor/google/certs/devkeys/devkey
else
PRODUCT_DEFAULT_DEV_CERTIFICATE := vendor/broadcom/bcm_platform/signing/testkey
endif

include device/broadcom/common/vsp.mk
