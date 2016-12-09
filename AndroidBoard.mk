LOCAL_PATH := $(call my-dir)

include $(LOCAL_PATH)/AndroidKernel.mk
include $(LOCAL_PATH)/AndroidPhony.mk

include $(CLEAR_VARS)
include $(BUILD_KEY_CHAR_MAP)

$(call add-radio-file, bootloader.img)
$(call add-radio-file, gpt.bin)

