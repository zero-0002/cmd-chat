#!/usr/bin/env sh
set -e

# Host and port have safe defaults but can be overridden at run time.
: "${HOST:=0.0.0.0}"
: "${PORT:=8000}"

# The server password is a secret. It is never baked into the image; it must be
# provided at run time, for example:
#   docker run -e PASSWORD=secret -p 8000:8000 ghcr.io/diorwave/cmd-chat:latest
if [ -z "${PASSWORD:-}" ]; then
  echo "ERROR: PASSWORD environment variable is required (pass it at run time, e.g. -e PASSWORD=...)." >&2
  exit 1
fi

exec python cmd_chat.py serve "$HOST" "$PORT" --password "$PASSWORD"
