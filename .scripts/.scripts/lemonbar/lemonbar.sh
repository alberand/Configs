#! /bin/bash
#
# I3 bar with https://github.com/LemonBoy/bar

panel_fifo="/tmp/i3_lemonbar_${USER}"

echo $(basename $0)
if [ $(pgrep -cx $(basename $0)) -gt 1 ] ; then
    printf "%s\n" "The status bar is already running." >&2
    exit 1
fi

trap 'trap - TERM; kill 0' INT TERM QUIT EXIT

SCRIPT_DIR="$( cd "$( dirname "$0" )" && pwd )"
$SCRIPT_DIR/lemonbar.py | lemonbar -p -f "Droid Sans-9" -f "FontAwesome-11" -g1366x22 eDP1
