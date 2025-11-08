LUMINE_BASE_VERSION := bynx

LUMINE_MAINTAINER ?= Luminers
LUMINE_MAINTAINER_LINK ?= https://github.com/LumineDroid

DEVICE_LIST := $(shell jq -r '.[][].codename' official_devices/devices.json)
OFFICIAL_MAINTAINER := $(shell jq -r --arg codename "$(LINEAGE_BUILD)" \
  '.[][] | select(.codename == $$codename) | .maintainer' official_devices/devices.json)

ifneq (,$(findstring $(LINEAGE_BUILD),$(DEVICE_LIST)))
    ifeq ($(OFFICIAL_MAINTAINER),$(LUMINE_MAINTAINER))
        LUMINE_BUILD_TYPE := OFFICIAL
        $(warning [LUMINE] $(LINEAGE_BUILD): OFFICIAL - Maintainer verified ($(LUMINE_MAINTAINER)))
    else
        LUMINE_BUILD_TYPE := UNOFFICIAL
        $(warning [LUMINE] $(LINEAGE_BUILD): OFFICIAL device, but maintainer mismatch)
        $(warning [LUMINE] Expected: $(OFFICIAL_MAINTAINER), Got: $(LUMINE_MAINTAINER))
    endif
else
    LUMINE_BUILD_TYPE := UNOFFICIAL
    $(warning [LUMINE] $(LINEAGE_BUILD): Not found in official list)
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
    org.luminedroid.build.type=$(LUMINE_BUILD_TYPE) \
    org.luminedroid.maintainer=$(LUMINE_MAINTAINER) \
    org.luminedroid.maintainer.link=$(LUMINE_MAINTAINER_LINK) \
    org.luminedroid.version=$(LUMINE_BASE_VERSION)

PRODUCT_SYSTEM_PROPERTIES += \
    ro.lineage.version=$(LINEAGE_VERSION) \
    ro.lineage.display.version=$(LINEAGE_DISPLAY_VERSION) \
    ro.lineage.build.version=$(LUMINE_BASE_VERSION) \
    ro.lineage.releasetype=$(LUMINE_BUILD_TYPE)
