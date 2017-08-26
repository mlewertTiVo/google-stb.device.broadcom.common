.PHONY: bootloader.img
#bootloader.img: blimg
.PHONY: bootloader.dev.img
.PHONY: bootloader.prod.img

ifneq ($(BCM_DIST_BLIM_BINS),y)
.PHONY: gpt.bin
gpt.bin: makegpt
endif

