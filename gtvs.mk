#
# Copyright (C) 2014 Google Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

PRODUCT_PACKAGES := \
    AndroidMediaShell \
    AtvRemoteService \
    Backdrop \
    BugReportSender \
    GooglePackageInstaller \
    FrameworkPackageStubs \
    GoogleBackupTransport \
    GoogleCalendarSyncAdapter \
    GoogleContactsSyncAdapter \
    GoogleFeedback \
    GoogleOneTimeInitializer \
    GoogleHindiIME \
    GooglePartnerSetup \
    GoogleServicesFramework \
    GoogleTTS \
    Katniss \
    LatinIMEGoogleTvPrebuilt \
    LeanbackLauncher \
    Music2Pano \
    PrebuiltGmsCorePano \
    PlayGamesPano \
    Pumpkin \
    RecommendationsService \
    SssAuthbridgePrebuilt \
    SetupWraithPrebuilt \
    talkback \
    Tubesky \
    TVLauncher \
    TVRecommendations \
    VideosPano \
    WebViewGoogle \
    YouTubeLeanback \
    YouTubeKidsTv \
    GoogleExtServices \
    GoogleExtShared \


# Configuration files for GMS apps
PRODUCT_COPY_FILES := \
    vendor/google_gtvs/overlays/etc/sysconfig/google.xml:system/etc/sysconfig/google.xml \
    vendor/google_gtvs/overlays/etc/permissions/privapp-permissions-google.xml:system/etc/permissions/privapp-permissions-google.xml \
    vendor/google_gtvs/overlays/etc/permissions/privapp-permissions-atv.xml:system/etc/permissions/privapp-permissions-atv.xml \
    vendor/google_gtvs/overlays/etc/sysconfig/google_atv.xml:system/etc/sysconfig/google_atv.xml \
    vendor/google_gtvs/overlays/etc/sysconfig/google-hiddenapi-package-whitelist.xml:system/etc/sysconfig/google-hiddenapi-package-whitelist.xml \
    vendor/google_gtvs/overlays/etc/virtual-remote/virtual-remote.idc:system/usr/idc/virtual-remote.idc \
    vendor/google_gtvs/overlays/etc/virtual-remote/virtual-remote.kl:system/usr/keylayout/virtual-remote.kl \
    vendor/google_gtvs/overlays/etc/virtual-remote/virtual-remote.kcm:system/usr/keychars/virtual-remote.kcm

# Overlay for GMS devices
$(call inherit-product, device/sample/products/backup_overlay.mk)
$(call inherit-product, device/sample/products/location_overlay.mk)
PRODUCT_PACKAGE_OVERLAYS += vendor/google_gtvs/overlays/products/gms_tv_overlay
PRODUCT_PACKAGE_OVERLAYS += vendor/google_gtvs/overlays/products/gms_overlay

# Overrides
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.com.google.gmsversion=Android_9_Pie
