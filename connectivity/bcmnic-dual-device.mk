# This makefile copies the prebuilt wifi driver moduel and corresponding firmware and configuration files

PRODUCT_COPY_FILES += \
   ${B_NIC_DUAL_OBJ_ROOT}/nvram.txt:$(TARGET_COPY_OUT_VENDOR)/broadcom/nvrams/nvram.txt

COPY_2_VENDOR  ?= y
ifneq ($(HW_AB_UPDATE_SUPPORT),y)
ifeq ($(LOCAL_NVI_LAYOUT),y)
COPY_2_VENDOR := n
endif
endif
ifneq ($(COPY_2_VENDOR),n)
PRODUCT_COPY_FILES += \
   ${BCM_VENDOR_STB_ROOT}/bcm_platform/conx/nic-dual/init.brcm_nic.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/init.brcm_nic.rc
else
PRODUCT_COPY_FILES += \
   ${BCM_VENDOR_STB_ROOT}/bcm_platform/conx/nic-dual/init.brcm_nic.rc:root/init.brcm_nic.rc
endif

ifneq ($(BCM_DIST_KNLIMG_BINS),y)
PRODUCT_COPY_FILES += \
   ${B_NIC_DUAL_OBJ_ROOT}/driver/wl.ko:$(TARGET_COPY_OUT_VENDOR)/lib/modules/wl.ko
else
PRODUCT_COPY_FILES += \
   ${BCM_BINDIST_KNL_ROOT}/wl.ko:$(TARGET_COPY_OUT_VENDOR)/lib/modules/wl.ko
endif

PRODUCT_COPY_FILES += \
   frameworks/native/data/etc/android.hardware.wifi.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.wifi.xml \
   ${BCM_VENDOR_STB_ROOT}/bcm_platform/conx/nic/wpa_supplicant.conf:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/wpa_supplicant.conf \
   ${BCM_VENDOR_STB_ROOT}/bcm_platform/conx/nic/wpa_supplicant_overlay.conf:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/wpa_supplicant_overlay.conf

PRODUCT_PACKAGES += \
   dhcpcd.conf \
   network

PRODUCT_PROPERTY_OVERRIDES += \
   wifi.interface=wlan1

