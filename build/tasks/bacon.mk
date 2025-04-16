#
# Copyright (C) 2025 LumineDroid
#
# SPDX-License-Identifier: Apache-2.0
#
# -----------------------------------------------------------------
# LumineDroid OTA update package

LUMINE_TARGET_PACKAGE := $(PRODUCT_OUT)/$(LUMINE_VERSION).zip

SHA256 := prebuilts/build-tools/path/$(HOST_PREBUILT_TAG)/sha256sum

$(LUMINE_TARGET_PACKAGE): $(INTERNAL_OTA_PACKAGE_TARGET)
	$(hide) ln -f $(INTERNAL_OTA_PACKAGE_TARGET) $(LUMINE_TARGET_PACKAGE)
	$(hide) $(SHA256) $(LUMINE_TARGET_PACKAGE) | sed "s|$(PRODUCT_OUT)/||" > $(LUMINE_TARGET_PACKAGE).sha256sum
	@echo "Package Complete: $(LUMINE_TARGET_PACKAGE)" >&2

.PHONY: bacon
bacon: $(LUMINE_TARGET_PACKAGE) $(DEFAULT_GOAL)
