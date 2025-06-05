#!/usr/bin/env sh

SDIR="${0%/*}/.."
for file in "$SDIR"/cases/perf*; do
    echo "$file"
    cat "$file" | "$1" 10
done
