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
   ro.nx.colordepth10b.force=1 \
   \
   ro.nx.pr.version=2.5
#
# proprietary properties not applicable always.
#
# ro.nx.dhd.secdma: secure dhd comms, defaults to 16MB.
#
ifeq ($(ANDROID_ENABLE_DHD_SECDMA),y)
PRODUCT_PROPERTY_OVERRIDES += \
   ro.nx.dhd.secdma=16777216
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
   ro.sf.disable_triple_buffer=0 \
   \
   ro.gfx.driver.0=gfxdriver-bcmstb
#
# system properties (eg gtvs related).
#
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
   atv.setup.bt_remote_pairing=true  \
   atv.setup.play_background_movie=0 \
   atv.setup.play_background_music=0 \
#
# system properties valid before P split for compatibility on
# legacy platforms.
#
ifeq ($(LOCAL_DEVICE_PROPERTIES_LEGACY),y)
PRODUCT_PROPERTY_OVERRIDES += \
   ro.zygote.disable_gl_preload=true \
   ro.bq.gpu_to_cpu_unsupported=1 \
   \
   sys.display-size=1920x1080
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
#   ro.control_privapp_permission=enforce

PRODUCT_COPY_FILES += \
   device/broadcom/common/permissions/privapp-permissions-bcm.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/privapp-permissions-bcm.xml

ifneq ($(TARGET_BUILD_PDK),true)
PRODUCT_COPY_FILES += \
   frameworks/base/data/etc/privapp-permissions-platform.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/privapp-permissions-platform.xml
endif

# hardware interface hal manifest.
#
ifeq ($(LOCAL_DEVICE_FULL_TREBLE),y)
DEVICE_MANIFEST_FILE := device/broadcom/common/manifest/treble.xml
else
DEVICE_MANIFEST_FILE := device/broadcom/common/manifest/legacy.xml
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

ifeq ($(LOCAL_DEVICE_FULL_TREBLE),y)
# full treble support.
PRODUCT_FULL_TREBLE_OVERRIDE := true
endif

ifneq ($(wildcard vendor/google/certs),)
PRODUCT_DEFAULT_DEV_CERTIFICATE := vendor/google/certs/devkeys/devkey
else
PRODUCT_DEFAULT_DEV_CERTIFICATE := vendor/broadcom/bcm_platform/signing/testkey
endif

