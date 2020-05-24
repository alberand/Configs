#!/bin/sh

case ${MONS_NUMBER} in
    1)
        mons -o
        touch "${HOME}/hello-o"
        ;;
    2)
        mons -s
        touch "${HOME}/hello-s"
        ;;
    *)
        # Handle it manually
        ;;
esac
