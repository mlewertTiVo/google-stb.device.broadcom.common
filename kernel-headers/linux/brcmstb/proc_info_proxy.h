/****************************************************************************
 ****************************************************************************
 ***
 ***   This header was automatically generated from a Linux kernel header
 ***   of the same name, to make information necessary for userspace to
 ***   call into the kernel available to libc.  It contains only constants,
 ***   structures, and macros generated from the original header, and thus,
 ***   contains no copyrightable information.
 ***
 ***   To edit the content of this header, modify the corresponding
 ***   source file (e.g. under external/kernel-headers/original/) then
 ***   run bionic/libc/kernel/tools/update_all.py
 ***
 ***   Any manual change here will be lost the next time this script will
 ***   be run. You've been warned!
 ***
 ****************************************************************************
 ****************************************************************************/
#ifndef __PROC_INFO_PROXY_H__
#define __PROC_INFO_PROXY_H__
#define PROC_INFO_PROXY 'z'
#define PROC_INFO_PROXY_GET_OOMADJ 0x100
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
#define PROC_INFO_PROXY_GET_MEMTRACK 0x101
#define PROC_INFO_PROXY_SET_MEMTRACK 0x102
struct proxy_info_oomadj {
  __u32 pid;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  __s32 score;
};
struct proxy_info_memtrack {
  __u32 pid;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  __u32 size;
  __s32 act;
};
#define PROC_INFO_IOCTL_PROXY_GET_OOMADJ _IOW(PROC_INFO_PROXY, PROC_INFO_PROXY_GET_OOMADJ, struct proxy_info_oomadj)
#define PROC_INFO_IOCTL_PROXY_GET_MEMTRACK _IOW(PROC_INFO_PROXY, PROC_INFO_PROXY_GET_MEMTRACK, struct proxy_info_memtrack)
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
#define PROC_INFO_IOCTL_PROXY_SET_MEMTRACK _IOW(PROC_INFO_PROXY, PROC_INFO_PROXY_SET_MEMTRACK, struct proxy_info_memtrack)
#endif


