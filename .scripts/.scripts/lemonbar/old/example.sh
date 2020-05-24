#!/usr/bin/bash

# Load config
. $(dirname $0)/lemonbar_config

# Check if there is already running lemonbar
if [ $(pgrep -cx $(basename $0)) -gt 1 ] ; then
    printf "%s\n" "The status bar is already running." >&2
    exit 1
fi

# Define the clock
clock(){
    DT=$(date '+%a %d.%m.%y %H:%M %p') 
    output=$($(dirname $0)/bar/styler.py -t "$DT" -i clock)
    echo -e "$output"
}

# Battery
battery(){
    bat=$($(dirname $0)/bar/battery BAT1)
    output=$($(dirname $0)/bar/styler.py -t "$bat" -i battery -s 5 5)
    echo -e "$output"
}

volume(){
    val=$($(dirname $0)/bar/get_volume.py)
    output=$($(dirname $0)/bar/styler.py -t "$val" -i vol -s 5 5)
    echo -e "$output"
}

brightness(){
    val=$($(dirname $0)/bar/get_brightness.py)
    output=$($(dirname $0)/bar/styler.py -t "$val" -i bright -s 5 5)
    echo -e "$output"
}

temp(){
    val=$(sensors coretemp-isa-0000 | awk '/Physical/ {print $4}')
    output=$($(dirname $0)/bar/styler.py -t "$val" -i temp -s 5 5)
    echo -e "$output"
}

groups() {
    val=$($(dirname $0)/bar/get_workspaces.py)
    output=$($(dirname $0)/bar/styler.py -t "$val")
    echo -e "$output"
}

internet() {
    val=$($(dirname $0)/bar/get_internet.py)
    output=$($(dirname $0)/bar/styler.py -t "$val" -i globe -s 5 5)
    echo -e "$output"
}

win_name(){
    pid=$(xprop -id $(xprop -root | awk '/_NET_ACTIVE_WINDOW\(WINDOW\)/{print $NF}') | awk '/_NET_WM_PID\(CARDINAL\)/{print $NF}')
    val=$(ps -p $pid -o comm=)
    output=$($(dirname $0)/bar/styler.py -t "$val" -i prog)
    echo -e "$output"
}

#==============================================================================
# Print
#==============================================================================
while true; do
	buf="%{Sf}"
    buf="$buf %{l}$(groups)" 
    # buf="$buf $(win_name)" 
	buf="$buf %{c}$(clock)"
	buf="$buf %{r}$(internet) "
	buf="$buf $(temp) "
	buf="$buf $(battery) "
	buf="$buf $(brightness) "
	buf="$buf $(volume)"

    # If we have a second screen on the right (it's assumption) copy bar there.
    # num_of_mon=$(xrandr -q | grep " connected" | wc -l)
    # if [ $num_of_mon -eq 2 ]; then
	    # buf="$buf %{S+}"
        # buf="$buf %{l}$(groups)" 
        # buf="$buf $(win_name)" 
	    # buf="$buf %{c}$(clock)"
	    # buf="$buf %{r}$(internet) "
	    # buf="$buf $(temp) "
	    # buf="$buf $(battery) "
	    # buf="$buf $(brightness) "
	    # buf="$buf $(volume)"
    # fi

	echo -e $buf
    sleep 1
done
