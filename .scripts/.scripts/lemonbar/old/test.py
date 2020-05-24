#!/usr/bin/env python
# -*- coding: utf-8 -*-

import time
import os
import select
import sys

if __name__ == '__main__':
    sread, swrite = os.pipe()
    hooks = {}

    print('Hello')
    sys.stdout.flush()

    i = 0
    while True:
        ready, _, _ = select.select([sread], [], [], 0.1)
        # poll / update widgets (rerender only on updates that match hooks,
        # or on regular timeouts)
        updated = False
        if len(ready) > 0:
            for p in ready:
                lines = os.read(p, 4096).decode('utf-8').splitlines()
                for line in lines:
                    for first, hook in hooks.items():
                        if line.startswith(first):
                            updated = True
                            hook.update(line)
        else:
            updated = True
        # render
        if updated:
            print(i)
            sys.stdout.flush()
        i += 1
