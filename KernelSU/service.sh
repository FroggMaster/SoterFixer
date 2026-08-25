#!/system/bin/sh

# Wait for system boot to complete
until [ "$(getprop sys.boot_completed)" = "1" ]; do
    sleep 5
done

# Calculate start time
START_TIME=$(date +%s)
END_TIME=$((START_TIME + 300))  # 5 minutes = 300 seconds

# Run the repair every 5 seconds for 5 minutes
while [ $(date +%s) -lt $END_TIME ]; do
    # Execute repair script
    stop vendor.soter
    sleep 1
    pm clear com.tencent.soter.soterserver
    start vendor.soter
    sleep 1
    
    # Runs every 5 seconds (about 60 times in total)
    sleep 3
done
