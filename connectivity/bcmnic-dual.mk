# Brcm NIC related defines
BRCM_NIC_PATH      := ${BRCMSTB_ANDROID_VENDOR_PATH}/bcm_platform/brcm_nic
BRCM_NIC_KO_NAME   := wl.ko
BRCM_NIC_NVRAM_DIR ?= ${BROADCOM_NIC_DUAL_SOURCE_PATH}/stub
BRCM_NIC_NVRAM_NAME ?= nv-stub.txt
BRCM_NIC_DUAL_TARGET ?= nodebug-apdef-stadef-p2p-mchan-tdls-wowl-mfp-stb-armv7l-cfg80211
BRCM_NIC_DUAL_CHIPVER :=

${B_NIC_DUAL_OBJ_ROOT}:
	mkdir -p ${B_NIC_DUAL_OBJ_ROOT}

ifneq ($(BCM_DIST_KNLIMG_BINS),y)
${B_NIC_DUAL_OBJ_ROOT}/driver/wl.ko: bindist_build ${B_NIC_DUAL_OBJ_ROOT}
   @echo "wl-nic-dual.ko build done..."

endif

${B_NIC_DUAL_OBJ_ROOT}/nvram.txt: ${BRCM_NIC_NVRAM_DIR}/${BRCM_NIC_NVRAM_NAME} ${B_NIC_DUAL_OBJ_ROOT}
	cp -p $< $@

.PHONY: clean_brcm_nic_dual_driver
clean_brcm_nic_dual_driver:
	@if [ -d "${B_NIC_DUAL_OBJ_ROOT}" ]; then \
		rm -rf ${B_NIC_DUAL_OBJ_ROOT}; \
	fi

