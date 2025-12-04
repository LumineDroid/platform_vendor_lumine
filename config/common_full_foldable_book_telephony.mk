# Inherit mobile full common LumineDroid stuff
$(call inherit-product, vendor/lumine/config/common_mobile.mk)

# Enable support of one-handed mode
PRODUCT_PRODUCT_PROPERTIES += \
    ro.support_one_handed_mode?=true

# Inherit tablet common LumineDroid stuff
$(call inherit-product, vendor/lumine/config/tablet.mk)

$(call inherit-product, vendor/lumine/config/telephony.mk)

PRODUCT_PACKAGE_OVERLAYS += vendor/lumine/overlay/foldable_book
