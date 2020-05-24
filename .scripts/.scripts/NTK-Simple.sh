#!/bin/bash

interface=wlp0s20u6

iw dev $interface connect "NTK-Simple"

killall dhcpd

dhclient $interface
