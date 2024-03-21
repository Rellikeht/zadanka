#!/usr/bin/env sh

if [ ! -x "$1" ]; then
    echo Należy podać plik wykonywalny >>/dev/stderr
    exit 1
fi

if [ -z "$2" ]; then
    echo Należy podać plik wyjściowy >>/dev/stderr
    exit 2
fi

for i in 10k 100k 1M; do
    [ ! -e "$i" ] && head -c "$i" /dev/urandom >"$i"
    hyperfine --style full -N -w 2 -r 10 "$1 $i" |
        tee >>"$2"
done
