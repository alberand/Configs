#!/bin/bash
#==============================================================================
# Script for sharing internet from ethernet cable to wi-fi.
# Run second time to kill all.
#==============================================================================

function notify(){
    sudo -u andrew DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/1000/bus \
        notify-send "$1" "$2"
}

declare running=0
title="Wi-Fi Hotspot"
# Network interface
net_face="enp5s0"
# Manufacture and device id
dev_id="148f:5372"
# Connection information
net_name="STM32TEST"
net_pass=11235813
declare winterface=""

# Check if script is run as sudo user
if [[ $EUID -ne 0 ]]; then
   notify "$title" "This script must be run as root"
   exit 1
fi

# If already run kill hostapd and dhcpd
for process in hostapd dhcpcd
do
    if [ "$(pidof $process)" ]; then
        killall $process
        running=1
    fi
done

if [ "$running" -eq "1" ]; then
    notify "$title" "Stopping Wi-Fi hotspot."
    exit 0
fi


# Detect if device 'dev_id' is connected
is_connected=$(lsusb | grep $dev_id)

if [ "$is_connected" = "" ]; then
    notify "$title" "Device is not connected."
    exit 1
fi

# TODO: Don't know how to connect usb-device with related interface.
# Can't find how to do it. 

# Detect to which interface USB-stick is connecnted.

# Find all interfaces stated with 'w'. Sadenly there is no common name pattern
# for naming wireless interfaces so possibly needs to be changed.
wl_ints=(`ip link show | grep -oP '\d+: [a-z0-9]+' | cut -d' ' -f2 | grep -P '^w'`)

# if [ "$interface_detected" = "" ]; then
    # echo "Use wlp0s20u6 interface."
    # interface="wlp0s20u6"
# else
    # echo "Use wlp0s20u2 interface."
    # interface="wlp0s20u2"
# fi

for interface in "${wl_ints[@]}"
do
    # Check if this interface is already in use
    is_interface_used=$(cat /sys/class/net/$interface/operstate)

    if [ "$is_interface_used" == "up" ]; then
        echo "Interface $interface is already in use."
    else
        winterface="$interface"
    fi
done

# Kill wpa_supplicant if run
pid=$(pidof wpa_supplicant)
if [ $? -eq 0 ]; then
    kill $pid
fi

if [ -n "$winterface"  ]; then
    # Choose interface and run 'create_ap' on it.
    create_ap $winterface $net_face "$net_name" $net_pass &

    # Run dhcp server
    dhcpd $winterface &

    notify "$title" "Nework name: $net_name."
else
    notify "$title" "Can't find any available interface. All are in use all there is no interfaces. $interface"

fi
