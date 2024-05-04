#!/bin/python3

def main():
    infile  = sys.stdin
    outfile = sys.stdout
    for line in infile:
        outfile.write(line)
        outfile.write('\n')


if __name__ == '__main__':
    try:
        main()
    except BrokenPipeError as exc:
        sys.exit(exc.errno)