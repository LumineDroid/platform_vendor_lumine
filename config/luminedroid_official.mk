ifndef LUMINE_MAINTAINER
LUMINE_MAINTAINER := Luminers
endif

DEVICE_LIST := $(shell jq -r '.[][].codename' official_devices/devices.json)
OFFICIAL_MAINTAINER := $(shell jq -r --arg codename "$(LINEAGE_BUILD)" \
  '.[][] | select(.codename == $$codename) | .maintainer' official_devices/devices.json)

ifneq (,$(findstring $(LINEAGE_BUILD),$(DEVICE_LIST)))
    ifeq ($(OFFICIAL_MAINTAINER),$(LUMINE_MAINTAINER))
        LUMINE_BUILD_TYPE := OFFICIAL
        $(warning [LUMINE NOTICE] Device: $(LINEAGE_BUILD))
        $(warning [LUMINE NOTICE] Maintainer verified: $(LUMINE_MAINTAINER))
        $(warning [LUMINE NOTICE] LUMINE_BUILD_TYPE: $(LUMINE_BUILD_TYPE))
    else
        LUMINE_BUILD_TYPE := UNOFFICIAL
        $(warning [LUMINE WARNING] Device: $(LINEAGE_BUILD) is in the official list, but maintainer name does not match.)
        $(warning [LUMINE WARNING] Official maintainer: $(OFFICIAL_MAINTAINER))
        $(warning [LUMINE WARNING] Your maintainer name: $(LUMINE_MAINTAINER))
        $(warning [LUMINE WARNING] LUMINE_BUILD_TYPE has been set to: $(LUMINE_BUILD_TYPE))
    endif
else
    LUMINE_BUILD_TYPE := UNOFFICIAL
    $(warning [LUMINE ALERT] Device: $(LINEAGE_BUILD) not found in the official JSON list.)
    $(warning [LUMINE ALERT] LUMINE_BUILD_TYPE has been set to: $(LUMINE_BUILD_TYPE))
endif

PRODUCT_SYSTEM_PROPERTIES += \
    org.luminedroid.build.type=$(LUMINE_BUILD_TYPE) \
    org.luminedroid.maintainer=$(LUMINE_MAINTAINER)
