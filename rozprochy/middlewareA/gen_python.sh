#!/usr/bin/env sh

set -e
cd "${0%/*}"

FILE="common/service.proto"
if [ -n "$1" ]; then
    FILE="$1"
fi

OUT="client"
mkdir -p "$OUT"

python -m grpc_tools.protoc -I common \
    --python_out="$OUT" --pyi_out="$OUT" \
    --grpc_python_out="$OUT" \
    "$FILE"
