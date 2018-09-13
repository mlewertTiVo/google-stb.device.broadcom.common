LOCAL_PATH := $(call my-dir)

include $(LOCAL_PATH)/AndroidKernel.mk
include $(LOCAL_PATH)/AndroidPhony.mk

include $(CLEAR_VARS)
include $(BUILD_KEY_CHAR_MAP)

INSTALLED_RADIOIMAGE_TARGET += $(PRODUCT_OUT)/bootloader.img
INSTALLED_RADIOIMAGE_TARGET += $(PRODUCT_OUT)/gpt.bin

