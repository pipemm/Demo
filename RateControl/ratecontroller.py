#!/usr/bin/python3

def getlogger():
    from logging import basicConfig, root, getLogger, CRITICAL, ERROR, WARNING, INFO, DEBUG, NOTSET
    from sys import stdout
    FORMAT = '%(asctime)s p%(process)d t%(thread)d %(levelname)s %(name)s %(message)s'
    basicConfig(format=FORMAT, stream = stdout)
    logger = getLogger('ratecontroller')
    logger.setLevel(INFO)
    return logger

logger = getlogger()

class RateController():
    
    def __init__(self,limit=3500,period=1):
        from datetime import datetime, timedelta
        from time import sleep
        if period <= 0:
            period = 1
        if limit <=0:
            limit = 3500
        self.__delta = timedelta(seconds=period)
        self.__limit = 3500
        self.__book  = {}
        self.__now   = datetime.now
        self.__sleep = sleep
    
    def __rate(self):
        self.__flush()
        return sum(self.__book.values())
    
    def __flush(self):
        cuttime = self.__now() - self.__delta
        book    = self.__book
        self.__book = {k:book[k] for k in book if k>cuttime}
    
    def __submit(self,volume=1):
        now = self.__now
        while True:
            nowtime = now()
            if nowtime not in self.__book:
                break
        self.__book[nowtime] = volume
    
    def __next_check(self):
        return min(self.__book.keys())+self.__delta
    
    def __sleep_till_next_check(self):
        wait_second = (self.__next_check() - self.__now()).total_seconds()
        if wait_second <= 0:
            return
        self.__sleep(wait_second)
    
    def submit(self,volume=1):
        if volume <=0:
            volume = 1
        while True:
            if self.__rate() <= 0:
                self.__submit(volume=volume)
                break
            quota = self.__limit - self.__rate()
            if quota >= volume:
                self.__submit(volume=volume)
                break
            self.__sleep_till_next_check()

def job_generator(ceiling=1000):
    from random import randint
    if ceiling < 1:
        ceiling = 1000
    while True:
        yield randint(1, ceiling)

rc   = RateController()
jobs = job_generator()

from threading import Thread, Lock
lock_job = Lock()
lock_rc  = Lock()

def target_callable(jobs):
    while True:
        try:
            with lock_job:
                job = next(jobs)
        except StopIteration as e:
            logger.info('Stop Interation')
            break
        logger.info('submitting {}'.format(job))
        with lock_rc:
            rc.submit(job)
        logger.info('submittted {}'.format(job))

def test1():
    for job in jobs:
        logger.info('submitting {}'.format(job))
        rc.submit(job)
        logger.info('submittted {}'.format(job))

def test2():
    threads = [Thread(target=target_callable,args=(jobs,)) for _ in range(10)]
    for thread in threads:
        thread.start()
    for thread in threads:
        thread.join()

def main():
    test2()

if __name__ == '__main__':
    main()
        
