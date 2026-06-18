LUMINE_BASE_VERSION := camellia
LUMINE_BUILD_DATE := $(shell date -u +%Y%m%d)

LUMINE_MAINTAINER ?= LumineDroid
LUMINE_MAINTAINER_LINK ?= https://github.com/LumineDroid

LUMINE_VER_MAJOR := 17
LUMINE_VER_MINOR := 0
LUMINE_VER_PATCH := 0
LUMINE_BRAND_CODE := LM
LUMINE_REGION_CODE := ID

DEVICE_LIST         := $(shell jq -r '.[][].codename' official_devices/devices.json 2>/dev/null)
OFFICIAL_MAINTAINER := $(shell jq -r --arg c "$(TARGET_PRODUCT)" \
                          '.[][] | select(.codename == $$c) | .maintainer' \
                          official_devices/devices.json 2>/dev/null)
OFFICIAL_TELEGRAM   := $(shell jq -r --arg c "$(TARGET_PRODUCT)" \
                          '.[][] | select(.codename == $$c) | .telegram' \
                          official_devices/devices.json 2>/dev/null)

ifeq ($(DEVICE_LIST),)
  LUMINE_BUILD_TYPE := UNOFFICIAL
  $(warning LumineDroid: Build verification skipped, devices.json not found or empty)
else ifneq (,$(findstring $(TARGET_PRODUCT),$(DEVICE_LIST)))
  ifeq ($(OFFICIAL_MAINTAINER),$(LUMINE_MAINTAINER))
    LUMINE_BUILD_TYPE      := OFFICIAL
    LUMINE_MAINTAINER_LINK := $(OFFICIAL_TELEGRAM)
    $(warning LumineDroid: $(TARGET_PRODUCT) is OFFICIAL, maintained by $(LUMINE_MAINTAINER))
  else
    LUMINE_BUILD_TYPE := UNOFFICIAL
    $(warning LumineDroid: $(TARGET_PRODUCT) is UNOFFICIAL, maintainer mismatch (expected $(OFFICIAL_MAINTAINER), got $(LUMINE_MAINTAINER)))
  endif
else
  LUMINE_BUILD_TYPE := UNOFFICIAL
  $(warning LumineDroid: $(TARGET_PRODUCT) is UNOFFICIAL, device not in official list)
endif

ifeq ($(LUMINE_BUILD_TYPE),OFFICIAL)
LUMINE_TYPE_CODE := OF
else
LUMINE_TYPE_CODE := UN
endif

ifeq ($(LUMINE_BUILD_TYPE),OFFICIAL)
PRODUCT_PACKAGES += \
    Updater

PRODUCT_COPY_FILES += \
    vendor/lumine/prebuilt/common/etc/init/init.luminedroid-updater.rc:$(TARGET_COPY_OUT_SYSTEM_EXT)/etc/init/init.luminedroid-updater.rc
endif

LUMINE_VERSION_SUFFIX := $(LUMINE_VER_MAJOR).$(LUMINE_VER_MINOR).$(LUMINE_VER_PATCH).$(LUMINE_BRAND_CODE)$(LUMINE_REGION_CODE)$(LUMINE_TYPE_CODE)
LUMINE_VERSION := $(LUMINE_BASE_VERSION)-$(LUMINE_VERSION_SUFFIX)-$(LUMINE_BUILD_DATE)-$(TARGET_PRODUCT)

PRODUCT_SYSTEM_PROPERTIES += \
    org.luminedroid.build.type=$(LUMINE_BUILD_TYPE) \
    org.luminedroid.build.version=$(LUMINE_VERSION_SUFFIX) \
    org.luminedroid.maintainer=$(LUMINE_MAINTAINER) \
    org.luminedroid.maintainer.link=$(LUMINE_MAINTAINER_LINK) \
    org.luminedroid.version=$(LUMINE_VERSION)
