# This makefile copies the prebuilt BT firmware and configuration files

ifeq ($(ANDROID_ENABLE_BT),usb)

ifeq ($(BROADCOM_WIFI_CHIPSET),43242a1)
PRODUCT_COPY_FILES += \
    ${BCM_VENDOR_STB_ROOT}/bcm_platform/conx/btusb/firmware/BCM43242A1_001.002.007.0077.0000_Generic_USB_Class2_Generic_3DTV_TBFC_37_4MHz_Wake_on_BLE_Hisense.hcd:$(TARGET_COPY_OUT_VENDOR)/firmware/BCM43242.hcd
endif

ifeq ($(BROADCOM_WIFI_CHIPSET),43570a0)
PRODUCT_COPY_FILES += \
    ${BCM_VENDOR_STB_ROOT}/bcm_platform/conx/btusb/firmware/BCM43569A0_001.001.009.0039.0000_Generic_USB_40MHz_fcbga_BU_TXPwr_8dbm_4.hcd:$(TARGET_COPY_OUT_VENDOR)/firmware/BCM43569.hcd
endif

ifeq ($(BROADCOM_WIFI_CHIPSET),43570a2)
PRODUCT_COPY_FILES += \
    ${BCM_VENDOR_STB_ROOT}/bcm_platform/conx/btusb/firmware/BCM43569A2_001.003.004.0138.0000_Generic_USB_40MHz_fcbga_BU_WakeOn_BLE_Google_BT4_2.hcd:$(TARGET_COPY_OUT_VENDOR)/firmware/BCM43569.hcd
endif

else # BT UART

ifneq ($(LOCAL_NVI_LAYOUT),y)
PRODUCT_COPY_FILES += device/broadcom/common/rcs/init.bcm.bt.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/init.brcm_bt.rc
else
PRODUCT_COPY_FILES += device/broadcom/common/rcs/init.bcm.bt.rc:root/init.brcm_bt.rc
endif
PRODUCT_COPY_FILES += ${BCM_VENDOR_STB_ROOT}/bcm_platform/conx/btuart/firmware/20703A1_Generic_UART_20MHz_fcbga_BU_Wake_On_BLE_Google.hcd:$(TARGET_COPY_OUT_VENDOR)/firmware/BCM20703.hcd

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
