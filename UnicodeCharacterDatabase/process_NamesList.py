#!/bin/python3

from sys import stdin, stdout
from re  import search, match

def main():
    infile  = stdin
    outfile = stdout
    pattern_blockheader = r'^@\s'
    pattern_subheader   = r'^@@\s'
    pattern_codepoint   = r'^[0-9A-F]+\s'
    for line in infile:
        if mm:=match(pattern_blockheader, line):
            outfile.write(line)
        elif mm:=match(pattern_subheader, line):
            outfile.write(line)
        elif mm:=match(pattern_codepoint, line):
            outfile.write(line)


if __name__ == '__main__':
    try:
        main()
    except BrokenPipeError as exc:
        sys.exit(exc.errno)