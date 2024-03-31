#!/usr/bin/env sh

[ ! -d "$1" ] && exit 69

DIR="$(readlink -f $1)"
TOP="MichalHemperek"
TEMP=$(mktemp -d)
cd "$TEMP"

mkdir "$TOP"
cp -r "$DIR" "$TOP"
tar czf "02_$TOP-$1.tar.gz" "$TOP"

mv *.gz "$DIR/.."
cd "$DIR"
rm -r "$TEMP"
