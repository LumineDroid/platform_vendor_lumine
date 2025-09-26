PRODUCT_VERSION := bynx

ifeq ($(LINEAGE_VERSION_APPEND_TIME_OF_DAY),true)
    LINEAGE_BUILD_DATE := $(shell date -u +%Y%m%d_%H%M%S)
else
    LINEAGE_BUILD_DATE := $(shell date -u +%Y%m%d)
endif

LINEAGE_BUILDTYPE ?= UNOFFICIAL

LINEAGE_VERSION_SUFFIX := $(LINEAGE_BUILD_DATE)-$(LINEAGE_BUILDTYPE)-$(LINEAGE_BUILD)

# Internal version
LINEAGE_VERSION := $(PRODUCT_VERSION)-$(LINEAGE_VERSION_SUFFIX)

# Display version
LINEAGE_DISPLAY_VERSION := $(PRODUCT_VERSION)-$(LINEAGE_VERSION_SUFFIX)

# LumineDroid version properties
PRODUCT_SYSTEM_PROPERTIES += \
    ro.lineage.version=$(LINEAGE_VERSION) \
    ro.lineage.display.version=$(LINEAGE_DISPLAY_VERSION) \
    ro.lineage.build.version=$(PRODUCT_VERSION) \
    ro.lineage.releasetype=$(LINEAGE_BUILDTYPE)
