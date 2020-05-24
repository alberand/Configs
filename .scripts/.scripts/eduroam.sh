#!/bin/bash

#==============================================================================
# Script for connecting to WiFi network.
#==============================================================================

# Configuration
config="/home/andrew/.scripts/network/wpa"

# Check if script is run as sudo user
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root"
   exit 1
fi

# Find existing and not used wireless interface
wl_ints=(`ip link show | grep -oP '\d+: [a-z0-9]+' | cut -d' ' -f2 | grep -P '^w'`)

for interface in "${wl_ints[@]}"
do
    # Check if this interface is already in use
    is_interface_used=$(cat /sys/class/net/$interface/operstate)

    if [ "$is_interface_used" == "up" ]; then
        echo "Interface $interface is already in use. Exiting..."
        exit 1
    else
        wireless="$interface"
    fi
done

# Create log file
now=$(date "+%Y.%m.%d_%H:%M:%S")
log=$(mktemp /tmp/wifi_$now.log_XXXXXXXX)
chmod +r $log

echo "Logging file $log"

# Run client
nohup wpa_supplicant -i $wireless -c $config &> $log &
nohup dhclient $wireless &> $log &
