.PHONY: bootloader.img
.PHONY: bootloader.dev.img
.PHONY: bootloader.prod.img
.PHONY: dtbo.img

ifneq ($(BCM_DIST_BLIMG_BINS),y)
.PHONY: gpt.bin
gpt.bin: makegpt
endif
