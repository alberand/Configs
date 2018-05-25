#!/bin/bash

# If some monitor is connected to VGA port put it above laptop's screen
sleep 1

# Old code for managing multiple monitors; replaced with mons
# if [ $(xrandr -q | grep VGA | cut -d' ' -f2) == "connected" ]; then
    # xrandr --output VGA-1 --auto --above eDP-1
    # xrandr --output eDP-1 --off --output VGA-1 --auto
# fi

# mons script from AUR
nohup mons -a > /dev/null 2>&1 &

# Disable touchpad while typing. Disables keyboard for 0.15s after keypress
syndaemon -i 0.15 -t -K -R -d

# Set layout to us and ru and 'Caps Lock' toggle
setxkbmap -layout us,ru -option grp:win_space_toggle

# Map Caps Lock to Ctrl
setxkbmap -option ctrl:nocaps

# Set repeat key time
xset r rate 400 30 &

# Run automount tool
devmon --exec-on-drive "i3-msg \"workspace 9; exec /usr/bin/terminator --working-directory='%d' \"" &

# Run compositor
compton -b --config ~/.config/compton.conf &

# Set desktop wallpapaer or color
# feh --bg-scale /home/andrew/.stuff/wallpaper_2.jpg
hsetroot -solid "#182438"

exec i3
