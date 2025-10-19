LUMINE_BASE_VERSION := bynx
LUMINE_BUILD_TYPE ?= UNOFFICIAL

ifndef LUMINE_MAINTAINER
LUMINE_MAINTAINER := Luminers
endif

ifeq ($(LINEAGE_VERSION_APPEND_TIME_OF_DAY),true)
    LINEAGE_BUILD_DATE := $(shell date -u +%Y%m%d_%H%M%S)
else
    LINEAGE_BUILD_DATE := $(shell date -u +%Y%m%d)
endif

LINEAGE_VERSION_SUFFIX := $(LINEAGE_BUILD_DATE)-$(LUMINE_BUILD_TYPE)-$(LINEAGE_BUILD)

# Internal version
LINEAGE_VERSION := $(LUMINE_BASE_VERSION)-$(LINEAGE_VERSION_SUFFIX)
LUMINE_VERSION := LumineDroid-$(LUMINE_BASE_VERSION)-$(LINEAGE_VERSION_SUFFIX)

# Display version
LINEAGE_DISPLAY_VERSION := $(LUMINE_BASE_VERSION)-$(LINEAGE_VERSION_SUFFIX)

# LumineDroid version properties
PRODUCT_SYSTEM_PROPERTIES += \
    org.luminedroid.version=$(LUMINE_BASE_VERSION) \
    org.luminedroid.build.type=$(LUMINE_BUILD_TYPE) \
    org.luminedroid.maintainer=$(LUMINE_MAINTAINER)

PRODUCT_SYSTEM_PROPERTIES += \
    ro.lineage.version=$(LINEAGE_VERSION) \
    ro.lineage.display.version=$(LINEAGE_DISPLAY_VERSION) \
    ro.lineage.build.version=$(LUMINE_BASE_VERSION) \
    ro.lineage.releasetype=$(LUMINE_BUILD_TYPE)
