
from ratecontroller import rate_controller_sample as rc
from generator import job_generator

def get_logger():
    from logging import basicConfig, root, getLogger, CRITICAL, ERROR, WARNING, INFO, DEBUG, NOTSET
    from sys import stdout
    FORMAT = '%(asctime)s p%(process)d t%(thread)d %(levelname)s %(name)s %(message)s'
    basicConfig(format=FORMAT, stream = stdout)
    logger = getLogger('tester')
    logger.setLevel(INFO)
    return logger

logger = get_logger()
jobs   = job_generator()

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
        
