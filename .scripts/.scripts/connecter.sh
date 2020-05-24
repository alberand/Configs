#!/bin/bash

wire=enp5s0
wireless=wlp0s20u2
# wireless=wlp0s29u1u1
# wireless=wlp0s20u6

# Clear wire interface
ip addr flush dev $wire
ip route flush dev $wire
# Killall netowork services
for process in dhclient, dhcpcd, dhcpd
do
    if [ "$(pidof $process)" ]; then
        killall $process
    fi
done

wpa_supplicant -D n180211,wext -i $wireless -c /home/andrew/.scripts/network/kirya_house & # > /dev/null 2>&1 &
dhclient $wireless
