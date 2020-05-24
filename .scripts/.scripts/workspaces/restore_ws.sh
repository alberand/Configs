#!/bin/sh

# Load i3 workspace from *.json file created by i3-save-tree
# Runs all application found in this file

# As first argument workspace number. For examples: worksapce_{NUMBER}.json
# Second argument on which workspace restore this layout

DIR="$( dirname "$(readlink -f "$0")" )"

# Load layout 
i3-msg "workspace $2; append_layout $DIR/workspace-$1.json"

# Run applications
apps=$(cat $DIR/workspace-$1.json | grep "instance" | cut -d'"' -f4 | cut -c2- | rev | cut -c2- | rev)

for app in $apps
do
    ${app,,} &
done
