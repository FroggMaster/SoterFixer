#!/system/bin/sh
# Magisk module installation script

ui_print "******************************"
ui_print "SOTER Key Fixer Module"
ui_print "Version: 1.0"
ui_print "Author: XiaoHuangBo"
ui_print "******************************"

# Set permissions
set_perm_recursive $MODPATH 0 0 0755 0644
set_perm $MODPATH/service.sh 0 0 0755
set_perm $MODPATH/fix_soter_key.sh 0 0 0755
