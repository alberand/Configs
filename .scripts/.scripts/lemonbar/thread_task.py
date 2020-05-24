#/usr/bin/python
# coding=utf-8

#==============================================================================
# This class represents an action that should be run only after a certain amount
# of time has passed — a timer. Timer is a subclass of Thread and as such also
# functions as an example of creating custom threads.
#==============================================================================

import time
import threading


class TThread(threading.Thread):
    """
    Thread that executes a task every N seconds
    """
    
    def __init__(self, func, params):
        threading.Thread.__init__(self)
        self._finished = threading.Event()
        self._interval = 2.0
        self._func = func
        self._params = params
        self.result = None

        self.setDaemon(1)
    
    def setInterval(self, interval):
        """
        Set the number of seconds we sleep between executing our task
        """
        self._interval = interval
    
    def stop(self):
        """
        Stop this thread
        """
        self._finished.set()
    
    def run(self):
        while 1:
            if self._finished.isSet():
                return
            self.result = self._func(self._params)
            
            # sleep for interval or until shutdown
            self._finished.wait(self._interval)

    def getResult(self):
        return self.result
    

if __name__ == '__main__':
    task = TThread(print, 'sup')
    task.start()
    try:
        while True:
            print('Cycle.')
            time.sleep(1)
    except KeyboardInterrupt:
        print('Exinting...')
        task.stop()
