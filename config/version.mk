PRODUCT_VERSION_MAJOR = 15
PRODUCT_VERSION_MINOR = 0

LUMINE_BUILD_DATE := $(shell date -u +%Y%m%d-%H%M)
LUMINE_BUILD_TYPE ?= UNOFFICIAL
LUMINE_BUILD_VERSION := 1.0
LUMINE_VERSION := $(LUMINE_BUILD_VERSION)-$(LUMINE_BUILD_TYPE)

ifeq ($(LUMINE_OFFICIAL),true)
LUMINE_BUILD_TYPE := OFFICIAL

PRODUCT_PACKAGES += \
    Updater

PRODUCT_COPY_FILES += \
    vendor/lineage/prebuilt/common/etc/init/init.lineage-updater.rc:$(TARGET_COPY_OUT_SYSTEM_EXT)/etc/init/init.lineage-updater.rc
endif

# Internal version
LINEAGE_VERSION := v$(LUMINE_BUILD_VERSION)-$(LUMINE_BUILD_TYPE)-$(LINEAGE_BUILD)-$(LUMINE_BUILD_DATE)

# Display version
LINEAGE_DISPLAY_VERSION := $(LUMINE_BUILD_VERSION)-$(LUMINE_BUILD_DATE)

# LineageOS version properties
PRODUCT_SYSTEM_PROPERTIES += \
    org.lumine.build.date=$(BUILD_DATE) \
    org.lumine.build.type=$(LUMINE_BUILD_TYPE) \
    org.lumine.build.version=$(LUMINE_BUILD_VERSION) \
    org.lumine.device=$(LINEAGE_BUILD) \
    org.lumine.version=$(LINEAGE_VERSION)

# Signing
ifeq (user,$(TARGET_BUILD_VARIANT))
ifneq (,$(wildcard .android-certs/releasekey.pk8))
PRODUCT_DEFAULT_DEV_CERTIFICATE := .android-certs/releasekey
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += ro.oem_unlock_supported=1
endif
ifneq (,$(wildcard .android-certs/verity.pk8))
PRODUCT_VERITY_SIGNING_KEY := .android-certs/verity
endif
ifneq (,$(wildcard .android-certs/otakey.x509.pem))
PRODUCT_OTA_PUBLIC_KEYS := .android-certs/otakey.x509.pem
endif
endif
