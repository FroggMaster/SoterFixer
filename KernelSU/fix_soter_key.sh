#!/system/bin/sh
echo "Starting SOTER Key repair"
stop vendor.soter
sleep 3
pm clear com.tencent.soter.soterserver
start vendor.soter
sleep 5
getprop init.svc.vendor.soter
echo "Repair complete. After boot, dial *#899# and select Manual Test to check the SOTER Key. If it fails, refresh a few more times"
