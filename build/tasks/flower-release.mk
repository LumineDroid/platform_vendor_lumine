# Copyright (C) 2017 Unlegacy-Android
# Copyright (C) 2017,2020 The LineageOS Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# -----------------------------------------------------------------
# LumineDroid OTA update package

LUMINE_TARGET_PACKAGE := $(PRODUCT_OUT)/LumineDroid-$(LUMINE_VERSION).zip
LUMINE_TARGET_UPDATEPACKAGE := $(PRODUCT_OUT)/LumineDroid-$(LUMINE_VERSION)-img.zip
LUMINE_BUILD_TIME := 

SHA256 := prebuilts/build-tools/path/$(HOST_PREBUILT_TAG)/sha256sum

.PHONY: flower-release
flower-release: $(DEFAULT_GOAL) $(INTERNAL_OTA_PACKAGE_TARGET) $(INTERNAL_UPDATE_PACKAGE_TARGET)
	$(hide) ln -f $(INTERNAL_OTA_PACKAGE_TARGET) $(LUMINE_TARGET_PACKAGE)
	$(hide) $(SHA256) $(LUMINE_TARGET_PACKAGE) > $(LUMINE_TARGET_PACKAGE).sha256sum
	$(hide) source ./vendor/lumine/build/tools/generate_json_build_info.sh $(LUMINE_TARGET_PACKAGE)
	$(hide) ln -f $(INTERNAL_UPDATE_PACKAGE_TARGET) $(LUMINE_TARGET_UPDATEPACKAGE)
	$(hide) $(SHA256) $(LUMINE_TARGET_UPDATEPACKAGE) > $(LUMINE_TARGET_UPDATEPACKAGE).sha256sum
	@echo -e ${C								                         "${CL_BLU}
	@echo -e ${CL_BLU}"                                                                              "${CL_BLU}
	@echo -e ${CL_CYN}"=============================-OTA Package Details-============================"${CL_RST}
	@echo -e ${CL_CYN}"OutputZip      : "${CL_MAG} $(LUMINE_TARGET_PACKAGE)${CL_RST}
	@echo -e ${CL_CYN}"SHA256            : "${CL_MAG}" $(shell cat $(LUMINE_TARGET_PACKAGE).sha256sum | awk '{print $$1}')"${CL_RST}
	@echo -e ${CL_CYN}"Size           : "${CL_MAG}" $(shell du -hs $(LUMINE_TARGET_PACKAGE) | awk '{print $$1}')"${CL_RST}
	@echo -e ${CL_CYN}"Size(in bytes) : "${CL_MAG}" $(shell wc -c $(LUMINE_TARGET_PACKAGE) | awk '{print $$1}')"${CL_RST}
	@echo -e ${CL_CYN}"Build Type     : "${CL_MAG} $(LUMINE_BUILD_TYPE)${CL_RST}
	@echo -e ${CL_CYN}"==========================================================================="${CL_RST}
	@echo -e ""
	@echo -e ${CL_CYN}"============================-Fastboot Package Details-=============================="${CL_RST}
	@echo -e ${CL_CYN}"OutputZip      : "${CL_MAG} $(LUMINE_TARGET_UPDATEPACKAGE)${CL_RST}
	@echo -e ${CL_CYN}"SHA256            : "${CL_MAG}" $(shell cat $(LUMINE_TARGET_UPDATEPACKAGE).sha256sum | awk '{print $$1}')"${CL_RST} 
	@echo -e ${CL_CYN}"Size           : "${CL_MAG}" $(shell du -hs $(LUMINE_TARGET_UPDATEPACKAGE) | awk '{print $$1}')"${CL_RST}
	@echo -e ${CL_CYN}"Size(in bytes) : "${CL_MAG}" $(shell wc -c $(LUMINE_TARGET_UPDATEPACKAGE) | awk '{print $$1}')"${CL_RST} 
	@echo -e ${CL_CYN}"Build Type     : "${CL_MAG} $(LUMINE_BUILD_TYPE)${CL_RST}
	@echo -e ${CL_CYN}"==========================================================================="${CL_RST}
	@echo -e ""
