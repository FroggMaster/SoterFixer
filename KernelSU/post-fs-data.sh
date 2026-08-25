#!/system/bin/sh
# KernelSU module installation script

MODDIR=${0%/*}

# Set permissions
chmod 0755 $MODDIR/service.sh
chmod 0755 $MODDIR/fix_soter_key.sh
