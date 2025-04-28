#!/usr/bin/env sh

SDIR="${0%/*}"
slice2py --output-dir="$SDIR/client" "$SDIR/slice/SimpleService.ice"
