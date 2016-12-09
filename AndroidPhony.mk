.PHONY: bootloader.img
bootloader.img: build_bootloaderimg

.PHONY: gpt.bin
gpt.bin: makegpt
