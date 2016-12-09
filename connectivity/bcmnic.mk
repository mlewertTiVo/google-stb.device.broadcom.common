# Brcm NIC related defines
BRCM_NIC_PATH      := ${BRCMSTB_ANDROID_VENDOR_PATH}/bcm_platform/brcm_nic
BRCM_NIC_KO_NAME   := wl.ko
BRCM_NIC_NVRAM_DIR ?= ${BROADCOM_NIC_SOURCE_PATH}/components/nvram
ifeq ($(TARGET_PRODUCT), BCM97271WLAN)
BRCM_NIC_NVRAM_NAME ?= bcm97271wlan.txt
else
BRCM_NIC_NVRAM_NAME ?= bcm97271sv.txt
endif

${B_NIC_OBJ_ROOT}:
	mkdir -p ${B_NIC_OBJ_ROOT}

${B_NIC_OBJ_ROOT}/driver/wl.ko: build_kernel ${B_NIC_OBJ_ROOT}
	cp -faR ${BROADCOM_NIC_SOURCE_PATH}/src ${B_NIC_OBJ_ROOT}  && cp ${BROADCOM_NIC_SOURCE_PATH}/*.sh ${B_NIC_OBJ_ROOT}
	cp -faR ${BROADCOM_NIC_SOURCE_PATH}/components ${B_NIC_OBJ_ROOT}
	cd ${B_NIC_OBJ_ROOT} && source ./setenv-android-stb7271.sh && ./build-drv-nic.sh apdef-stadef-extnvm-p2p-mchan-cfg80211-android-mfp-tdls-wowl-stb7271

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

