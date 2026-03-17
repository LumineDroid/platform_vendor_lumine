LUMINE_TARGET := $(LUMINE_VERSION)
LUMINE_OTA_PACKAGE := $(PRODUCT_OUT)/LumineDroid-$(LUMINE_TARGET).zip
LUMINE_FASTBOOT_PACKAGE := $(PRODUCT_OUT)/LumineDroid-$(LUMINE_TARGET)-fastboot.zip

SHA256 := prebuilts/build-tools/path/$(HOST_PREBUILT_TAG)/sha256sum

$(LUMINE_OTA_PACKAGE): $(INTERNAL_OTA_PACKAGE_TARGET)
	$(hide) ln -f $(INTERNAL_OTA_PACKAGE_TARGET) $(LUMINE_OTA_PACKAGE)
	$(hide) $(SHA256) $(LUMINE_OTA_PACKAGE) > $(LUMINE_OTA_PACKAGE).sha256sum
ifeq ($(LUMINE_BUILD_TYPE),OFFICIAL)
	$(hide) ./vendor/lumine/build/tools/createjson.py $(TARGET_DEVICE) $(PRODUCT_OUT) LumineDroid-$(LUMINE_TARGET).zip $(TARGET_BUILD_VARIANT)
endif

$(LUMINE_FASTBOOT_PACKAGE): $(INTERNAL_UPDATE_PACKAGE_TARGET)
	$(hide) ln -f $(INTERNAL_UPDATE_PACKAGE_TARGET) $(LUMINE_FASTBOOT_PACKAGE)

.PHONY: bacon fastboot

bacon: $(LUMINE_OTA_PACKAGE)
	@printf "╔══════════════════════════════════════╗\n"
	@printf "║          L U M I N E  D R O I D       ║\n"
	@printf "║          O T A   B U I L D            ║\n"
	@printf "╚══════════════════════════════════════╝\n"
	@printf "Output  : %s\n" "$(LUMINE_OTA_PACKAGE)"
	@printf "SHA256  : %s\n" "$$(awk '{print $$1}' $(LUMINE_OTA_PACKAGE).sha256sum)"
	@printf "Size    : %s\n" "$$(du -hs $(LUMINE_OTA_PACKAGE) | awk '{print $$1}')"
	@printf "Bytes   : %s\n" "$$(wc -c < $(LUMINE_OTA_PACKAGE))"
	@printf "Type    : %s\n" "$(LUMINE_BUILD_TYPE)"
	@printf "────────────────────────────────────────\n"

fastboot: $(LUMINE_FASTBOOT_PACKAGE)
	@printf "╔══════════════════════════════════════╗\n"
	@printf "║          L U M I N E  D R O I D       ║\n"
	@printf "║        F A S T B O O T  B U I L D      ║\n"
	@printf "╚══════════════════════════════════════╝\n"
	@printf "Output  : %s\n" "$(LUMINE_FASTBOOT_PACKAGE)"
	@printf "Size    : %s\n" "$$(du -hs $(LUMINE_FASTBOOT_PACKAGE) | awk '{print $$1}')"
	@printf "Bytes   : %s\n" "$$(wc -c < $(LUMINE_FASTBOOT_PACKAGE))"
	@printf "Type    : %s\n" "$(LUMINE_BUILD_TYPE)"
	@printf "────────────────────────────────────────\n"
