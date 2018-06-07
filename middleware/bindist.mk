export BCM_BINDIST_LIBS_ROOT       ?= ${ANDROID}/${BCM_VENDOR_STB_ROOT}/bindist/nximg/${LOCAL_LINUX_VERSION_NODASH}/${TARGET_BOARD_PLATFORM}
export BCM_BINDIST_KNL_ROOT        ?= ${ANDROID}/${BCM_VENDOR_STB_ROOT}/bindist/knlimg/${LOCAL_LINUX_VERSION_NODASH}/${TARGET_BOARD_PLATFORM}
export BCM_BINDIST_BL_ROOT         ?= ${ANDROID}/${BCM_VENDOR_STB_ROOT}/bindist/blimg/${TARGET_BOARD_PLATFORM}
export BCM_DIST_FORCED_BINDIST     ?= n

# bootloader.
BCM_DIST_BLIMS_SRCS                ?= n
ifneq ($(wildcard vendor/broadcom/bolt),)
ifneq ($(wildcard ${B_KNB_TOOLCHAIN}),)
BCM_DIST_BLIMS_SRCS                := y
endif
endif

ifeq ($(BCM_DIST_BLIMS_SRCS), y)
export BCM_DIST_BLIMG_BINS        := n
else
ifeq ($(BCM_DIST_FORCED_BINDIST), y)
export BCM_DIST_BLIMG_BINS        := y
endif
endif

# kernel + ko's + nexus user libraries.
BCM_DIST_KNLIMS_SRCS              ?= n
ifneq ($(wildcard ${LINUX}/Makefile),)
ifneq ($(wildcard ${B_KNB_TOOLCHAIN}),)
BCM_DIST_KNLIMS_SRCS              := y
endif
endif

ifeq ($(BCM_DIST_KNLIMS_SRCS), y)
export BCM_DIST_KNLIMG_BINS       := n
else
ifeq ($(BCM_DIST_FORCED_BINDIST), y)
export BCM_DIST_KNLIMG_BINS       := y
endif
endif
