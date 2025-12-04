#
# Copyright (C) 2010 The Android Open Source Project
# Copyright (C) 2016 The CyanogenMod Project
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
#

# Makefile for producing lumine sdk coverage reports.
# Run "make lumine-sdk-test-coverage" in the $ANDROID_BUILD_TOP directory.

lumine_sdk_api_coverage_exe := $(HOST_OUT_EXECUTABLES)/lumine-sdk-api-coverage
dexdeps_exe := $(HOST_OUT_EXECUTABLES)/dexdeps

coverage_out := $(HOST_OUT)/lumine-sdk-api-coverage

api_text_description := lumine-sdk/api/lumine_current.txt
api_xml_description := $(coverage_out)/api.xml
$(api_xml_description) : $(api_text_description) $(APICHECK)
	$(hide) echo "Converting API file to XML: $@"
	$(hide) mkdir -p $(dir $@)
	$(hide) $(APICHECK_COMMAND) -convert2xml $< $@

lumine-sdk-test-coverage-report := $(coverage_out)/lumine-sdk-test-coverage.html

lumine_sdk_tests_apk := $(call intermediates-dir-for,APPS,LineagePlatformTests)/package.apk
luminesettingsprovider_tests_apk := $(call intermediates-dir-for,APPS,LineageSettingsProviderTests)/package.apk
lumine_sdk_api_coverage_dependencies := $(lumine_sdk_api_coverage_exe) $(dexdeps_exe) $(api_xml_description)

$(lumine-sdk-test-coverage-report): PRIVATE_TEST_CASES := $(lumine_sdk_tests_apk) $(luminesettingsprovider_tests_apk)
$(lumine-sdk-test-coverage-report): PRIVATE_LINEAGE_SDK_API_COVERAGE_EXE := $(lumine_sdk_api_coverage_exe)
$(lumine-sdk-test-coverage-report): PRIVATE_DEXDEPS_EXE := $(dexdeps_exe)
$(lumine-sdk-test-coverage-report): PRIVATE_API_XML_DESC := $(api_xml_description)
$(lumine-sdk-test-coverage-report): $(lumine_sdk_tests_apk) $(luminesettingsprovider_tests_apk) $(lumine_sdk_api_coverage_dependencies) | $(ACP)
	$(call generate-lumine-coverage-report,"LINEAGE-SDK API Coverage Report",\
			$(PRIVATE_TEST_CASES),html)

.PHONY: lumine-sdk-test-coverage
lumine-sdk-test-coverage : $(lumine-sdk-test-coverage-report)

# Put the test coverage report in the dist dir if "lumine-sdk" is among the build goals.
ifneq ($(filter lumine-sdk, $(MAKECMDGOALS)),)
  $(call dist-for-goals, lumine-sdk, $(lumine-sdk-test-coverage-report):lumine-sdk-test-coverage-report.html)
endif

# Arguments;
#  1 - Name of the report printed out on the screen
#  2 - List of apk files that will be scanned to generate the report
#  3 - Format of the report
define generate-lumine-coverage-report
	$(hide) mkdir -p $(dir $@)
	$(hide) $(PRIVATE_LINEAGE_SDK_API_COVERAGE_EXE) -d $(PRIVATE_DEXDEPS_EXE) -a $(PRIVATE_API_XML_DESC) -f $(3) -o $@ $(2) -cm
	@ echo $(1): file://$@
endef

# Reset temp vars
lumine_sdk_api_coverage_dependencies :=
lumine-sdk-combined-coverage-report :=
lumine-sdk-combined-xml-coverage-report :=
lumine-sdk-verifier-coverage-report :=
lumine-sdk-test-coverage-report :=
api_xml_description :=
api_text_description :=
coverage_out :=
dexdeps_exe :=
lumine_sdk_api_coverage_exe :=
lumine_sdk_verifier_apk :=
android_lumine_sdk_zip :=
