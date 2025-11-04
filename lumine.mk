#
# Copyright (C) 2025 LumineDroid
#
# SPDX-License-Identifier: Apache-2.0
#

# Bootanimation
include vendor/lumine/config/bootanimation.mk

# Enable blur
TARGET_ENABLE_BLUR ?= true
ifeq ($(TARGET_ENABLE_BLUR),true)
PRODUCT_SYSTEM_PROPERTIES += \
    ro.custom.blur.enable=true \
    persist.sysui.disableBlur=false \
    ro.surface_flinger.supports_background_blur=1
else
PRODUCT_SYSTEM_PROPERTIES += \
    ro.custom.blur.enable=false \
    persist.sysui.disableBlur=true \
    ro.surface_flinger.supports_background_blur=0
endif

# Enable Material Design 3 Expressive
PRODUCT_PRODUCT_PROPERTIES += \
    is_expressive_design_enabled=true

# Fonts
PRODUCT_PACKAGES += \
    fonts_customization.xml \
    FontAccuratistOverlay \
    FontAclonicaOverlay \
    FontAmaranteOverlay \
    FontBariolOverlay \
    FontCagliostroOverlay \
    FontCoconOverlay \
    FontComfortaaOverlay \
    FontComicSansOverlay \
    FontCookieRunOverlay \
    FontCoolstoryOverlay \
    FontExotwoOverlay \
    FontFifa2018Overlay \
    FontGrandHotelOverlay \
    FontGoogleSansFlexOverlay \
    FontHarmonySansOverlay \
    FontLatoOverlay \
    FontLinotteOverlay \
    FontNokiaPureOverlay \
    FontNothingDotHeadlineOverlay \
    FontNothingDotOverlay \
    FontNunitoOverlay \
    FontOneplusSansOverlay \
    FontOneplusSlateOverlay \
    FontOswaldOverlay \
    FontPlayOverlay \
    FontQuandoOverlay \
    FontRedressedOverlay \
    FontReemKufiOverlay \
    FontRobotoCondensedOverlay \
    FontRookeryOverlay \
    FontRubikOverlay \
    FontSanFranciscoDisplayProSourceOverlay \
    FontSamsungOneOverlay \
    FontSansSerifOverlay \
    FontSonySketchOverlay \
    FontStoropiaOverlay \
    FontSurferOverlay \
    FontUbuntuOverlay

$(call inherit-product-if-exists, external/google-fonts/lato/fonts.mk)
$(call inherit-product-if-exists, external/google-fonts/rubik/fonts.mk)

PRODUCT_COPY_FILES += \
    $(call find-copy-subdir-files,*,vendor/lumine/prebuilt/product/fonts,$(TARGET_COPY_OUT_PRODUCT)/fonts)

# GameSpace
PRODUCT_PACKAGES += \
    GameSpace

# Overlays
PRODUCT_PACKAGES += \
    FrameworkOverlayLumine
