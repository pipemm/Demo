
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
        if volume < 1:
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

rate_controller_sample = RateController(limit=3500,period=1)

