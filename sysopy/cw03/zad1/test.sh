#!/usr/bin/env sh

TFILE="$2.test"
DFILE="$2.diff"

$1 "$2" >"$TFILE"
$1 "$TFILE" >"$DFILE"
diff -q "$2" "$DFILE"
