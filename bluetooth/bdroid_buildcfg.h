/*
 * Copyright (C) 2012 The Android Open Source Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#ifndef _BDROID_BUILDCFG_H
#define _BDROID_BUILDCFG_H

#define BTM_DEF_LOCAL_NAME   "Android Bluedroid"

#define BLE_VND_INCLUDED     TRUE
#define BLE_PRIVACY_SPT      FALSE

// Increase background scanning to reduce reconnect time
#define BTM_BLE_SCAN_SLOW_INT_1    110    /* 68.75 ms   = 110 *0.625 */
#define BTM_BLE_SCAN_SLOW_WIN_1    8      /* 5 ms = 8 *0.625 */

// Change I/O capabilities to output only so pairing uses passkey instead of pin
#define BTM_LOCAL_IO_CAPS BTM_IO_CAP_OUT

#define BTIF_HF_SERVICES 0
#define BT_HF_SERVICE_NAMES {NULL}

#define AVCT_INCLUDED FALSE
#define AVDT_INCLUDED FALSE
#define BNEP_INCLUDED FALSE
#define BTA_PAN_INCLUDED FALSE
#define PAN_INCLUDED FALSE

#endif
