#!/usr/bin/env python3
import datetime
import sys

SLOW_THRESHOLD = 0.025

def parse_line(raw_line):
    nonewline = raw_line.strip('\n')
    timestr, rest = nonewline.split(' ', 1)
    timestr = timestr.strip('+')
    return float(timestr), rest

def main(filename):
    with open(filename) as f:
        count = 0
        start_time, start_line = parse_line(f.readline())
        print("start {start_time}".format(start_time=start_time))
        print("0 {line}".format(line=start_line))

        prev_line = start_line
        prev_line_start = start_time
        for line in f.readlines():
            count += 1
            if len(line) == 0 or line == "\n":
                continue
            if not (line[0].isdigit() or line[0] == '+'):
                continue

            try:
                curr_line_start, curr_line = parse_line(line)
                diff = curr_line_start - prev_line_start
                if diff > SLOW_THRESHOLD:
                    print("{since_start} {diff} {prev_line}".format(
                        since_start=curr_line_start-start_time,
                        diff=diff,
                        prev_line=prev_line))
                prev_line_start = curr_line_start
                prev_line = curr_line
            except ValueError:
                continue

if __name__ == "__main__":
    main(sys.argv[1])
