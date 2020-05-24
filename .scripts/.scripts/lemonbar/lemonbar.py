#!/usr/bin/env python
# -*- coding: utf-8 -*-

import re
import os
import select
import sys
import json
import time
import datetime
import subprocess
from urllib.request import urlopen, URLError
from utils.utils import *
from utils.config import colors, icons
from thread_task import TThread

def get_volume():
    cmd = 'amixer get -c 1 Master'

    process = subprocess.Popen(cmd.split(), stdout=subprocess.PIPE)
    output = process.communicate()[0]

    result = re.search('\[\d*%\]', str(output))
    return result.group()[1:-1]

def get_battery():
    cmd = '/'.join(os.path.realpath(__file__).split('/')[:-1]) + \
            '/utils/battery BAT1'

    process = subprocess.Popen(cmd.split(), stdout=subprocess.PIPE)
    output = process.communicate()[0]
    
    percentage = output.decode('UTF-8')[:-1]

    return percentage

def get_temp():
    cmd = 'sensors coretemp-isa-0000'

    process = subprocess.Popen(cmd.split(), stdout=subprocess.PIPE)
    output = process.communicate()[0]

    line = re.findall(r'Physical.*', output.decode('UTF-8'))[0]
    return line.split()[3]

def get_date():
    date = datetime.datetime.now()

    return date.strftime('%a %d.%m.%y %H:%M %p')

def get_workspaces():
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
            result += _choosen_workspace(ws['num'])
        else:
            result += _normal_workspace(ws['num'])

    # Send it to output. If you want to run this scripts straings with 
    # lemonbar you need to add while loop. Because this sctipt will end.
    return result

def get_brightness():
    with open('/sys/class/backlight/intel_backlight/brightness') as br:
        brightness = br.readlines()[0].strip()
    with open('/sys/class/backlight/intel_backlight/max_brightness') as mx:
        maximum = mx.readlines()[0].strip()

    br = int(int(brightness)*100/int(maximum))
    return br

def get_internet():
    cmd = '/'.join(os.path.realpath(__file__).split('/')[:-1]) + \
            '/utils/internet'

    comp = subprocess.run(cmd.split(), stdout=subprocess.PIPE)

    return comp.returncode

#==============================================================================
# Functions user to generate coresponding output for workspaces' bar.
#==============================================================================
def _choosen_workspace(num):
    num = ' ' + str(num) + ' '
    return set_f_color(
            set_b_color(
                set_spacing(num, (3, 3)), colors['c_gray']
            ),
            colors['c_white']
    )

def _normal_workspace(num):
    num = ' ' + str(num) + ' '
    return set_f_color(set_spacing(num, (3, 3)),  colors['c_white'])

def get_data(mask=[1, 1, 1, 1, 1, 1]):
    '''
    Get data and set appearance for it. Returned list: 
    [date, volume, brightness, battery, temp, internet]
    Args:
        mask: list which is used to choose which data do you need. For example
        all 'one' return all accessable data, all zeros returns nothing.
    Returns:
        list with data represented as strings.
    '''
    result = list()
    if mask[0]:
        date = set_f_color(
                set_spacing(
                    set_icon(get_date(), 'clock'), 
                    (10, 10)), 
                colors['c_white'])
        result.append(date)

    if mask[1]:
        volume = set_f_color(
                set_spacing(
                    set_icon(get_volume(), 'vol'), 
                    (10, 10)), 
                colors['c_white'])
        result.append(volume)

    if mask[2]:
        bright = set_f_color(
                set_spacing(
                    set_icon(get_brightness(), 'bright'), 
                    (10, 10)), 
                colors['c_white'])
        result.append(bright)

    if mask[3]:
        battery = set_f_color(
                set_spacing(
                    set_icon(get_battery(), 'battery'), 
                    (10, 10)), 
                colors['c_white'])
        result.append(battery)

    if mask[4]:
        raw_value = get_temp()
        result_temp = set_spacing(set_icon('', 'temp'), (10, 7))

        temp = float(raw_value[1:5])
        if temp < 70:
            result_temp = set_f_color(result_temp, colors['c_white'])
        elif temp < 90:
            result_temp = set_f_color(result_temp, colors['c_red_l'])
        else:
            result_temp = set_f_color(result_temp, colors['c_white'])

        result.append(result_temp)

    if mask[5]:
        internet = set_spacing(set_icon('', 'globe'), (5, 5))
        if get_internet():
            internet = set_f_color(internet, colors['c_green_l'])
        else:
            internet = set_f_color(internet, colors['c_red_l'])
        result.append(internet)

    return result

#==============================================================================
# Main cycle
#==============================================================================
if __name__ == '__main__':

    date, volume, bright, battery, temp, internet = get_data()

    test = False
    if test:
        print('-'*80)
        print('{:^80}'.format('Test functionality.'))
        print('-'*80)
        print('Date: {}'.format(date))
        print('Volume: {}'.format(volume))
        print('Brightness: {}'.format(bright))
        print('Battery: {}'.format(battery))
        print('Temperature: {}'.format(temp))
        print('Workspaces: {}'.format(get_workspaces()))
        print('-'*80)

#==============================================================================
# Start ouput
#==============================================================================
    sread, swrite = os.pipe()
    hooks = {}
    battery_n = True

    print('%{{l}}{ws} %{{c}}{dt} %{{r}}{tm}{ba}{br}{vl}'.format(
            ws=get_workspaces(), dt=date, tm=temp, ba=battery, 
            br=bright, vl=volume))
    sys.stdout.flush()

    # Create periodicly executing function which is need to update data only in
    # some defined interval. It is used for date, battery, internet and
    # temperature.
    task = TThread(get_data, [1, 0, 0, 1, 1, 1])
    task.setInterval(10)
    task.start()

    try:
        while True:
            # Get data every cycle. Workspaces also read every cycle
            volume, bright = get_data([0, 1, 1, 0, 0, 0])
            # Get data every 10 second
            one_s_result = task.getResult()
            if one_s_result:
                date, battery, temp, internet = one_s_result
            # Now let's show notification when battery is too low
            try:
                if int(get_battery()[:3]) < 20:
                    if battery_n:
                        notify = 'notify-send -u critical "Low Battery"'
                        process = subprocess.Popen(
                                notify.split(), stdout=subprocess.PIPE)
                        battery_n = False
                else:
                    battery_n = True
            except ValueError as e:
                pass


            ready, _, _ = select.select([sread], [], [], 0.1)
            updated = True
            # render
            if updated:
                print('%{{B#00ff0f0f}}%{{l}}{ws} %{{c}}{dt} %{{r}}{con}{tm}'
                      '{ba}{br}{vl}%{{B-}}'.format(
                        ws=get_workspaces(), dt=date, con=internet, tm=temp, 
                        ba=battery, br=bright, vl=volume))
                sys.stdout.flush()
    except Exception as e:
        task.stop()
