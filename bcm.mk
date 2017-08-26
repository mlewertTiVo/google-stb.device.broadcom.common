# common properties for all devices.
#
PRODUCT_PROPERTY_OVERRIDES += \
   ro.hdmi.device_type=4 \
   ro.ir_remote.mode=CirNec \
   ro.ir_remote.map=broadcom_silver \
   ro.ir_remote.mask=0 \
   ro.ir_remote.initial_timeout=75 \
   ro.ir_remote.timeout=115 \
   ro.ir_remote.wakeup.button=398 \
   ro.ir_remote.name=NexusIrHandler \
   \
   net.http.threads=25 \
   \
   media.aac_51_output_enabled=true \
   media.stagefright.cache-params=32768/65536/25 \
   media.httplive.startathighbw=1 \
   \
   ro.nx.logger_size=4096 \
   ro.v3d.fence.expose=true \
   \
   persist.sys.hdmi.keep_awake=false \
   ro.bq.gpu_to_cpu_unsupported=1 \
   ro.hdmi.wake_on_hotplug=false \
   ro.zygote.disable_gl_preload=true \
   sys.display-size=1920x1080 \
   ro.nx.colordepth10b.force=1 \
   \
   ro.gfx.driver.0=gfxdriver-bcmstb

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

# media codec policy and setup.
#
PRODUCT_PROPERTY_OVERRIDES += \
   persist.media.treble_omx=false

PRODUCT_COPY_FILES += \
   device/broadcom/common/seccomp/mediacodec-seccomp.policy:$(TARGET_COPY_OUT_VENDOR)/etc/seccomp_policy/mediacodec.policy

# whitelisting privapp permissions.
#
#PRODUCT_PROPERTY_OVERRIDES += \
#   ro.control_privapp_permission=enforce

PRODUCT_COPY_FILES += \
   frameworks/base/data/etc/privapp-permissions-platform.xml:system/etc/permissions/privapp-permissions-platform.xml \
   device/broadcom/common/permissions/privapp-permissions-google.xml:system/etc/permissions/privapp-permissions-google.xml \
   device/broadcom/common/permissions/privapp-permissions-bcm.xml:system/etc/permissions/privapp-permissions-bcm.xml

# hardware interface hal manifest.
#
PRODUCT_COPY_FILES += \
   device/broadcom/common/manifest.xml:$(TARGET_COPY_OUT_VENDOR)/manifest.xml

# copy kernel image and associated .ko's
ifeq ($(BCM_DIST_KNLIMG_BINS), y)
ifeq ($(HW_GPU_MMU_SUPPORT),y)
PRODUCT_COPY_FILES += \
   ${BCM_BINDIST_ROOT}/knlimg/${LOCAL_LINUX_VERSION_NODASH}/arm.v3dmmu/kernel:kernel
else
PRODUCT_COPY_FILES += \
   ${BCM_BINDIST_ROOT}/knlimg/${LOCAL_LINUX_VERSION_NODASH}/arm/kernel:kernel
endif
endif
