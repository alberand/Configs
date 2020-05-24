#!/bin/bash

# If some monitor is connected to VGA port put it on the right size of laptop
# screen
sleep 1
if [ $(xrandr -q | grep VGA | cut -d' ' -f2) == "connected" ]; then
    xrandr --output VGA-1 --auto --above eDP-1
else
    xrandr --output VGA-1 --auto
fi
