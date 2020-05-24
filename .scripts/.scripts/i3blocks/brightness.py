#!/usr/bin/env python
# coding: utf-8

with open('/sys/class/backlight/intel_backlight/brightness') as br:
    brightness = br.readlines()[0].strip()
with open('/sys/class/backlight/intel_backlight/max_brightness') as mx:
    maximum = mx.readlines()[0].strip()
print(int(int(brightness)*100/int(maximum)))
