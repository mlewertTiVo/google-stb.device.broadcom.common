# This makefile copies the prebuilt BT firmware and configuration files

ifeq ($(ANDROID_ENABLE_BT),usb)

ifeq ($(BROADCOM_WIFI_CHIPSET),43570a2)
PRODUCT_COPY_FILES += \
    ${BCM_VENDOR_STB_ROOT}/bcm_platform/conx/btusb/firmware/BCM43569A2_001.003.004.0169.0000_Generic_USB_40MHz_fcbga_BU.hcd:$(TARGET_COPY_OUT_VENDOR)/firmware/BCM43569.hcd
endif

else # BT UART

COPY_2_VENDOR  ?= y
ifneq ($(HW_AB_UPDATE_SUPPORT),y)
ifeq ($(LOCAL_NVI_LAYOUT),y)
COPY_2_VENDOR := n
endif
endif
ifneq ($(COPY_2_VENDOR),n)
PRODUCT_COPY_FILES += device/broadcom/common/rcs/init.bcm.bt.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/init.brcm_bt.rc
else
PRODUCT_COPY_FILES += device/broadcom/common/rcs/init.bcm.bt.rc:root/init.brcm_bt.rc
endif
ifeq ($(BROADCOM_WIFI_CHIPSET),43570a2)
PRODUCT_COPY_FILES += ${BCM_VENDOR_STB_ROOT}/bcm_platform/conx/btuart/firmware/BCM43569A2_001.003.004.0169.0000_Generic_UART_40MHz_fcbga_BU.hcd:$(TARGET_COPY_OUT_VENDOR)/firmware/BCM43569.hcd
PRODUCT_COPY_FILES += ${BCM_VENDOR_STB_ROOT}/bcm_platform/conx/btuart/firmware/CYW20703A1_001.001.005.0401.0805.hcd:$(TARGET_COPY_OUT_VENDOR)/firmware/BCM20703.hcd
endif

endif # $(ANDROID_ENABLE_BT)

PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.bluetooth.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.bluetooth.xml \
    frameworks/native/data/etc/android.hardware.bluetooth_le.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.bluetooth_le.xml

ifneq ($(BT_RFKILL_SUPPORT),y)
PRODUCT_PROPERTY_OVERRIDES += \
    ro.rfkilldisabled=1
endif

PRODUCT_PACKAGES += \
    audio.a2dp.default
