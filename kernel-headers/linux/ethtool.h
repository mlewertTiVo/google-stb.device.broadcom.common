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
#ifndef _UAPI_LINUX_ETHTOOL_H
#define _UAPI_LINUX_ETHTOOL_H
#include <linux/types.h>
#include <linux/if_ether.h>
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
struct ethtool_cmd {
  __u32 cmd;
  __u32 supported;
  __u32 advertising;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  __u16 speed;
  __u8 duplex;
  __u8 port;
  __u8 phy_address;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  __u8 transceiver;
  __u8 autoneg;
  __u8 mdio_support;
  __u32 maxtxpkt;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  __u32 maxrxpkt;
  __u16 speed_hi;
  __u8 eth_tp_mdix;
  __u8 eth_tp_mdix_ctrl;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  __u32 lp_advertising;
  __u32 reserved[2];
};
#define ETH_MDIO_SUPPORTS_C22 1
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
#define ETH_MDIO_SUPPORTS_C45 2
#define ETHTOOL_FWVERS_LEN 32
#define ETHTOOL_BUSINFO_LEN 32
#define ETHTOOL_EROMVERS_LEN 32
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
struct ethtool_drvinfo {
  __u32 cmd;
  char driver[32];
  char version[32];
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  char fw_version[ETHTOOL_FWVERS_LEN];
  char bus_info[ETHTOOL_BUSINFO_LEN];
  char erom_version[ETHTOOL_EROMVERS_LEN];
  char reserved2[12];
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  __u32 n_priv_flags;
  __u32 n_stats;
  __u32 testinfo_len;
  __u32 eedump_len;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  __u32 regdump_len;
};
#define SOPASS_MAX 6
struct ethtool_wolinfo {
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  __u32 cmd;
  __u32 supported;
  __u32 wolopts;
  __u8 sopass[SOPASS_MAX];
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
};
struct ethtool_value {
  __u32 cmd;
  __u32 data;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
};
enum tunable_id {
  ETHTOOL_ID_UNSPEC,
  ETHTOOL_RX_COPYBREAK,
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  ETHTOOL_TX_COPYBREAK,
};
enum tunable_type_id {
  ETHTOOL_TUNABLE_UNSPEC,
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  ETHTOOL_TUNABLE_U8,
  ETHTOOL_TUNABLE_U16,
  ETHTOOL_TUNABLE_U32,
  ETHTOOL_TUNABLE_U64,
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  ETHTOOL_TUNABLE_STRING,
  ETHTOOL_TUNABLE_S8,
  ETHTOOL_TUNABLE_S16,
  ETHTOOL_TUNABLE_S32,
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  ETHTOOL_TUNABLE_S64,
};
struct ethtool_tunable {
  __u32 cmd;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  __u32 id;
  __u32 type_id;
  __u32 len;
  void * data[0];
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
};
struct ethtool_regs {
  __u32 cmd;
  __u32 version;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  __u32 len;
  __u8 data[0];
};
struct ethtool_eeprom {
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  __u32 cmd;
  __u32 magic;
  __u32 offset;
  __u32 len;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  __u8 data[0];
};
struct ethtool_eee {
  __u32 cmd;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  __u32 supported;
  __u32 advertised;
  __u32 lp_advertised;
  __u32 eee_active;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  __u32 eee_enabled;
  __u32 tx_lpi_enabled;
  __u32 tx_lpi_timer;
  __u32 reserved[2];
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
};
struct ethtool_modinfo {
  __u32 cmd;
  __u32 type;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  __u32 eeprom_len;
  __u32 reserved[8];
};
struct ethtool_coalesce {
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  __u32 cmd;
  __u32 rx_coalesce_usecs;
  __u32 rx_max_coalesced_frames;
  __u32 rx_coalesce_usecs_irq;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  __u32 rx_max_coalesced_frames_irq;
  __u32 tx_coalesce_usecs;
  __u32 tx_max_coalesced_frames;
  __u32 tx_coalesce_usecs_irq;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  __u32 tx_max_coalesced_frames_irq;
  __u32 stats_block_coalesce_usecs;
  __u32 use_adaptive_rx_coalesce;
  __u32 use_adaptive_tx_coalesce;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  __u32 pkt_rate_low;
  __u32 rx_coalesce_usecs_low;
  __u32 rx_max_coalesced_frames_low;
  __u32 tx_coalesce_usecs_low;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  __u32 tx_max_coalesced_frames_low;
  __u32 pkt_rate_high;
  __u32 rx_coalesce_usecs_high;
  __u32 rx_max_coalesced_frames_high;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  __u32 tx_coalesce_usecs_high;
  __u32 tx_max_coalesced_frames_high;
  __u32 rate_sample_interval;
};
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
struct ethtool_ringparam {
  __u32 cmd;
  __u32 rx_max_pending;
  __u32 rx_mini_max_pending;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  __u32 rx_jumbo_max_pending;
  __u32 tx_max_pending;
  __u32 rx_pending;
  __u32 rx_mini_pending;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  __u32 rx_jumbo_pending;
  __u32 tx_pending;
};
struct ethtool_channels {
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  __u32 cmd;
  __u32 max_rx;
  __u32 max_tx;
  __u32 max_other;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  __u32 max_combined;
  __u32 rx_count;
  __u32 tx_count;
  __u32 other_count;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  __u32 combined_count;
};
struct ethtool_pauseparam {
  __u32 cmd;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  __u32 autoneg;
  __u32 rx_pause;
  __u32 tx_pause;
};
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
#define ETH_GSTRING_LEN 32
enum ethtool_stringset {
  ETH_SS_TEST = 0,
  ETH_SS_STATS,
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  ETH_SS_PRIV_FLAGS,
  ETH_SS_NTUPLE_FILTERS,
  ETH_SS_FEATURES,
  ETH_SS_RSS_HASH_FUNCS,
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
};
struct ethtool_gstrings {
  __u32 cmd;
  __u32 string_set;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  __u32 len;
  __u8 data[0];
};
struct ethtool_sset_info {
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  __u32 cmd;
  __u32 reserved;
  __u64 sset_mask;
  __u32 data[0];
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
};
enum ethtool_test_flags {
  ETH_TEST_FL_OFFLINE = (1 << 0),
  ETH_TEST_FL_FAILED = (1 << 1),
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  ETH_TEST_FL_EXTERNAL_LB = (1 << 2),
  ETH_TEST_FL_EXTERNAL_LB_DONE = (1 << 3),
};
struct ethtool_test {
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  __u32 cmd;
  __u32 flags;
  __u32 reserved;
  __u32 len;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  __u64 data[0];
};
struct ethtool_stats {
  __u32 cmd;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  __u32 n_stats;
  __u64 data[0];
};
struct ethtool_perm_addr {
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  __u32 cmd;
  __u32 size;
  __u8 data[0];
};
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
enum ethtool_flags {
  ETH_FLAG_TXVLAN = (1 << 7),
  ETH_FLAG_RXVLAN = (1 << 8),
  ETH_FLAG_LRO = (1 << 15),
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  ETH_FLAG_NTUPLE = (1 << 27),
  ETH_FLAG_RXHASH = (1 << 28),
};
struct ethtool_tcpip4_spec {
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  __be32 ip4src;
  __be32 ip4dst;
  __be16 psrc;
  __be16 pdst;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  __u8 tos;
};
struct ethtool_ah_espip4_spec {
  __be32 ip4src;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  __be32 ip4dst;
  __be32 spi;
  __u8 tos;
};
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
#define ETH_RX_NFC_IP4 1
struct ethtool_usrip4_spec {
  __be32 ip4src;
  __be32 ip4dst;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  __be32 l4_4_bytes;
  __u8 tos;
  __u8 ip_ver;
  __u8 proto;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
};
struct ethtool_tcpip6_spec {
  __be32 ip6src[4];
  __be32 ip6dst[4];
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  __be16 psrc;
  __be16 pdst;
  __u8 tclass;
};
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
struct ethtool_ah_espip6_spec {
  __be32 ip6src[4];
  __be32 ip6dst[4];
  __be32 spi;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  __u8 tclass;
};
struct ethtool_usrip6_spec {
  __be32 ip6src[4];
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  __be32 ip6dst[4];
  __be32 l4_4_bytes;
  __u8 tclass;
  __u8 l4_proto;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
};
union ethtool_flow_union {
  struct ethtool_tcpip4_spec tcp_ip4_spec;
  struct ethtool_tcpip4_spec udp_ip4_spec;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  struct ethtool_tcpip4_spec sctp_ip4_spec;
  struct ethtool_ah_espip4_spec ah_ip4_spec;
  struct ethtool_ah_espip4_spec esp_ip4_spec;
  struct ethtool_usrip4_spec usr_ip4_spec;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  struct ethtool_tcpip6_spec tcp_ip6_spec;
  struct ethtool_tcpip6_spec udp_ip6_spec;
  struct ethtool_tcpip6_spec sctp_ip6_spec;
  struct ethtool_ah_espip6_spec ah_ip6_spec;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  struct ethtool_ah_espip6_spec esp_ip6_spec;
  struct ethtool_usrip6_spec usr_ip6_spec;
  struct ethhdr ether_spec;
  __u8 hdata[52];
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
};
struct ethtool_flow_ext {
  __u8 padding[2];
  unsigned char h_dest[ETH_ALEN];
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  __be16 vlan_etype;
  __be16 vlan_tci;
  __be32 data[2];
};
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
struct ethtool_rx_flow_spec {
  __u32 flow_type;
  union ethtool_flow_union h_u;
  struct ethtool_flow_ext h_ext;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  union ethtool_flow_union m_u;
  struct ethtool_flow_ext m_ext;
  __u64 ring_cookie;
  __u32 location;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
};
struct ethtool_rxnfc {
  __u32 cmd;
  __u32 flow_type;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  __u64 data;
  struct ethtool_rx_flow_spec fs;
  __u32 rule_cnt;
  __u32 rule_locs[0];
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
};
struct ethtool_rxfh_indir {
  __u32 cmd;
  __u32 size;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  __u32 ring_index[0];
};
struct ethtool_rxfh {
  __u32 cmd;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  __u32 rss_context;
  __u32 indir_size;
  __u32 key_size;
  __u8 hfunc;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  __u8 rsvd8[3];
  __u32 rsvd32;
  __u32 rss_config[0];
};
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
#define ETH_RXFH_INDIR_NO_CHANGE 0xffffffff
struct ethtool_rx_ntuple_flow_spec {
  __u32 flow_type;
  union {
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
    struct ethtool_tcpip4_spec tcp_ip4_spec;
    struct ethtool_tcpip4_spec udp_ip4_spec;
    struct ethtool_tcpip4_spec sctp_ip4_spec;
    struct ethtool_ah_espip4_spec ah_ip4_spec;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
    struct ethtool_ah_espip4_spec esp_ip4_spec;
    struct ethtool_usrip4_spec usr_ip4_spec;
    struct ethhdr ether_spec;
    __u8 hdata[72];
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  } h_u, m_u;
  __u16 vlan_tag;
  __u16 vlan_tag_mask;
  __u64 data;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  __u64 data_mask;
  __s32 action;
#define ETHTOOL_RXNTUPLE_ACTION_DROP (- 1)
#define ETHTOOL_RXNTUPLE_ACTION_CLEAR (- 2)
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
};
struct ethtool_rx_ntuple {
  __u32 cmd;
  struct ethtool_rx_ntuple_flow_spec fs;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
};
#define ETHTOOL_FLASH_MAX_FILENAME 128
enum ethtool_flash_op_type {
  ETHTOOL_FLASH_ALL_REGIONS = 0,
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
};
struct ethtool_flash {
  __u32 cmd;
  __u32 region;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  char data[ETHTOOL_FLASH_MAX_FILENAME];
};
struct ethtool_dump {
  __u32 cmd;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  __u32 version;
  __u32 flag;
  __u32 len;
  __u8 data[0];
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
};
#define ETH_FW_DUMP_DISABLE 0
struct ethtool_get_features_block {
  __u32 available;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  __u32 requested;
  __u32 active;
  __u32 never_changed;
};
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
struct ethtool_gfeatures {
  __u32 cmd;
  __u32 size;
  struct ethtool_get_features_block features[0];
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
};
struct ethtool_set_features_block {
  __u32 valid;
  __u32 requested;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
};
struct ethtool_sfeatures {
  __u32 cmd;
  __u32 size;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  struct ethtool_set_features_block features[0];
};
struct ethtool_ts_info {
  __u32 cmd;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  __u32 so_timestamping;
  __s32 phc_index;
  __u32 tx_types;
  __u32 tx_reserved[3];
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  __u32 rx_filters;
  __u32 rx_reserved[3];
};
enum ethtool_sfeatures_retval_bits {
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  ETHTOOL_F_UNSUPPORTED__BIT,
  ETHTOOL_F_WISH__BIT,
  ETHTOOL_F_COMPAT__BIT,
};
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
#define ETHTOOL_F_UNSUPPORTED (1 << ETHTOOL_F_UNSUPPORTED__BIT)
#define ETHTOOL_F_WISH (1 << ETHTOOL_F_WISH__BIT)
#define ETHTOOL_F_COMPAT (1 << ETHTOOL_F_COMPAT__BIT)
#define ETHTOOL_GSET 0x00000001
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
#define ETHTOOL_SSET 0x00000002
#define ETHTOOL_GDRVINFO 0x00000003
#define ETHTOOL_GREGS 0x00000004
#define ETHTOOL_GWOL 0x00000005
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
#define ETHTOOL_SWOL 0x00000006
#define ETHTOOL_GMSGLVL 0x00000007
#define ETHTOOL_SMSGLVL 0x00000008
#define ETHTOOL_NWAY_RST 0x00000009
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
#define ETHTOOL_GLINK 0x0000000a
#define ETHTOOL_GEEPROM 0x0000000b
#define ETHTOOL_SEEPROM 0x0000000c
#define ETHTOOL_GCOALESCE 0x0000000e
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
#define ETHTOOL_SCOALESCE 0x0000000f
#define ETHTOOL_GRINGPARAM 0x00000010
#define ETHTOOL_SRINGPARAM 0x00000011
#define ETHTOOL_GPAUSEPARAM 0x00000012
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
#define ETHTOOL_SPAUSEPARAM 0x00000013
#define ETHTOOL_GRXCSUM 0x00000014
#define ETHTOOL_SRXCSUM 0x00000015
#define ETHTOOL_GTXCSUM 0x00000016
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
#define ETHTOOL_STXCSUM 0x00000017
#define ETHTOOL_GSG 0x00000018
#define ETHTOOL_SSG 0x00000019
#define ETHTOOL_TEST 0x0000001a
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
#define ETHTOOL_GSTRINGS 0x0000001b
#define ETHTOOL_PHYS_ID 0x0000001c
#define ETHTOOL_GSTATS 0x0000001d
#define ETHTOOL_GTSO 0x0000001e
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
#define ETHTOOL_STSO 0x0000001f
#define ETHTOOL_GPERMADDR 0x00000020
#define ETHTOOL_GUFO 0x00000021
#define ETHTOOL_SUFO 0x00000022
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
#define ETHTOOL_GGSO 0x00000023
#define ETHTOOL_SGSO 0x00000024
#define ETHTOOL_GFLAGS 0x00000025
#define ETHTOOL_SFLAGS 0x00000026
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
#define ETHTOOL_GPFLAGS 0x00000027
#define ETHTOOL_SPFLAGS 0x00000028
#define ETHTOOL_GRXFH 0x00000029
#define ETHTOOL_SRXFH 0x0000002a
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
#define ETHTOOL_GGRO 0x0000002b
#define ETHTOOL_SGRO 0x0000002c
#define ETHTOOL_GRXRINGS 0x0000002d
#define ETHTOOL_GRXCLSRLCNT 0x0000002e
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
#define ETHTOOL_GRXCLSRULE 0x0000002f
#define ETHTOOL_GRXCLSRLALL 0x00000030
#define ETHTOOL_SRXCLSRLDEL 0x00000031
#define ETHTOOL_SRXCLSRLINS 0x00000032
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
#define ETHTOOL_FLASHDEV 0x00000033
#define ETHTOOL_RESET 0x00000034
#define ETHTOOL_SRXNTUPLE 0x00000035
#define ETHTOOL_GRXNTUPLE 0x00000036
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
#define ETHTOOL_GSSET_INFO 0x00000037
#define ETHTOOL_GRXFHINDIR 0x00000038
#define ETHTOOL_SRXFHINDIR 0x00000039
#define ETHTOOL_GFEATURES 0x0000003a
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
#define ETHTOOL_SFEATURES 0x0000003b
#define ETHTOOL_GCHANNELS 0x0000003c
#define ETHTOOL_SCHANNELS 0x0000003d
#define ETHTOOL_SET_DUMP 0x0000003e
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
#define ETHTOOL_GET_DUMP_FLAG 0x0000003f
#define ETHTOOL_GET_DUMP_DATA 0x00000040
#define ETHTOOL_GET_TS_INFO 0x00000041
#define ETHTOOL_GMODULEINFO 0x00000042
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
#define ETHTOOL_GMODULEEEPROM 0x00000043
#define ETHTOOL_GEEE 0x00000044
#define ETHTOOL_SEEE 0x00000045
#define ETHTOOL_GRSSH 0x00000046
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
#define ETHTOOL_SRSSH 0x00000047
#define ETHTOOL_GTUNABLE 0x00000048
#define ETHTOOL_STUNABLE 0x00000049
#define SPARC_ETH_GSET ETHTOOL_GSET
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
#define SPARC_ETH_SSET ETHTOOL_SSET
#define SUPPORTED_10baseT_Half (1 << 0)
#define SUPPORTED_10baseT_Full (1 << 1)
#define SUPPORTED_100baseT_Half (1 << 2)
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
#define SUPPORTED_100baseT_Full (1 << 3)
#define SUPPORTED_1000baseT_Half (1 << 4)
#define SUPPORTED_1000baseT_Full (1 << 5)
#define SUPPORTED_Autoneg (1 << 6)
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
#define SUPPORTED_TP (1 << 7)
#define SUPPORTED_AUI (1 << 8)
#define SUPPORTED_MII (1 << 9)
#define SUPPORTED_FIBRE (1 << 10)
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
#define SUPPORTED_BNC (1 << 11)
#define SUPPORTED_10000baseT_Full (1 << 12)
#define SUPPORTED_Pause (1 << 13)
#define SUPPORTED_Asym_Pause (1 << 14)
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
#define SUPPORTED_2500baseX_Full (1 << 15)
#define SUPPORTED_Backplane (1 << 16)
#define SUPPORTED_1000baseKX_Full (1 << 17)
#define SUPPORTED_10000baseKX4_Full (1 << 18)
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
#define SUPPORTED_10000baseKR_Full (1 << 19)
#define SUPPORTED_10000baseR_FEC (1 << 20)
#define SUPPORTED_20000baseMLD2_Full (1 << 21)
#define SUPPORTED_20000baseKR2_Full (1 << 22)
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
#define SUPPORTED_40000baseKR4_Full (1 << 23)
#define SUPPORTED_40000baseCR4_Full (1 << 24)
#define SUPPORTED_40000baseSR4_Full (1 << 25)
#define SUPPORTED_40000baseLR4_Full (1 << 26)
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
#define SUPPORTED_56000baseKR4_Full (1 << 27)
#define SUPPORTED_56000baseCR4_Full (1 << 28)
#define SUPPORTED_56000baseSR4_Full (1 << 29)
#define SUPPORTED_56000baseLR4_Full (1 << 30)
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
#define ADVERTISED_10baseT_Half (1 << 0)
#define ADVERTISED_10baseT_Full (1 << 1)
#define ADVERTISED_100baseT_Half (1 << 2)
#define ADVERTISED_100baseT_Full (1 << 3)
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
#define ADVERTISED_1000baseT_Half (1 << 4)
#define ADVERTISED_1000baseT_Full (1 << 5)
#define ADVERTISED_Autoneg (1 << 6)
#define ADVERTISED_TP (1 << 7)
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
#define ADVERTISED_AUI (1 << 8)
#define ADVERTISED_MII (1 << 9)
#define ADVERTISED_FIBRE (1 << 10)
#define ADVERTISED_BNC (1 << 11)
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
#define ADVERTISED_10000baseT_Full (1 << 12)
#define ADVERTISED_Pause (1 << 13)
#define ADVERTISED_Asym_Pause (1 << 14)
#define ADVERTISED_2500baseX_Full (1 << 15)
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
#define ADVERTISED_Backplane (1 << 16)
#define ADVERTISED_1000baseKX_Full (1 << 17)
#define ADVERTISED_10000baseKX4_Full (1 << 18)
#define ADVERTISED_10000baseKR_Full (1 << 19)
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
#define ADVERTISED_10000baseR_FEC (1 << 20)
#define ADVERTISED_20000baseMLD2_Full (1 << 21)
#define ADVERTISED_20000baseKR2_Full (1 << 22)
#define ADVERTISED_40000baseKR4_Full (1 << 23)
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
#define ADVERTISED_40000baseCR4_Full (1 << 24)
#define ADVERTISED_40000baseSR4_Full (1 << 25)
#define ADVERTISED_40000baseLR4_Full (1 << 26)
#define ADVERTISED_56000baseKR4_Full (1 << 27)
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
#define ADVERTISED_56000baseCR4_Full (1 << 28)
#define ADVERTISED_56000baseSR4_Full (1 << 29)
#define ADVERTISED_56000baseLR4_Full (1 << 30)
#define SPEED_10 10
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
#define SPEED_100 100
#define SPEED_1000 1000
#define SPEED_2500 2500
#define SPEED_10000 10000
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
#define SPEED_20000 20000
#define SPEED_40000 40000
#define SPEED_56000 56000
#define SPEED_UNKNOWN - 1
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
#define DUPLEX_HALF 0x00
#define DUPLEX_FULL 0x01
#define DUPLEX_UNKNOWN 0xff
#define PORT_TP 0x00
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
#define PORT_AUI 0x01
#define PORT_MII 0x02
#define PORT_FIBRE 0x03
#define PORT_BNC 0x04
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
#define PORT_DA 0x05
#define PORT_NONE 0xef
#define PORT_OTHER 0xff
#define XCVR_INTERNAL 0x00
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
#define XCVR_EXTERNAL 0x01
#define XCVR_DUMMY1 0x02
#define XCVR_DUMMY2 0x03
#define XCVR_DUMMY3 0x04
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
#define AUTONEG_DISABLE 0x00
#define AUTONEG_ENABLE 0x01
#define ETH_TP_MDI_INVALID 0x00
#define ETH_TP_MDI 0x01
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
#define ETH_TP_MDI_X 0x02
#define ETH_TP_MDI_AUTO 0x03
#define WAKE_PHY (1 << 0)
#define WAKE_UCAST (1 << 1)
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
#define WAKE_MCAST (1 << 2)
#define WAKE_BCAST (1 << 3)
#define WAKE_ARP (1 << 4)
#define WAKE_MAGIC (1 << 5)
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
#define WAKE_MAGICSECURE (1 << 6)
#define TCP_V4_FLOW 0x01
#define UDP_V4_FLOW 0x02
#define SCTP_V4_FLOW 0x03
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
#define AH_ESP_V4_FLOW 0x04
#define TCP_V6_FLOW 0x05
#define UDP_V6_FLOW 0x06
#define SCTP_V6_FLOW 0x07
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
#define AH_ESP_V6_FLOW 0x08
#define AH_V4_FLOW 0x09
#define ESP_V4_FLOW 0x0a
#define AH_V6_FLOW 0x0b
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
#define ESP_V6_FLOW 0x0c
#define IPV4_USER_FLOW 0x0d
#define IP_USER_FLOW IPV4_USER_FLOW
#define IPV6_USER_FLOW 0x0e
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
#define IPV4_FLOW 0x10
#define IPV6_FLOW 0x11
#define ETHER_FLOW 0x12
#define FLOW_EXT 0x80000000
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
#define FLOW_MAC_EXT 0x40000000
#define RXH_L2DA (1 << 1)
#define RXH_VLAN (1 << 2)
#define RXH_L3_PROTO (1 << 3)
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
#define RXH_IP_SRC (1 << 4)
#define RXH_IP_DST (1 << 5)
#define RXH_L4_B_0_1 (1 << 6)
#define RXH_L4_B_2_3 (1 << 7)
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
#define RXH_DISCARD (1 << 31)
#define RX_CLS_FLOW_DISC 0xffffffffffffffffULL
#define RX_CLS_LOC_SPECIAL 0x80000000
#define RX_CLS_LOC_ANY 0xffffffff
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
#define RX_CLS_LOC_FIRST 0xfffffffe
#define RX_CLS_LOC_LAST 0xfffffffd
#define ETH_MODULE_SFF_8079 0x1
#define ETH_MODULE_SFF_8079_LEN 256
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
#define ETH_MODULE_SFF_8472 0x2
#define ETH_MODULE_SFF_8472_LEN 512
#define ETH_MODULE_SFF_8636 0x3
#define ETH_MODULE_SFF_8636_LEN 256
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
#define ETH_MODULE_SFF_8436 0x4
#define ETH_MODULE_SFF_8436_LEN 256
enum ethtool_reset_flags {
  ETH_RESET_MGMT = 1 << 0,
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  ETH_RESET_IRQ = 1 << 1,
  ETH_RESET_DMA = 1 << 2,
  ETH_RESET_FILTER = 1 << 3,
  ETH_RESET_OFFLOAD = 1 << 4,
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  ETH_RESET_MAC = 1 << 5,
  ETH_RESET_PHY = 1 << 6,
  ETH_RESET_RAM = 1 << 7,
  ETH_RESET_DEDICATED = 0x0000ffff,
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  ETH_RESET_ALL = 0xffffffff,
};
#define ETH_RESET_SHARED_SHIFT 16
#endif
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
