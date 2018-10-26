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

# Binary distribution of bolt, BSU, bootloader and boot images
export BCM_BINDIST_BL_ROOT  := vendor/broadcom/bindist/blimg/vmx/${LOCAL_PRODUCT_OUT}

# Comment out the line below to disable pre-built boot images
export BCM_DIST_BLIMG_BINS  := y

# Copy over the signed AVB bolt, AVB BSU and boot images (if they exist)
ifneq ($(wildcard ${TOP}/${BCM_BINDIST_BL_ROOT}/boot-signed.img),)
PRODUCT_COPY_FILES += \
    ${BCM_BINDIST_BL_ROOT}/android_bsu-vb.signed.elf:$(PRODUCT_OUT_FROM_TOP)/android_bsu-vb.signed.elf \
    ${BCM_BINDIST_BL_ROOT}/bolt-vb.signed.bin:$(PRODUCT_OUT_FROM_TOP)/bolt-vb.signed.bin \
    ${BCM_BINDIST_BL_ROOT}/boot-signed.img:$(PRODUCT_OUT_FROM_TOP)/boot-signed.img
endif

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

