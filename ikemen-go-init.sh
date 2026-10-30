#!/usr/bin/env bash
set -e

if [ "$#" -ne 1 ]; then
  echo "Usage: ikemen-go-init <directory>" >&2
  exit 2
fi

game="$1"

if [ -e "$game" ]; then
  echo "Directory already exists: $game" >&2
  exit 1
fi

mkdir -p "$game"
cp -r --no-preserve=mode "$RESOURCES/." "$game"
