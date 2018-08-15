include ${NEXUS_TOP}/platforms/common/build/nexus_platforms.inc

MAGNUM=${MAGNUM_TOP}
include ${MAGNUM_TOP}/basemodules/dsp/bdsp.inc

print-env:
	@echo ${${ENV_TO_PRINT}}
