# configuration for trusty support.

export LKROOT := ${ANDROID}/external/lk

export LKINC :=  \
        ${ANDROID}/lk/trusty \
        ${ANDROID}/external/lk \
        ${ANDROID}/external/headers \
        ${ANDROID}/app \
        ${ANDROID}/external \
        ${ANDROID}/lib \
        ${ANDROID}/system/gatekeeper \
        ${ANDROID}/hardware/libhardware \
        ${ANDROID}/device/broadcom/common/lk

# requires N-7  ${ANDROID}/system/keymaster \

