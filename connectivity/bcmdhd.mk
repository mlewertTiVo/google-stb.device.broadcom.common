# Brcm DHD related defines
BRCM_DHD_PATH      := ${BRCMSTB_ANDROID_VENDOR_PATH}/bcm_platform/brcm_dhd
BRCM_DHD_KO_NAME   := bcmdhd.ko
BRCM_DHD_NVRAM_DIR ?= ${BROADCOM_DHD_SOURCE_PATH}/nvrams
BRCM_DHD_TARGET_NVRAM_PATH := "/hwcfg/nvm.txt"
ifeq ($(BROADCOM_WIFI_CHIPSET), 4365b1)
BRCM_DHD_FW_NAME    ?= pcie-ag-pktctx-splitrx-amsdutx-txbf-p2p-mchan-idauth-idsup-tdls-mfp-sr-proptxstatus-wowlpf-pktfilter-ampduhostreorder-chkd2hdma-ringer-dmaindex16-keepalive.bin
BRCM_DHD_NVRAM_NAME ?= bcm4365.nvm
endif
ifeq ($(BROADCOM_WIFI_CHIPSET), 4366c0)
BRCM_DHD_FW_NAME    ?= pcie-ag-pktctx-splitrx-amsdutx-idauth-idsup-tdls-txbf-p2p-mchan-mfp-sr-proptxstatus-wowlpf-pktfilter-ampduhostreorder-keepalive-chkd2hdma-ringer-dmaindex16.bin
BRCM_DHD_NVRAM_NAME ?= bcm4365.nvm
endif
ifeq ($(BROADCOM_WIFI_CHIPSET), 43602a1)
BRCM_DHD_FW_NAME    ?= pcie-ag-pktctx-splitrx-amsdutx-txbf-p2p-mchan-idauth-idsup-tdls-mfp-sr-proptxstatus-pktfilter-wowlpf-ampduhostreorder-keepalive-btcxgci48bits.bin
BRCM_DHD_NVRAM_NAME ?= bcm43602.nvm
endif
ifeq ($(BROADCOM_WIFI_CHIPSET), 43570a2)
BRCM_DHD_FW_NAME    ?= pcie-ag-pktctx-splitrx-amsdutx-txbf-p2p-mchan-idauth-idsup-tdls-mfp-sr-proptxstatus-pktfilter-wowlpf-ampduhostreorder-keepalive-wfds-bdo-ak.bin
BRCM_DHD_NVRAM_NAME ?= bcm43570_7252SSFFG.nvm
endif
ifeq ($(BROADCOM_WIFI_CHIPSET), 43570a0)
BRCM_DHD_FW_NAME    ?= pcie-ag-pktctx-splitrx-amsdutx-txbf-p2p-mchan-idauth-idsup-tdls-mfp-sr-proptxstatus-pktfilter-wowlpf-ampduhostreorder-keepalive-wfds.bin
BRCM_DHD_NVRAM_NAME ?= bcm43570.nvm
endif
ifeq ($(BROADCOM_WIFI_CHIPSET), 43569a0)
BRCM_DHD_FW_NAME    ?= usb-ag-pool-pktctx-dmatxrc-idsup-idauth-keepalive-txbf-p2p-mchan-mfp-pktfilter-wowlpf-tdls-proptxstatus-vusb-wfds.bin.trx
BRCM_DHD_NVRAM_NAME ?= bcm43569.nvm
endif
ifeq ($(BROADCOM_WIFI_CHIPSET), 43569a2)
BRCM_DHD_FW_NAME    ?= usb-ag-pool-pktctx-dmatxrc-idsup-idauth-keepalive-txbf-p2p-mchan-mfp-pktfilter-wowlpf-tdls-proptxstatus-vusb-wfds-sr.bin.trx
BRCM_DHD_NVRAM_NAME ?= bcm43569.nvm
endif
ifeq ($(BROADCOM_WIFI_CHIPSET), 43242a1)
BRCM_DHD_FW_NAME    ?= usb-ag-p2p-mchan-idauth-idsup-keepalive-pktfilter-wowlpf-tdls-srvsdb-pclose-proptxstatus-vusb-nodis.bin.trx
BRCM_DHD_NVRAM_NAME ?= bcm943242usbref_p461_comp.txt
endif
ifeq ($(BROADCOM_WIFI_CHIPSET), 43236b)
BRCM_DHD_FW_NAME    ?= ag-p2p-apsta-idsup-af-idauth.bin.trx
BRCM_DHD_NVRAM_NAME ?= fake43236usb_p532.nvm
endif

${B_DHD_OBJ_ROOT}:
	mkdir -p ${B_DHD_OBJ_ROOT}

${B_DHD_OBJ_ROOT}/driver/bcmdhd.ko: build_kernel ${B_DHD_OBJ_ROOT}
	cp -faR ${BROADCOM_DHD_SOURCE_PATH}/dhd ${B_DHD_OBJ_ROOT} && cp ${BROADCOM_DHD_SOURCE_PATH}/*.sh ${B_DHD_OBJ_ROOT}
	cd ${B_DHD_OBJ_ROOT} && source ./setenv-android-stb7445.sh ${BROADCOM_WIFI_CHIPSET} && LINUX_OUT=${LINUX_OUT_1ST_ARCH} BRCM_DHD_TARGET_NVRAM_PATH=${BRCM_DHD_TARGET_NVRAM_PATH} ./bfd-drv-cfg80211.sh

${B_DHD_OBJ_ROOT}/fw.bin.trx: ${BROADCOM_DHD_SOURCE_PATH}/firmware/${BROADCOM_WIFI_CHIPSET}-roml/${BRCM_DHD_FW_NAME} ${B_DHD_OBJ_ROOT}
	cp -p $< $@

${B_DHD_OBJ_ROOT}/nvm.txt: ${BRCM_DHD_NVRAM_DIR}/${BRCM_DHD_NVRAM_NAME} ${B_DHD_OBJ_ROOT}
	cp -p $< $@

.PHONY: brcm_dhd_driver
brcm_dhd_driver: ${BRCM_DHD_DRIVER_TARGETS}
	@echo "'brcm_dhd_driver' targets: ${BRCM_DHD_DRIVER_TARGETS}"

.PHONY: clean_brcm_dhd_driver
clean_brcm_dhd_driver:
	@if [ -d "${B_DHD_OBJ_ROOT}" ]; then \
		rm -rf ${B_DHD_OBJ_ROOT}; \
	fi

