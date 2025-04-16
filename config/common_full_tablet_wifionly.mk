# Inherit mobile full common Lumine stuff
$(call inherit-product, vendor/lumine/config/common_mobile_full.mk)

# Inherit tablet common Lumine stuff
$(call inherit-product, vendor/lumine/config/tablet.mk)

$(call inherit-product, vendor/lumine/config/wifionly.mk)
