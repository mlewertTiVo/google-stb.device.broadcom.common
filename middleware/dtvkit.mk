export DTVKIT_DVBCORE_ROOT=$(ANDROID_BUILD_TOP)/external/DVBCore
export DTVKIT_PLATFORM_ROOT=$(ANDROID_BUILD_TOP)/vendor/broadcom/bcm_platform/DTVKitPlatform

PRODUCT_OUT ?= out/target/product/$(ANDROID_PRODUCT_OUT)
export DTVKIT_OUTPUT_DIR = $(ANDROID_BUILD_TOP)/$(PRODUCT_OUT)/obj/dtvkit
export DTVKIT_H265_BUILD = y

DTVKIT_LIBS := \
	$(DTVKIT_OUTPUT_DIR)/bin/libdvbcore.a \
	$(DTVKIT_OUTPUT_DIR)/debug_libs/libdvb_hw.a \
	$(DTVKIT_OUTPUT_DIR)/debug_libs/libdvb_os.a \
	$(DTVKIT_OUTPUT_DIR)/debug_libs/libdvb_version.a

$(DTVKIT_LIBS): dtvkit

refsw: dtvkit

clean: clean_dtvkit

dtvkit:
	make \
		-C $(DTVKIT_PLATFORM_ROOT)/build \
		NEXUS_TOP=$(ANDROID_BUILD_TOP)/vendor/broadcom/refsw/nexus \
		platform dvbcore

clean_dtvkit:
	echo cleaning dtvkit
	make \
		-C $(DTVKIT_PLATFORM_ROOT)/build \
		NEXUS_TOP=$(ANDROID_BUILD_TOP)/vendor/broadcom/refsw/nexus \
		clean-platform clean-dvbcore
