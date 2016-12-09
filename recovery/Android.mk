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

ifneq ($(filter $(BCM_RBOARDS) $(BCM_DBOARDS),$(TARGET_DEVICE)),)
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
LOCAL_C_INCLUDES += bootable/recovery
LOCAL_SRC_FILES := recovery_updater.cpp
# should match TARGET_RECOVERY_UPDATER_LIBS set in BoardConfig.mk
LOCAL_MODULE := librecovery_updater_ext
include $(BUILD_STATIC_LIBRARY)

include $(CLEAR_VARS)

NXMINI := $(call intermediates-dir-for,EXECUTABLES,nxmini)/nxmini

EXTRA_SYSTEM_LIB_FILES := \
   ${NEXUS_BIN_DIR_1ST_ARCH}/bcmnexusfb.ko \
   ${NEXUS_BIN_DIR_1ST_ARCH}/nexus.ko

ifeq ($(SAGE_SUPPORT),y)
ifeq ($(SAGE_VERSION),2x)
SAGE_BL_BINARY_PATH  := $(BSEAV_TOP)/lib/security/sage/bin/2x/$(BCHP_CHIP)$(BCHP_VER)
SAGE_APP_BINARY_PATH := $(SAGE_BL_BINARY_PATH)/securemode$(SAGE_SECURE_MODE)
EXTRA_SYSTEM_BIN_FILES := \
   ${SAGE_BL_BINARY_PATH}/sage_bl.bin \
   ${SAGE_BL_BINARY_PATH}/sage_bl_dev.bin \
   ${SAGE_APP_BINARY_PATH}/sage_os_app.bin \
   ${SAGE_APP_BINARY_PATH}/sage_os_app_dev.bin
else
SAGE_BL_BINARY_PATH  := $(BSEAV_TOP)/lib/security/sage/bin/$(BCHP_CHIP)$(BCHP_VER)
SAGE_APP_BINARY_PATH := $(SAGE_BL_BINARY_PATH)
EXTRA_SYSTEM_BIN_FILES := \
   ${SAGE_BL_BINARY_PATH}/sage_bl.bin \
   ${SAGE_APP_BINARY_PATH}/sage_framework.bin \
   ${SAGE_APP_BINARY_PATH}/sage_ta_antirollback.bin \
   ${SAGE_APP_BINARY_PATH}/sage_ta_common_drm.bin \
   ${SAGE_APP_BINARY_PATH}/sage_ta_hdcp22.bin \
   ${SAGE_APP_BINARY_PATH}/sage_ta_secure_video.bin \
   ${SAGE_APP_BINARY_PATH}/sage_ta_utility.bin \
   ${SAGE_BL_BINARY_PATH}/dev/sage_bl_dev.bin \
   ${SAGE_APP_BINARY_PATH}/dev/sage_framework_dev.bin \
   ${SAGE_APP_BINARY_PATH}/dev/sage_ta_antirollback_dev.bin \
   ${SAGE_APP_BINARY_PATH}/dev/sage_ta_common_drm_dev.bin \
   ${SAGE_APP_BINARY_PATH}/dev/sage_ta_hdcp22_dev.bin \
   ${SAGE_APP_BINARY_PATH}/dev/sage_ta_secure_video_dev.bin \
   ${SAGE_APP_BINARY_PATH}/dev/sage_ta_utility_dev.bin
ifeq ($(ANDROID_SUPPORTS_PLAYREADY),y)
EXTRA_SYSTEM_BIN_FILES += \
   ${SAGE_APP_BINARY_PATH}/sage_ta_playready_30.bin \
   ${SAGE_APP_BINARY_PATH}/dev/sage_ta_playready_30_dev.bin
endif
endif
endif

define copy-recovery-extra-files
   @mkdir -p $(TARGET_RECOVERY_ROOT_OUT)/oem/bin
   @mkdir -p $(TARGET_RECOVERY_ROOT_OUT)/oem/lib
   @mkdir -p $(TARGET_RECOVERY_ROOT_OUT)/sbin
   @cp -f $(NXMINI) $(TARGET_RECOVERY_ROOT_OUT)/sbin/
   @cp -f $(EXTRA_SYSTEM_LIB_FILES) $(TARGET_RECOVERY_ROOT_OUT)/oem/lib/
   @if [ "$(EXTRA_SYSTEM_BIN_FILES)" != "" ]; then \
      cp -f $(EXTRA_SYSTEM_BIN_FILES) $(TARGET_RECOVERY_ROOT_OUT)/oem/bin/; \
   fi
endef

.PHONY: recovery_bcm_libs
recovery_bcm_libs: $(NXMINI) \
		$(EXTRA_SYSTEM_LIB_FILES) \
		$(EXTRA_SYSTEM_BIN_FILES)
	$(hide) $(call copy-recovery-extra-files)

out/target/product/$(TARGET_DEVICE)/recovery.img : recovery_bcm_libs

endif