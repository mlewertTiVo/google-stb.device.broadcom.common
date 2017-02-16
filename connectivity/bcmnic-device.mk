# This makefile copies the prebuilt wifi driver moduel and corresponding firmware and configuration files
BRCM_NIC_DRIVER_TARGETS := \
	${B_NIC_OBJ_ROOT}/driver/wl.ko \
	${B_NIC_OBJ_ROOT}/nvram.txt

PRODUCT_COPY_FILES += \
    ${B_NIC_OBJ_ROOT}/driver/wl.ko:vendor/broadcom/nic/driver/wl.ko \
    ${B_NIC_OBJ_ROOT}/nvram.txt:vendor/broadcom/nvrams/nvram.txt \
    ${BCM_VENDOR_STB_ROOT}/bcm_platform/conx/nic/init.brcm_nic.rc:root/init.brcm_nic.rc

PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.wifi.xml:system/etc/permissions/android.hardware.wifi.xml \
    ${BCM_VENDOR_STB_ROOT}/bcm_platform/conx/nic/wpa_supplicant.conf:system/etc/wifi/wpa_supplicant.conf \
    ${BCM_VENDOR_STB_ROOT}/bcm_platform/conx/nic/p2p_supplicant.conf:system/etc/wifi/p2p_supplicant.conf \
    ${BCM_VENDOR_STB_ROOT}/bcm_platform/conx/nic/wpa_supplicant_overlay.conf:system/etc/wifi/wpa_supplicant_overlay.conf \
    ${BCM_VENDOR_STB_ROOT}/bcm_platform/conx/nic/p2p_supplicant_overlay.conf:system/etc/wifi/p2p_supplicant_overlay.conf

PRODUCT_PACKAGES += \
    dhcpcd.conf \
    network \
    wpa_supplicant

PRODUCT_PROPERTY_OVERRIDES += \
   wifi.interface=wlan0

