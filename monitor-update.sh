#!/bin/sh

MAIN_SCREEN="1366x5+0+0" 
EXTERNAL_SCREEN="1920x5+0+0" 

case ${MONS_NUMBER} in
    1)
        # Switch to the main laptop monitor
        mons -o
        # Reset notification daemon
        killall -9 dunst
        dunst -config "$HOME/.config/dunst/config" -geom "${MAIN_SCREEN}" > /dev/null 2>&1 &
        ;;
    2)
        # Switch to the external monitor
        mons -s
        # Reset notification daemon
        killall -9 dunst
        dunst -config "$HOME/.config/dunst/config" -geom "${EXTERNAL_SCREEN}" > /dev/null 2>&1 &
        ;;
    *)
        # Handle it manually
        # Reset notification daemon - run for main laptop monitor
        killall -9 dunst
        dunst -config "$HOME/.config/dunst/config" -geom "${MAIN_SCREEN}" > /dev/null 2>&1 &
        ;;
esac
