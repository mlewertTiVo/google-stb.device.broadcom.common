TARGET_ARCH             := arm
TARGET_ARCH_VARIANT     := armv7-a-neon
TARGET_CPU_VARIANT      := cortex-a15
TARGET_CPU_ABI          := armeabi-v7a
TARGET_CPU_ABI2         := armeabi
TARGET_CPU_SMP          := true

ifeq ($(LOCAL_ARM_AARCH64_COMPAT_32_BIT),y)
# 32bit user mode with 64bit kernel.
TARGET_USES_64_BIT_BINDER := true
endif
