LUMINE_BASE_VERSION := bellflower
LUMINE_BUILD_DATE := $(shell date -u +%d%m%Y-%H%M)

LUMINE_MAINTAINER ?= Luminers
LUMINE_MAINTAINER_LINK ?= https://github.com/LumineDroid

DEVICE_LIST := $(shell jq -r '.[][].codename' official_devices/devices.json)
OFFICIAL_MAINTAINER := $(shell jq -r --arg codename "$(LUMINE_BUILD)" \
  '.[][] | select(.codename == $$codename) | .maintainer' official_devices/devices.json)
OFFICIAL_MAINTAINER_LINK := $(shell jq -r --arg codename "$(LUMINE_BUILD)" \
  '.[][] | select(.codename == $$codename) | .telegram' official_devices/devices.json)

ifneq (,$(findstring $(LUMINE_BUILD),$(DEVICE_LIST)))
    ifeq ($(OFFICIAL_MAINTAINER),$(LUMINE_MAINTAINER))
        LUMINE_BUILD_TYPE := OFFICIAL
        LUMINE_MAINTAINER_LINK := $(OFFICIAL_MAINTAINER_LINK)
        $(warning [LUMINE] $(LUMINE_BUILD): OFFICIAL - Maintainer verified ($(LUMINE_MAINTAINER)))
    else
        LUMINE_BUILD_TYPE := UNOFFICIAL
        $(warning [LUMINE] $(LUMINE_BUILD): OFFICIAL device, but maintainer mismatch)
        $(warning [LUMINE] Expected: $(OFFICIAL_MAINTAINER), Got: $(LUMINE_MAINTAINER))
    endif
else
    LUMINE_BUILD_TYPE := UNOFFICIAL
    $(warning [LUMINE] $(LUMINE_BUILD): Not found in official list)
endif

# Internal version
LUMINE_VERSION_SUFFIX := $(LUMINE_BUILD_DATE)-$(LUMINE_BUILD_TYPE)-$(LUMINE_BUILD)
LUMINE_VERSION := $(LUMINE_BASE_VERSION)-$(LUMINE_VERSION_SUFFIX)

# LumineDroid version properties
PRODUCT_SYSTEM_PROPERTIES += \
    org.luminedroid.build.type=$(LUMINE_BUILD_TYPE) \
    org.luminedroid.build.version=$(LUMINE_BASE_VERSION) \
    org.luminedroid.maintainer=$(LUMINE_MAINTAINER) \
    org.luminedroid.maintainer.link=$(LUMINE_MAINTAINER_LINK) \
    org.luminedroid.version=$(LUMINE_VERSION)
