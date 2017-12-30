# Brcm NIC related defines
BRCM_NIC_PATH      := ${BRCMSTB_ANDROID_VENDOR_PATH}/bcm_platform/brcm_nic
BRCM_NIC_KO_NAME   := wl.ko
BRCM_NIC_NVRAM_DIR ?= ${BROADCOM_NIC_SOURCE_PATH}/components/nvram
ifeq ($(TARGET_PRODUCT), b71wlan%)
BRCM_NIC_NVRAM_NAME ?= bcm97271wlan.txt
BRCM_NIC_TARGET_NAME := apdef-stadef-extnvm-p2p-mchan-tdls-mfp-wowl-cfg80211-android-stbsoc
else
BRCM_NIC_NVRAM_NAME ?= bcm97271sv.txt
BRCM_NIC_TARGET_NAME := apdef-stadef-extnvm-p2p-mchan-tdls-mfp-wowl-cfg80211-android-slvradar-stbsoc
endif

${B_NIC_OBJ_ROOT}:
	mkdir -p ${B_NIC_OBJ_ROOT}

ifneq ($(BCM_DIST_KNLIMG_BINS),y)
${B_NIC_OBJ_ROOT}/driver/wl.ko: bindist_build ${B_NIC_OBJ_ROOT}
	@echo "wl-nic.ko build done..."

endif

${B_NIC_OBJ_ROOT}/nvram.txt: ${BRCM_NIC_NVRAM_DIR}/${BRCM_NIC_NVRAM_NAME} ${B_NIC_OBJ_ROOT}
	cp -p $< $@

.PHONY: brcm_nic_driver
brcm_nic_driver: ${BRCM_NIC_DRIVER_TARGETS}
	@echo "'brcm_nic_driver' targets: ${BRCM_NIC_DRIVER_TARGETS}"

.PHONY: clean_brcm_nic_driver
clean_brcm_nic_driver:
	@if [ -d "${B_NIC_OBJ_ROOT}" ]; then \
		rm -rf ${B_NIC_OBJ_ROOT}; \
	fi

