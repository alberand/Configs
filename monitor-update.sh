#!/bin/sh

MAIN_SCREEN="1366x5+0+0" 
EXTERNAL_SCREEN="1920x5+0+0" 

case ${MONS_NUMBER} in
    1)
        # Switch to the main laptop monitor
        mons -o
        ;;
    2)
        # Switch to the external monitor
        mons -s
        ;;
    *)
        # Handle it manually
        ;;
esac
