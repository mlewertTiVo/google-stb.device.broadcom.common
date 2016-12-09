ifeq ($(LOCAL_DEVICE_TYPE),blemmyes)
$(error fixme!: headless profile is not available)
else
include device/broadcom/common/headed.mk
endif
