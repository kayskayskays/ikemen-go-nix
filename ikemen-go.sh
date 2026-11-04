#!/usr/bin/env bash
set -eu

game="${XDG_DATA_HOME:-$HOME/.local/share}/ikemen-go"

if [ "${1-}" = "--game" ]; then
  if [ "$#" -lt 2 ]; then
    echo "Usage: ikemen-go [--game DIRECTORY] [ARGS...]" >&2
    exit 2
  fi

  game="$2"
  shift 2
fi

if [ ! -d "$game" ]; then
  mkdir -p "$game"
  cp -R "$RESOURCES/." "$game"
  chmod -R u+w "$game"
fi

cd "$game"
exec "$ENGINE" "$@"
