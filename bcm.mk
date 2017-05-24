
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
   media.stagefright.codecremote=false \
   media.stagefright.legacyencoder=true \
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
   ro.nx.colordepth10b.force=1

ifeq ($(LOCAL_DEVICE_TYPE),blemmyes)
include device/broadcom/common/headless.mk
else
include device/broadcom/common/headed.mk
endif
