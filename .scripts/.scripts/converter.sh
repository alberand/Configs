#!/usr/bin/bash

for var in "$@"
do
    imagename=$(echo "$var" | rev | cut -d'.' -f2- | rev)
    convert ./$var eps2:./$imagename.eps
    rm ./$var
done
