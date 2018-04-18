# This makefile copies the prebuilt wifi driver moduel and corresponding firmware and configuration files
BRCM_NIC_DRIVER_TARGETS := \
	${B_NIC_OBJ_ROOT}/nvram.txt

PRODUCT_COPY_FILES += \
   ${B_NIC_OBJ_ROOT}/nvram.txt:$(TARGET_COPY_OUT_VENDOR)/broadcom/nvrams/nvram.txt

ifneq ($(LOCAL_NVI_LAYOUT),y)
PRODUCT_COPY_FILES += \
   ${BCM_VENDOR_STB_ROOT}/bcm_platform/conx/nic/init.brcm_nic.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/init.brcm_nic.rc
else
PRODUCT_COPY_FILES += \
   ${BCM_VENDOR_STB_ROOT}/bcm_platform/conx/nic/init.brcm_nic.rc:root/init.brcm_nic.rc
endif

ifneq ($(BCM_DIST_KNLIMG_BINS),y)
PRODUCT_COPY_FILES += \
   ${B_NIC_OBJ_ROOT}/driver/wl.ko:$(TARGET_COPY_OUT_VENDOR)/lib/modules/wl.ko \
   ${B_NIC_OBJ_ROOT}/driver/wlplat.ko:$(TARGET_COPY_OUT_VENDOR)/lib/modules/wlplat.ko
else
PRODUCT_COPY_FILES += \
   ${BCM_BINDIST_ROOT}/knlimg/${LOCAL_LINUX_VERSION_NODASH}/mods/$(TARGET_BOARD_PLATFORM)/wl.ko:$(TARGET_COPY_OUT_VENDOR)/lib/modules/wl.ko \
   ${BCM_BINDIST_ROOT}/knlimg/${LOCAL_LINUX_VERSION_NODASH}/mods/$(TARGET_BOARD_PLATFORM)/wlplat.ko:$(TARGET_COPY_OUT_VENDOR)/lib/modules/wlplat.ko
endif

PRODUCT_COPY_FILES += \
   frameworks/native/data/etc/android.hardware.wifi.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.wifi.xml \
   ${BCM_VENDOR_STB_ROOT}/bcm_platform/conx/nic/wpa_supplicant.conf:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/wpa_supplicant.conf \
   ${BCM_VENDOR_STB_ROOT}/bcm_platform/conx/nic/wpa_supplicant_overlay.conf:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/wpa_supplicant_overlay.conf

PRODUCT_PACKAGES += \
   dhcpcd.conf \
   network

PRODUCT_PROPERTY_OVERRIDES += \
   wifi.interface=wlan0

