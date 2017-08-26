export BCM_BINDIST_ROOT            := ${ANDROID}/${BCM_VENDOR_STB_ROOT}/bindist

# by default, always build from source.
export BCM_DIST_SOURCE_ONLY        ?= y
export BCM_DIST_FORCED_BINDIST     ?= n

# bootloader images, built from source if available, unless forced to use bins.
ifneq ($(wildcard vendor/broadcom/bolt),)
ifeq ($(BCM_DIST_FORCED_BINDIST), y)
export BCM_DIST_BLIMG_BINS        := y
export BCM_DIST_SOURCE_ONLY       := n
else
export BCM_DIST_BLIMG_BINS        := n
endif
else
export BCM_DIST_BLIMG_BINS        := y
export BCM_DIST_SOURCE_ONLY       := n
endif

# kernel images (and modules), built from source if available, unless forced to use bins.
ifneq ($(wildcard ${LINUX}/Makefile),)
ifeq ($(BCM_DIST_FORCED_BINDIST), y)
export BCM_DIST_KNLIMG_BINS       := y
export BCM_DIST_SOURCE_ONLY       := n
else
export BCM_DIST_KNLIMG_BINS       := n
endif
else
export BCM_DIST_KNLIMG_BINS       := y
export BCM_DIST_SOURCE_ONLY       := n
endif
