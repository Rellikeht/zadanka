#!/usr/bin/env sh

[ ! -d "$1" ] && exit 69

DIR="$(readlink -f $1)"
find "$DIR" -mindepth 1 -maxdepth 1 -type d -print0 |
    xargs -0 -I{} make -C "{}" clean

TOP="MichalHemperek"
TEMP=$(mktemp -d)
TNAME="02_$TOP-$1.tar.gz"

rm -f "$TNAME"
cd "$TEMP"
mkdir "$TOP"

cp -r "$DIR" "$TOP"
tar czf "$TNAME" "$TOP"

mv *.gz "$DIR/.."
# cd "$DIR"
rm -r "$TEMP"
