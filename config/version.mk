#
# Copyright (C) 2025 LumineDroid
#
# SPDX-License-Identifier: Apache-2.0
#

LUMINE_BUILD_DATE := $(shell date -u +%Y%m%d-%H%M)
LUMINE_BUILD_TYPE ?= UNOFFICIAL
LUMINE_BUILD_VERSION := 1.0

ifeq ($(LUMINE_OFFICIAL),true)
LUMINE_BUILD_TYPE := OFFICIAL

PRODUCT_PACKAGES += \
    Updater

PRODUCT_COPY_FILES += \
    vendor/lumine/prebuilt/common/etc/init/init.lumine-updater.rc:$(TARGET_COPY_OUT_SYSTEM_EXT)/etc/init/init.lumine-updater.rc
endif

LUMINE_VERSION := LumineDroid-$(LUMINE_BUILD_VERSION)-$(LUMINE_BUILD)-$(LUMINE_BUILD_TYPE)-$(LUMINE_BUILD_DATE)

PRODUCT_PRODUCT_PROPERTIES += \
    org.lumine.build.date=$(BUILD_DATE) \
    org.lumine.build.type=$(LUMINE_BUILD_TYPE) \
    org.lumine.build.version=$(LUMINE_BUILD_VERSION) \
    org.lumine.device=$(LUMINE_BUILD) \
    org.lumine.fingerprint=$(ROM_FINGERPRINT) \
    org.lumine.version=$(LUMINE_VERSION)
