#!/usr/bin/env sh

rm -f results*
hyperfine -N --style full --export-markdown results.md --sort command \
    -w 5 -r 30 \
    -L threads 1,2,4,8 \
    -L rectsize 0.01,0.001,0.00001,0.0000001,0.000000001 \
    './main {rectsize} {threads}' |
    tee results.txt

#     -L params '0.01 1','0.001 2' \
#     './main {params}' |
