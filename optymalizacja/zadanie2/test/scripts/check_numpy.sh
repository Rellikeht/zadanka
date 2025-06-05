#!/usr/bin/env sh

SDIR="${0%/*}/.."
for case in "$SDIR"/cases/case[0-9]*; do
    python ./test/scripts/check_with_numpy.py "$1" "$case"
    echo
done
