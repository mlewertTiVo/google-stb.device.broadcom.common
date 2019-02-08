ifeq ($(LOCAL_NVI_LAYOUT),y)

PRODUCT_TREBLE_LINKER_NAMESPACES := false
PRODUCT_USE_VNDK_OVERRIDE        := false

PRODUCT_PACKAGES += sepolicy \
                    libyuv \
                    libpuresoftkeymasterdevice \
                    android.hardware.wifi@1.1 \
                    android.hardware.wifi@1.2 \
                    android.hardware.soundtrigger@2.0-core

endif

