#!/usr/bin/python
# coding=utf-8

import subprocess
import re

def get_running_interfaces():
    cmd = 'ifconfig'

    process = subprocess.Popen(cmd, stdout=subprocess.PIPE)
    output = str(process.communicate()[0])

    return output


if __name__ == '__main__':
    data = get_running_interfaces()

    regex = re.compile('([A-z0-9]*: )')
    res = regex.search(data)
    for item in re.finditer(regex, data):
        s = item.start()
        e = item.end()
        #print(item)
        print(data[s:e])
    # print(len(res))
    # print(res)
