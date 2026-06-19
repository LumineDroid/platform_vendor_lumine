LUMINE_BASE_VERSION := camellia
LUMINE_BUILD_DATE := $(shell date -u +%Y%m%d)

LUMINE_MAINTAINER ?= LumineDroid
LUMINE_MAINTAINER_LINK ?= https://github.com/LumineDroid

LUMINE_VER_MAJOR := 17
LUMINE_VER_MINOR := 0
LUMINE_VER_PATCH := 0
LUMINE_DEVICE_CODE := $(shell echo $(TARGET_PRODUCT) | cut -c1-3 | tr a-z A-Z)
LUMINE_BRAND_CODE := LM
LUMINE_REGION_CODE := ID

_LUMINE_VERIFY := $(shell python3 vendor/lumine/tools/lumine_verify.py \
    --devices  official_devices/devices.json \
    --product  $(TARGET_PRODUCT) \
    --maintainer $(LUMINE_MAINTAINER) 2>/dev/null)

LUMINE_BUILD_TYPE     := $(patsubst LUMINE_BUILD_TYPE=%,%,\
    $(filter LUMINE_BUILD_TYPE=%,$(_LUMINE_VERIFY)))
LUMINE_MAINTAINER_LINK := $(patsubst LUMINE_MAINTAINER_LINK=%,%,\
    $(filter LUMINE_MAINTAINER_LINK=%,$(_LUMINE_VERIFY)))

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

LUMINE_VERSION_SUFFIX := $(LUMINE_VER_MAJOR).$(LUMINE_VER_MINOR).$(LUMINE_VER_PATCH).$(LUMINE_DEVICE_CODE)$(LUMINE_BRAND_CODE)$(LUMINE_REGION_CODE)$(LUMINE_TYPE_CODE)
LUMINE_VERSION := $(LUMINE_BASE_VERSION)-$(LUMINE_VERSION_SUFFIX)-$(LUMINE_BUILD_DATE)

PRODUCT_SYSTEM_PROPERTIES += \
    org.luminedroid.build.type=$(LUMINE_BUILD_TYPE) \
    org.luminedroid.build.version=$(LUMINE_VERSION_SUFFIX) \
    org.luminedroid.maintainer=$(LUMINE_MAINTAINER) \
    org.luminedroid.maintainer.link=$(LUMINE_MAINTAINER_LINK) \
    org.luminedroid.version=$(LUMINE_VERSION)
