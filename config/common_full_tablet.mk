# Define tablet-specific variables
TARGET_IS_TABLET := true

# Inherit mobile full common LumineDroid stuff
$(call inherit-product, vendor/lumine/config/common_mobile_full.mk)

# Inherit tablet common LumineDroid stuff
$(call inherit-product, vendor/lumine/config/tablet.mk)

$(call inherit-product, vendor/lumine/config/telephony.mk)
