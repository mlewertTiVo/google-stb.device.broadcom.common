# This makefile copies the prebuilt wifi driver moduel and corresponding firmware and configuration files
BRCM_DHD_DRIVER_TARGETS := \
	${B_DHD_OBJ_ROOT}/fw.bin.trx \
	${B_DHD_OBJ_ROOT}/nvm.txt

PRODUCT_COPY_FILES += \
   ${B_DHD_OBJ_ROOT}/fw.bin.trx:$(TARGET_COPY_OUT_VENDOR)/firmware/broadcom/dhd/firmware/fw.bin.trx \
   ${B_DHD_OBJ_ROOT}/nvm.txt:$(TARGET_COPY_OUT_VENDOR)/firmware/broadcom/dhd/nvrams/nvm.txt

ifneq ($(LOCAL_NVI_LAYOUT),y)
PRODUCT_COPY_FILES += \
   ${BCM_VENDOR_STB_ROOT}/bcm_platform/conx/dhd/init.brcm_dhd.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/init.brcm_dhd.rc
else
PRODUCT_COPY_FILES += \
   ${BCM_VENDOR_STB_ROOT}/bcm_platform/conx/dhd/init.brcm_dhd.rc:root/init.brcm_dhd.rc
endif

ifneq ($(BCM_DIST_KNLIMG_BINS),y)
PRODUCT_COPY_FILES += \
   ${B_DHD_OBJ_ROOT}/driver/bcmdhd.ko:$(TARGET_COPY_OUT_VENDOR)/lib/modules/bcmdhd.ko
else
PRODUCT_COPY_FILES += \
   ${BCM_BINDIST_ROOT}/knlimg/${LOCAL_LINUX_VERSION_NODASH}/mods/$(TARGET_BOARD_PLATFORM)/bcmdhd.ko:$(TARGET_COPY_OUT_VENDOR)/lib/modules/bcmdhd.ko
endif

PRODUCT_COPY_FILES += \
   frameworks/native/data/etc/android.hardware.wifi.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.wifi.xml \
   ${BCM_VENDOR_STB_ROOT}/bcm_platform/conx/dhd/wpa_supplicant.conf:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/wpa_supplicant.conf \
   ${BCM_VENDOR_STB_ROOT}/bcm_platform/conx/dhd/wpa_supplicant_overlay.conf:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/wpa_supplicant_overlay.conf

PRODUCT_PACKAGES += \
   bcmdl \
   dhcpcd.conf \
   network

PRODUCT_PROPERTY_OVERRIDES += \
   wifi.interface=wlan0

