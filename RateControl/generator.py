

def job_generator(ceiling=1000):
    from random import randint
    if ceiling < 1:
        ceiling = 1000
    while True:
        yield randint(1, ceiling)
