#!/usr/bin/env sh

[ ! -d "$1" ] && exit 69

TNAME="02_MichalHemperek.tar.gz"
TEMP=$(mktemp -d)
DIR="$(readlink -f $1)"
find "$DIR" -mindepth 1 -maxdepth 1 -type d -print0 |
    xargs -0 -I{} make -C "{}" clean

rm -f "$TNAME"
cd "$TEMP"
cp -r "$DIR"/* .

tar czf "$TNAME" *
mv *.gz "$DIR/.."
# cd "$DIR"
rm -r "$TEMP"
