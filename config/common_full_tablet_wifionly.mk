# Inherit mobile full common LumineDroid stuff
$(call inherit-product, vendor/lumine/config/common_mobile.mk)

# Inherit tablet common LumineDroid stuff
$(call inherit-product, vendor/lumine/config/tablet.mk)

$(call inherit-product, vendor/lumine/config/wifionly.mk)
