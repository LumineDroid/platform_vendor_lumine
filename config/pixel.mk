WITH_GMS := true

# Don't dexpreopt prebuilts. (For GMS).
DONT_DEXPREOPT_PREBUILTS := true

# Pixel Clocks
$(call inherit-product, vendor/pixel/clocks/products/clocks.mk)

# Pixel GMS
$(call inherit-product, vendor/pixel/gms/products/gms.mk)

# Pixel Prebuilts
$(call inherit-product, vendor/pixel/prebuilts/config.mk)

# Pixel Sounds
$(call inherit-product, vendor/pixel/sounds/products/sounds.mk)
