#!/usr/bin/env bash
set -e

if [ "${1-}" = "--game" ]; then
  if [ "$#" -lt 2 ]; then
    echo "Usage: ikemen-go [--game DIRECTORY] [ARGS...]" >&2
    exit 2
  fi

  cd "$2"
  shift 2
fi

exec "$ENGINE" "$@"
