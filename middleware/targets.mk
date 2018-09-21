#
# list of targets generated by 'nexus build' which android integration depends on, we include
# the kernel modules in there as well as we bundle them with the 'nexus' build.  if nexus was
# opened-source, those kernel modules would not be needed as we could build the functionality
# directly into the kernel (exception being 'gator' which is third party).
#
# note: the leading '/' is expected to allow target rule matching for the prebuilt step in
# 'vendor/broadcom/bcm_platform/device-nexus.mk' in multi arch build.
#

ifeq ($(BCM_DIST_KNLIMG_BINS), y)
REFSW_TARGET_LIST := \
	${BINDIST_BIN_DIR_1ST_ARCH}/libnexus.so \
	${BINDIST_BIN_DIR_1ST_ARCH}/libnexus_static.a \
	${BINDIST_NXC_BIN_DIR_1ST_ARCH}/libnxclient.so \
	${BINDIST_NXC_BIN_DIR_1ST_ARCH}/libnxclient_static.a \
	${BINDIST_BIN_DIR_1ST_ARCH}/libnxserver.a \
	${BINDIST_BIN_DIR_1ST_ARCH}/libnxserver_vendor.a
else
REFSW_TARGET_LIST := \
	/${NEXUS_BIN_DIR_1ST_ARCH}/libnexus.so \
	/${NEXUS_BIN_DIR_1ST_ARCH}/libnexus_static.a \
	/${NEXUS_NXC_BIN_DIR_1ST_ARCH}/libnxclient.so \
	/${NEXUS_NXC_BIN_DIR_1ST_ARCH}/libnxclient_static.a \
	/${NEXUS_BIN_DIR_1ST_ARCH}/libnxserver.a \
	/${NEXUS_BIN_DIR_1ST_ARCH}/libnxserver_vendor.a
ifeq ($(LOCAL_ARM_TRUSTZONE_USE), y)
REFSW_TARGET_LIST += \
	/${NEXUS_BIN_DIR_1ST_ARCH}/swxpt.elf
endif
endif

ifeq ($(BCM_DIST_KNLIMG_BINS), y)
REFSW_TARGET_LIST += \
	${BCM_BINDIST_KNL_ROOT}/nexus.ko \
	${BCM_BINDIST_KNL_ROOT}/bcmnexusfb.ko \
	${BCM_BINDIST_KNL_ROOT}/nx_ashmem.ko \
	${BCM_BINDIST_KNL_ROOT}/droid_pm.ko
ifeq ($(HW_DVB_SUPPORT), y)
REFSW_TARGET_LIST += \
	${BCM_BINDIST_KNL_ROOT}/ldvbon.ko
endif
else
REFSW_TARGET_LIST += \
	${NEXUS_BIN_DIR_1ST_ARCH}/nexus.ko \
	${NEXUS_BIN_DIR_1ST_ARCH}/bcmnexusfb.ko \
	${NEXUS_BIN_DIR_1ST_ARCH}/nx_ashmem.ko \
	${NEXUS_BIN_DIR_1ST_ARCH}/droid_pm.ko
ifeq ($(HW_DVB_SUPPORT), y)
REFSW_TARGET_LIST += \
	${NEXUS_BIN_DIR_1ST_ARCH}/ldvbon.ko
endif
ifeq ($(LOCAL_GATOR_SUPPORT), y)
REFSW_TARGET_LIST += \
	${NEXUS_BIN_DIR_1ST_ARCH}/gator.ko
endif
ifeq ($(LOCAL_ARM_TRUSTZONE_USE), y)
REFSW_TARGET_LIST += \
	${NEXUS_BIN_DIR_1ST_ARCH}/bcm_astra.ko \
	${ASTRA_BIN_DIR}/astra64.bin
endif
endif

REFSW_TARGET_LIST_2ND_ARCH :=
ifeq ($(TARGET_2ND_ARCH),arm)
REFSW_TARGET_LIST_2ND_ARCH += \
	/${NEXUS_BIN_DIR_2ND_ARCH}/libnexus.so \
	/${NEXUS_BIN_DIR_2ND_ARCH}/libnexus_static.a \
	/${NEXUS_NXC_BIN_DIR_2ND_ARCH}/libnxclient.so \
	/${NEXUS_NXC_BIN_DIR_2ND_ARCH}/libnxclient_static.a \
	/${NEXUS_BIN_DIR_2ND_ARCH}/libnxserver.a \
	/${NEXUS_BIN_DIR_2ND_ARCH}/libnxserver_vendor.a
endif
