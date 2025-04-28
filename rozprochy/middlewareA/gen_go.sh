#!/usr/bin/env sh

set -e
cd "${0%/*}"

FILE="common/service.proto"
if [ -n "$1" ]; then
    FILE="$1"
fi

OUT="server"
mkdir -p "$OUT"

protoc \
    --go_out="$OUT" --go_opt=paths=source_relative \
    --go-grpc_out="$OUT" --go-grpc_opt=paths=source_relative \
    "$FILE"
