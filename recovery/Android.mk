# Copyright (C) 2007 The Android Open Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

ifneq ($(filter $(BCM_RBOARDS) $(BCM_DBOARDS) $(BCM_CBOARDS),$(TARGET_DEVICE)),)
LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)
LOCAL_MODULE_TAGS := eng
LOCAL_C_INCLUDES += bootable/recovery
LOCAL_SRC_FILES := default_device.cpp
# should match TARGET_RECOVERY_UI_LIB set in BoardConfig.mk
LOCAL_MODULE := librecovery_ui_ext
include $(BUILD_STATIC_LIBRARY)

include $(CLEAR_VARS)
LOCAL_MODULE_TAGS := eng
LOCAL_SRC_FILES := recovery_updater.cpp
# should match TARGET_RECOVERY_UPDATER_LIBS set in BoardConfig.mk
LOCAL_MODULE := librecovery_updater_ext
LOCAL_STATIC_LIBRARIES := \
    libedify \
    libotautil
include $(BUILD_STATIC_LIBRARY)

include $(CLEAR_VARS)

NXMINI := $(call intermediates-dir-for,EXECUTABLES,nxmini)/nxmini

ifneq ($(BCM_DIST_KNLIMG_BINS), y)
EXTRA_SYSTEM_LIB_FILES := \
   ${NEXUS_BIN_DIR_1ST_ARCH}/bcmnexusfb.ko \
   ${NEXUS_BIN_DIR_1ST_ARCH}/nexus.ko
else
EXTRA_SYSTEM_LIB_FILES := \
   ${BCM_BINDIST_KNL_ROOT}/bcmnexusfb.ko \
   ${BCM_BINDIST_KNL_ROOT}/nexus.ko
endif

ifeq ($(SAGE_SUPPORT),y)
ifeq ($(LOCAL_DEVICE_SAGE_DEV_N_PROD),y)
SAGE_BL_BINARY_PATH ?= ${BCM_VENDOR_STB_ROOT}/prebuilts/sage/${TARGET_SAGE_PLATFORM}/zd
SAGE_BINARY_EXT ?= _dev
SAGE_APP_BINARY_PATH ?= $(SAGE_BL_BINARY_PATH)
EXTRA_SYSTEM_BIN_FILES := \
   ${SAGE_BL_BINARY_PATH}/sage_bl${SAGE_BINARY_EXT}.bin \
   ${SAGE_APP_BINARY_PATH}/sage_framework${SAGE_BINARY_EXT}.bin \
   ${SAGE_APP_BINARY_PATH}/sage_ta_antirollback${SAGE_BINARY_EXT}.bin \
   ${SAGE_APP_BINARY_PATH}/sage_ta_hdcp22${SAGE_BINARY_EXT}.bin \
   ${SAGE_APP_BINARY_PATH}/sage_ta_secure_video${SAGE_BINARY_EXT}.bin \
   ${SAGE_APP_BINARY_PATH}/sage_ta_utility${SAGE_BINARY_EXT}.bin \
   ${SAGE_APP_BINARY_PATH}/sage_ta_bp3${SAGE_BINARY_EXT}.bin
ifeq ($(DTCP_IP_SAGE_SUPPORT),y)
EXTRA_SYSTEM_BIN_FILES += ${SAGE_APP_BINARY_PATH}/sage_ta_dtcpip${SAGE_BINARY_EXT}.bin
endif
ifeq ($(ANDROID_SUPPORTS_WIDEVINE),y)
EXTRA_SYSTEM_BIN_FILES += \
   ${SAGE_APP_BINARY_PATH}/sage_ta_widevine${SAGE_BINARY_EXT}.bin
endif
ifeq ($(ANDROID_SUPPORTS_PLAYREADY),y)
EXTRA_SYSTEM_BIN_FILES += \
   ${SAGE_APP_BINARY_PATH}/sage_ta_playready_25${SAGE_BINARY_EXT}.bin \
   ${SAGE_APP_BINARY_PATH}/sage_ta_playready_30${SAGE_BINARY_EXT}.bin
endif
SAGE_BL_BINARY_PATH2 ?= ${BCM_VENDOR_STB_ROOT}/prebuilts/sage/${TARGET_SAGE_PLATFORM}/zb
SAGE_BINARY_EXT2 ?=
SAGE_APP_BINARY_PATH2 ?= $(SAGE_BL_BINARY_PATH2)
EXTRA_SYSTEM_BIN_FILES += \
   ${SAGE_BL_BINARY_PATH2}/sage_bl${SAGE_BINARY_EXT2}.bin \
   ${SAGE_APP_BINARY_PATH2}/sage_framework${SAGE_BINARY_EXT2}.bin \
   ${SAGE_APP_BINARY_PATH2}/sage_ta_antirollback${SAGE_BINARY_EXT2}.bin \
   ${SAGE_APP_BINARY_PATH2}/sage_ta_hdcp22${SAGE_BINARY_EXT2}.bin \
   ${SAGE_APP_BINARY_PATH2}/sage_ta_secure_video${SAGE_BINARY_EXT2}.bin \
   ${SAGE_APP_BINARY_PATH2}/sage_ta_utility${SAGE_BINARY_EXT2}.bin \
   ${SAGE_APP_BINARY_PATH2}/sage_ta_bp3${SAGE_BINARY_EXT2}.bin
ifeq ($(DTCP_IP_SAGE_SUPPORT),y)
EXTRA_SYSTEM_BIN_FILES += ${SAGE_APP_BINARY_PATH2}/sage_ta_dtcpip${SAGE_BINARY_EXT2}.bin
endif
ifeq ($(ANDROID_SUPPORTS_WIDEVINE),y)
EXTRA_SYSTEM_BIN_FILES += \
   ${SAGE_APP_BINARY_PATH2}/sage_ta_widevine${SAGE_BINARY_EXT2}.bin
endif
ifeq ($(ANDROID_SUPPORTS_PLAYREADY),y)
EXTRA_SYSTEM_BIN_FILES += \
   ${SAGE_APP_BINARY_PATH2}/sage_ta_playready_25${SAGE_BINARY_EXT2}.bin \
   ${SAGE_APP_BINARY_PATH2}/sage_ta_playready_30${SAGE_BINARY_EXT2}.bin
endif
else
SAGE_BL_BINARY_PATH  ?= ${BCM_VENDOR_STB_ROOT}/prebuilts/sage/${TARGET_SAGE_PLATFORM}/zd
SAGE_BINARY_EXT ?= _dev
SAGE_APP_BINARY_PATH ?= $(SAGE_BL_BINARY_PATH)
EXTRA_SYSTEM_BIN_FILES := \
   ${SAGE_BL_BINARY_PATH}/sage_bl${SAGE_BINARY_EXT}.bin \
   ${SAGE_APP_BINARY_PATH}/sage_framework${SAGE_BINARY_EXT}.bin \
   ${SAGE_APP_BINARY_PATH}/sage_ta_antirollback${SAGE_BINARY_EXT}.bin \
   ${SAGE_APP_BINARY_PATH}/sage_ta_hdcp22${SAGE_BINARY_EXT}.bin \
   ${SAGE_APP_BINARY_PATH}/sage_ta_secure_video${SAGE_BINARY_EXT}.bin \
   ${SAGE_APP_BINARY_PATH}/sage_ta_utility${SAGE_BINARY_EXT}.bin \
   ${SAGE_APP_BINARY_PATH}/sage_ta_bp3${SAGE_BINARY_EXT}.bin
ifeq ($(ANDROID_SUPPORTS_WIDEVINE),y)
EXTRA_SYSTEM_BIN_FILES += \
   ${SAGE_APP_BINARY_PATH}/sage_ta_widevine${SAGE_BINARY_EXT}.bin
endif
ifeq ($(ANDROID_SUPPORTS_PLAYREADY),y)
EXTRA_SYSTEM_BIN_FILES += \
   ${SAGE_APP_BINARY_PATH}/sage_ta_playready_25${SAGE_BINARY_EXT}.bin \
   ${SAGE_APP_BINARY_PATH}/sage_ta_playready_30${SAGE_BINARY_EXT}.bin
endif
endif
endif

recovery_extra := $(call copy-many-files, \
  $(NXMINI):$(TARGET_RECOVERY_ROOT_OUT)/sbin/$(notdir $(NXMINI)) \
  $(foreach f,$(EXTRA_SYSTEM_LIB_FILES),$(f):$(TARGET_RECOVERY_ROOT_OUT)/oem/lib/$(notdir $(f))) \
  $(foreach f,$(EXTRA_SYSTEM_BIN_FILES),$(f):$(TARGET_RECOVERY_ROOT_OUT)/oem/bin/$(notdir $(f))) \
)

ifeq ($(HW_AB_UPDATE_SUPPORT),y)
$(PRODUCT_OUT)/boot.img : $(recovery_extra)
else
$(PRODUCT_OUT)/recovery.img : $(recovery_extra)
endif

endif
