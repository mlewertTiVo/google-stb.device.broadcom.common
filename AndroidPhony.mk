.PHONY: bootloader.img
bootloader.img: build_bootloaderimg

.PHONY: bootloader.dev.img
bootloader.dev.img: build_bootloaderimg

.PHONY: bootloader.prod.img
bootloader.prod.img: bootloader.dev.img

.PHONY: gpt.bin
gpt.bin: makegpt
