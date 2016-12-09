# device specific configuration for the little kernel TEE.

export KERNEL_32BIT := false
export DEFAULT_PROJECT := ${LOCAL_LK_DEVICE}
export ARCH_arm_TOOLCHAIN_PREFIX := ${ANDROID_TOP}/prebuilts/gcc/linux-x86/arm/arm-eabi-4.8/bin/arm-eabi-
export ARCH_arm64_TOOLCHAIN_PREFIX := ${ANDROID_TOP}/prebuilts/gcc/linux-x86/aarch64/aarch64-linux-android-4.9/bin/aarch64-linux-android-

# verbose build log from lk/trusty.
#export NOECHO :=

include ${ANDROID_TOP}/device/broadcom/common/lk/project/bcm-arm-inc.mk

