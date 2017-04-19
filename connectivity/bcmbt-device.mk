# This makefile copies the prebuilt BT firmware and configuration files

ifeq ($(ANDROID_ENABLE_BT),usb)
PRODUCT_COPY_FILES += ${BCM_VENDOR_STB_ROOT}/bcm_platform/conx/btusb/bt_vendor.conf:system/etc/bluetooth/bt_vendor.conf

ifeq ($(BROADCOM_WIFI_CHIPSET),43242a1)
PRODUCT_COPY_FILES += \
    ${BCM_VENDOR_STB_ROOT}/bcm_platform/conx/btusb/firmware/BCM43242A1_001.002.007.0077.0000_Generic_USB_Class2_Generic_3DTV_TBFC_37_4MHz_Wake_on_BLE_Hisense.hcd:vendor/broadcom/btusb/firmware/BCM_bt_fw.hcd
endif

ifeq ($(BROADCOM_WIFI_CHIPSET),43570a0)
PRODUCT_COPY_FILES += \
    ${BCM_VENDOR_STB_ROOT}/bcm_platform/conx/btusb/firmware/BCM43569A0_001.001.009.0039.0000_Generic_USB_40MHz_fcbga_BU_TXPwr_8dbm_4.hcd:vendor/broadcom/btusb/firmware/BCM_bt_fw.hcd
endif

ifeq ($(BROADCOM_WIFI_CHIPSET),43570a2)
PRODUCT_COPY_FILES += \
    ${BCM_VENDOR_STB_ROOT}/bcm_platform/conx/btusb/firmware/BCM43569A2_001.003.004.0074.0000_Generic_USB_40MHz_fcbga_BU_WakeOn_BLE_Google.hcd:vendor/broadcom/btusb/firmware/BCM_bt_fw.hcd
endif

else # BT UART
PRODUCT_COPY_FILES += device/broadcom/common/rcs/init.bcm.bt.rc:root/init.brcm_bt.rc
PRODUCT_COPY_FILES += ${BCM_VENDOR_STB_ROOT}/bcm_platform/conx/btuart/bt_vendor.conf:system/etc/bluetooth/bt_vendor.conf
PRODUCT_COPY_FILES += ${BCM_VENDOR_STB_ROOT}/bcm_platform/conx/btuart/firmware/BCM20703A1_001.001.005.0357.0720_UART_20MHz_WakeOnBle_Google.hcd:vendor/broadcom/btuart/firmware/BCM_bt_fw.hcd
endif # $(ANDROID_ENABLE_BT)

PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.bluetooth.xml:system/etc/permissions/android.hardware.bluetooth.xml \
    frameworks/native/data/etc/android.hardware.bluetooth_le.xml:system/etc/permissions/android.hardware.bluetooth_le.xml

ifneq ($(BT_RFKILL_SUPPORT),y)
PRODUCT_PROPERTY_OVERRIDES += \
    ro.rfkilldisabled=1
endif

PRODUCT_PACKAGES += \
    audio.a2dp.default
