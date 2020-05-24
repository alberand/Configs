#!/usr/bin/bash

#==============================================================================
# Script used to convert PDF images into EPS (used for lates)
#==============================================================================

for var in "$@"
do
    imagename=$(echo "$var" | rev | cut -d'.' -f2- | rev)
    convert ./$var eps2:./$imagename.eps
    rm ./$var
done
