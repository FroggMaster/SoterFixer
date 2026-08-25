#!/system/bin/sh

# Module path compatible with both Magisk and KernelSU
if [ -n "$MODPATH" ]; then
    # Magisk environment
    MODDIR="$MODPATH"
else
    # KernelSU environment
    MODDIR=${0%/*}
fi

# Set permissions
chmod 0755 "$MODDIR/service.sh"
chmod 0755 "$MODDIR/fix_soter_key.sh"
