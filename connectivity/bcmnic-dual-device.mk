# This makefile copies the prebuilt wifi driver moduel and corresponding firmware and configuration files

PRODUCT_COPY_FILES += \
   ${B_NIC_DUAL_OBJ_ROOT}/nvram.txt:$(TARGET_COPY_OUT_VENDOR)/broadcom/nvrams/nvram.txt \
   ${BCM_VENDOR_STB_ROOT}/bcm_platform/conx/nic-dual/init.brcm_nic.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/init.brcm_nic.rc

ifneq ($(BCM_DIST_KNLIMG_BINS),y)
PRODUCT_COPY_FILES += \
   ${B_NIC_DUAL_OBJ_ROOT}/driver/wl.ko:$(TARGET_COPY_OUT_VENDOR)/lib/modules/wl.ko
else
PRODUCT_COPY_FILES += \
   ${BCM_BINDIST_ROOT}/knlimg/${LOCAL_LINUX_VERSION_NODASH}/mods/$(TARGET_BOARD_PLATFORM)/wl.ko:$(TARGET_COPY_OUT_VENDOR)/lib/modules/wl.ko
endif

PRODUCT_COPY_FILES += \
   frameworks/native/data/etc/android.hardware.wifi.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.wifi.xml \
   ${BCM_VENDOR_STB_ROOT}/bcm_platform/conx/nic-dual/wpa_supplicant.conf:system/etc/wifi/wpa_supplicant.conf \
   ${BCM_VENDOR_STB_ROOT}/bcm_platform/conx/nic/p2p_supplicant.conf:system/etc/wifi/p2p_supplicant.conf \
   ${BCM_VENDOR_STB_ROOT}/bcm_platform/conx/nic/wpa_supplicant_overlay.conf:system/etc/wifi/wpa_supplicant_overlay.conf \
   ${BCM_VENDOR_STB_ROOT}/bcm_platform/conx/nic/p2p_supplicant_overlay.conf:system/etc/wifi/p2p_supplicant_overlay.conf

PRODUCT_PACKAGES += \
   dhcpcd.conf \
   network \
   wpa_supplicant

PRODUCT_PROPERTY_OVERRIDES += \
   wifi.interface=wlan1

