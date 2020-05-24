#!/usr/bin/env python
# -*- coding: utf-8 -*-
import re
import json
import subprocess

#==============================================================================
# This script is used to generate string for lemonbar to display workspaces.
# Returns '%{F#FFFFFF}%{B#000000}1%{F-}%{B-}%{F#555555}%{#000000}2%{F-}%{B-}'
#==============================================================================

# Define some colors for choosen and normal workspace
colors = {
    'f_c': '#FFFFFF',
    'b_c': '#000000',
    'f_n': '#555555',
    'b_n': '#FFFFFF'
}

# Functions to generate coresponding output
def choosen_workspace(num):
    return '%{{F{f_c}}}%{{B{b_c}}}%{{O3}} {0} %{{O3}}%{{F-}}%{{B-}}'.format(
            num, f_c=colors['f_c'], b_c=colors['b_c']
    )

def normal_workspace(num):
    return '%{{F{f_n}}}%{{B{b_n}}}%{{O3}} {0}%{{O3}} %{{F-}}%{{B-}}'.format(
            num, f_n=colors['f_n'], b_n=colors['b_n']
    )

# Get information about workspace situations
cmd = 'i3-msg -t get_workspaces'

process = subprocess.Popen(cmd.split(), stdout=subprocess.PIPE)
output = process.communicate()[0]

# Parse this infomation
info = json.loads(output.decode('UTF-8')) 
info.sort(key=lambda data: data['num'])
# If you want to look uncomment this line. There a lot of interesting
# infomation.
# import pprint
# pprint.pprint(info)

# Generate resulting string
result = ''
for ws in info:
    if ws['focused']:
        result += choosen_workspace(ws['num'])
    else:
        result += normal_workspace(ws['num'])

# Send it to output. If you want to run this scripts straings with lemonbar you
# need to add while loop. Because this sctipt will end.
print(result)
