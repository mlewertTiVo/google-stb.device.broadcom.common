######################################
# Verimatrix Common CAS product file #
######################################

# Set top of VMX root dir
export VENDOR_VMX_ROOT ?= vendor/verimatrix

-include ${VENDOR_VMX_ROOT}/priv/common/product.mk

# Set top of VMX install root dir
export VENDOR_VMX_INSTALL_ROOT ?= ${VENDOR_VMX_ROOT}/install

# Set top of VMX product root dir
export VENDOR_VMX_PRODUCT_ROOT ?= ${VENDOR_VMX_INSTALL_ROOT}/${LOCAL_PRODUCT_OUT}

# Enable WIFI SECDMA
export ANDROID_ENABLE_DHD_SECDMA := y

# SAGE production binaries only
export LOCAL_DEVICE_SAGE_DEV_N_PROD := n
export SAGE_BINARY_EXT :=

# Default security/CA variant for VMX to UP
export LOCAL_DEVICE_SECURITY_VARIANT_DEV ?= up
export LOCAL_DEVICE_SECURITY_VARIANT_PROD ?= up

# Copy over the VMX SAGE TA
PRODUCT_COPY_FILES += \
    ${VENDOR_VMX_PRODUCT_ROOT}/TA/SDL_TA_verimatrix_ultra.bin:$(TARGET_COPY_OUT_VENDOR)/bin/SDL_TA_verimatrix_ultra.bin

PRODUCT_PACKAGES += \
    libcasproxyplugin \
    libsecurity_utils \
    libvmlogger \
    libvmutils \
    libvmxsessionmanager \
    libvmxtestcasplugin \
    libvriptvclientDEV \
    vmx_mediacas_testapp \
    bcm.hardware.casproxy@1.0-service

PRODUCT_PROPERTY_OVERRIDES += \
   ro.nx.heap.export=1m

