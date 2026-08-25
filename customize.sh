#!/system/bin/sh
# Universal module installation script, compatible with both Magisk and KernelSU

ui_print "******************************"
ui_print "SOTER Key Fixer Module - Universal Edition"
ui_print "Version: 1.2 Stable"
ui_print "Author: CoolAPK Furry @XiaoHuangBo ต (=ω=)ต"
ui_print "Supports: Magisk & KernelSU"
ui_print "******************************"

# Set permissions
if [ -n "$MODPATH" ]; then
    # Magisk environment
    set_perm_recursive $MODPATH 0 0 0755 0644
    set_perm $MODPATH/service.sh 0 0 0755
    set_perm $MODPATH/fix_soter_key.sh 0 0 0755
else
    # KernelSU environment
    MODDIR=${0%/*}
    chmod 0755 $MODDIR/service.sh
    chmod 0755 $MODDIR/fix_soter_key.sh
fi
