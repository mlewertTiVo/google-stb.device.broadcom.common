# This makefile copies the prebuilt wifi driver moduel and corresponding firmware and configuration files
BRCM_DHD_DRIVER_TARGETS := \
	${B_DHD_OBJ_ROOT}/driver/bcmdhd.ko \
	${B_DHD_OBJ_ROOT}/fw.bin.trx \
	${B_DHD_OBJ_ROOT}/nvm.txt

PRODUCT_COPY_FILES += \
    ${B_DHD_OBJ_ROOT}/driver/bcmdhd.ko:vendor/lib/modules/bcmdhd.ko \
    ${B_DHD_OBJ_ROOT}/fw.bin.trx:vendor/firmware/broadcom/dhd/firmware/fw.bin.trx \
    ${B_DHD_OBJ_ROOT}/nvm.txt:vendor/firmware/broadcom/dhd/nvrams/nvm.txt \
    ${BCM_VENDOR_STB_ROOT}/bcm_platform/conx/dhd/init.brcm_dhd.rc:root/init.brcm_dhd.rc

PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.wifi.xml:system/etc/permissions/android.hardware.wifi.xml \
    ${BCM_VENDOR_STB_ROOT}/bcm_platform/conx/dhd/wpa_supplicant.conf:system/etc/wifi/wpa_supplicant.conf \
    ${BCM_VENDOR_STB_ROOT}/bcm_platform/conx/dhd/p2p_supplicant.conf:system/etc/wifi/p2p_supplicant.conf \
    ${BCM_VENDOR_STB_ROOT}/bcm_platform/conx/dhd/wpa_supplicant_overlay.conf:system/etc/wifi/wpa_supplicant_overlay.conf \
    ${BCM_VENDOR_STB_ROOT}/bcm_platform/conx/dhd/p2p_supplicant_overlay.conf:system/etc/wifi/p2p_supplicant_overlay.conf

PRODUCT_PACKAGES += \
    bcmdl \
    dhcpcd.conf \
    network \
    wpa_supplicant

PRODUCT_PROPERTY_OVERRIDES += \
   wifi.interface=wlan0

