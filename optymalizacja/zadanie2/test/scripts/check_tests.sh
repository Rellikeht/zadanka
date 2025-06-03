#!/usr/bin/env sh

SDIR="${0%/*}/.."
for case in "$SDIR"/cases/test_case_[0-9]*; do
    cat "$case" | python ./test/scripts/check_test_case.py
    echo
done
