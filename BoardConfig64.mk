TARGET_ARCH               := arm64
TARGET_ARCH_VARIANT       := armv8-a
TARGET_CPU_ABI            := arm64-v8a
TARGET_CPU_ABI2           :=
TARGET_CPU_VARIANT        := cortex-a53
TARGET_CPU_SMP            := true

ifeq ($(LOCAL_ANDROID_64BIT_ONLY),y)
TARGET_2ND_ARCH           :=
TARGET_2ND_ARCH_VARIANT   :=
TARGET_2ND_CPU_ABI        :=
TARGET_2ND_CPU_ABI2       :=
TARGET_2ND_CPU_VARIANT    :=
else
TARGET_2ND_ARCH           := arm
TARGET_2ND_ARCH_VARIANT   := armv7-a-neon
TARGET_2ND_CPU_ABI        := armeabi-v7a
TARGET_2ND_CPU_ABI2       := armeabi
TARGET_2ND_CPU_VARIANT    := cortex-a15
endif

TARGET_USES_64_BIT_BCMDHD := true
TARGET_USES_64_BIT_BINDER := true

