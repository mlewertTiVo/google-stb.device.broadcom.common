# Brcm DHD related defines
BRCM_DHD_PATH      := ${BRCMSTB_ANDROID_VENDOR_PATH}/bcm_platform/brcm_dhd
BRCM_DHD_KO_NAME   := bcmdhd.ko
BRCM_DHD_NVRAM_DIR ?= ${BROADCOM_DHD_SOURCE_PATH}/nvrams
BRCM_DHD_TARGET_NVRAM_PATH := "/dev/hwcfg/nvm.txt"
ifeq ($(BROADCOM_WIFI_CHIPSET), 4365b1)
BRCM_DHD_FW_NAME    ?= pcie-ag-pktctx-splitrx-amsdutx-txbf-p2p-mchan-idauth-idsup-tdls-mfp-sr-proptxstatus-wowlpf-pktfilter-ampduhostreorder-chkd2hdma-ringer-dmaindex16-keepalive.bin
BRCM_DHD_NVRAM_NAME ?= bcm4365.nvm
endif
ifeq ($(BROADCOM_WIFI_CHIPSET), 4366c0)
BRCM_DHD_FW_NAME    ?= pcie-ag-pktctx-splitrx-amsdutx-idauth-idsup-tdls-txbf-p2p-mchan-mfp-sr-proptxstatus-wowlpf-pktfilter-ampduhostreorder-keepalive-chkd2hdma-ringer-dmaindex16.bin
BRCM_DHD_NVRAM_NAME ?= bcm4365.nvm
endif
ifeq ($(BROADCOM_WIFI_CHIPSET), 43602a1)
BRCM_DHD_FW_NAME    ?= pcie-ag-pktctx-splitrx-amsdutx-txbf-p2p-mchan-idauth-idsup-tdls-mfp-sr-proptxstatus-pktfilter-wowlpf-ampduhostreorder-keepalive-slvradar-wnmbsstrans-gtkoe.bin
BRCM_DHD_NVRAM_NAME ?= fake43602.txt
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

ifneq ($(BCM_DIST_KNLIMG_BINS),y)
${B_DHD_OBJ_ROOT_REL}/driver/bcmdhd.ko: bindist_build
	@echo "bcmdhd.ko build done..."

endif

${B_DHD_OBJ_ROOT_REL}/fw.bin.trx: ${BROADCOM_DHD_SOURCE_PATH}/firmware/${BROADCOM_WIFI_CHIPSET}-roml/${BRCM_DHD_FW_NAME}
	cp -p $< $@

${B_DHD_OBJ_ROOT_REL}/nvm.txt: ${BRCM_DHD_NVRAM_DIR}/${BRCM_DHD_NVRAM_NAME}
	cp -p $< $@

.PHONY: brcm_dhd_driver
brcm_dhd_driver: ${BRCM_DHD_DRIVER_TARGETS}
	@echo "'brcm_dhd_driver' targets: ${BRCM_DHD_DRIVER_TARGETS}"

.PHONY: clean_brcm_dhd_driver
clean_brcm_dhd_driver:
	@if [ -d "${B_DHD_OBJ_ROOT_REL}" ]; then \
		rm -rf ${B_DHD_OBJ_ROOT_REL}; \
	fi

