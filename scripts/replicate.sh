#!/usr/bin/env bash
set -euo pipefail

: "${SRC_HOST:?}" "${SRC_PORT:?}" "${SRC_PW:?}"
: "${DST_HOST:?}" "${DST_PORT:?}"

AUTH=(--source-pass "$SRC_PW")
[[ -n "${DST_PW:-}" ]] && AUTH+=(--target-pass "$DST_PW")

riot replicate \
  "redis://${SRC_HOST}:${SRC_PORT}" \
  "redis://${DST_HOST}:${DST_PORT}" \
  "${AUTH[@]}" \
  --scan-count=2000 \
  --read-threads=8 --read-batch=500 --read-retry=3 \
  --batch=500 --threads=8 \
  --source-pool=16 --target-pool=16 \
  --retry=LIMIT --retry-limit=3 \
  --skip=LIMIT --skip-limit=100 \
  --compare=FULL \
  --ttl-tolerance=60s \
  --progress=LOG --info \
  "$@"
