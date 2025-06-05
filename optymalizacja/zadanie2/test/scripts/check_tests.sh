#!/usr/bin/env sh

SDIR="${0%/*}/.."
for case in "$SDIR"/cases/case[0-9]*; do
    cat "$case" | python ./test/scripts/check_test_case.py
    echo
done
