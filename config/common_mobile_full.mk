# Inherit common Lumine stuff
$(call inherit-product, vendor/lumine/config/common_mobile.mk)

PRODUCT_SIZE := full

# Apps
ifneq ($(PRODUCT_NO_CAMERA),true)
PRODUCT_PACKAGES += \
    Aperture
endif

ifneq ($(TARGET_EXCLUDES_AUDIOFX),true)
PRODUCT_PACKAGES += \
    AudioFX
endif

# Extra cmdline tools
PRODUCT_PACKAGES += \
    unrar \
    zstd
