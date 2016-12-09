ifeq ($(LOCAL_DEVICE_TYPE),blemmyes)
include device/broadcom/common/headless.mk
else
include device/broadcom/common/headed.mk
endif
