#!/usr/bin/env bash
set -euo pipefail

: "${SRC_HOST:?}" "${SRC_PORT:?}" "${SRC_PW:?}"
: "${DST_HOST:?}" "${DST_PORT:?}" "${DST_PW:?}"

EXTRA=("$@")   # e.g. --dry-run, --key-include='sess:*'

SRC_SCHEME="redis"; [ -n "${SRC_TLS:-}" ] && SRC_SCHEME="rediss"
DST_SCHEME="redis"; [ -n "${DST_TLS:-}" ] && DST_SCHEME="rediss"

TLS_ARGS=()
[ -n "${SRC_TLS:-}" ] && TLS_ARGS+=(--source-tls)
[ -n "${DST_TLS:-}" ] && TLS_ARGS+=(--target-tls)

# Passed via picocli @argfile expansion so the passwords never appear in argv/ps.
CREDFILE="$(mktemp)"
chmod 600 "$CREDFILE"
trap 'rm -f "$CREDFILE"' EXIT
printf -- '--source-pass=%s\n--target-pass=%s\n' "$SRC_PW" "$DST_PW" > "$CREDFILE"

riot replicate \
  "${SRC_SCHEME}://${SRC_HOST}:${SRC_PORT}" \
  "${DST_SCHEME}://${DST_HOST}:${DST_PORT}" \
  "@${CREDFILE}" \
  "${TLS_ARGS[@]}" \
  --scan-count=2000 \
  --read-threads=8 --read-batch=500 --read-retry=3 \
  --batch=500 --threads=8 \
  --source-pool=16 --target-pool=16 \
  --retry=LIMIT --retry-limit=3 \
  --skip=LIMIT --skip-limit=100 \
  --compare=FULL \
  --ttl-tolerance=60s \
  --progress=LOG --info \
  "${EXTRA[@]}"
