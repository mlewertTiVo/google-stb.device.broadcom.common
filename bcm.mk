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
# system inherited|whitelisted properties.
#
PRODUCT_PROPERTY_OVERRIDES += \
   ro.hdmi.device_type=4 \
   persist.sys.hdmi.keep_awake=false \
   ro.hdmi.wake_on_hotplug=false \
   \
   media.stagefright.cache-params=32768/65536/25 \
   \
   ro.bq.gpu_to_cpu_unsupported=1 \
   ro.zygote.disable_gl_preload=true \
   ro.sf.disable_triple_buffer=0 \
   \
   ro.gfx.driver.0=gfxdriver-bcmstb \
   \
   sys.display-size=1920x1080 \
   \
   ro.vendor.vndk.version=26.1.0
#
# system properties (eg gtvs related).
#
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
   setup.bt_remote_pairing=true

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
ifeq ($(HW_CAMERA_SUPPORT),y)
DEVICE_MANIFEST_FILE := device/broadcom/common/manifest/treble.cam.xml
else
DEVICE_MANIFEST_FILE := device/broadcom/common/manifest/treble.xml
endif
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

PRODUCT_DEFAULT_DEV_CERTIFICATE := vendor/broadcom/bcm_platform/signing/testkey

