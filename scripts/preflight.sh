#!/usr/bin/env bash
set -euo pipefail

: "${SRC_HOST:?}" "${SRC_PORT:?}" "${SRC_PW:?}"
: "${DST_HOST:?}" "${DST_PORT:?}"

SRC_AUTH=(-a "$SRC_PW" --no-auth-warning)
DST_AUTH=()
[[ -n "${DST_PW:-}" ]] && DST_AUTH=(-a "$DST_PW" --no-auth-warning)

s() { redis-cli -h "$SRC_HOST" -p "$SRC_PORT" "${SRC_AUTH[@]}" "$@"; }
d() { redis-cli -h "$DST_HOST" -p "$DST_PORT" "${DST_AUTH[@]}" "$@"; }

echo "=== SOURCE ==="
s PING
s INFO server   | grep -E 'redis_version|redis_mode'
s INFO keyspace
s INFO memory   | grep -E 'used_memory_human|maxmemory_human'

echo "=== TARGET ==="
d PING
d INFO server | grep -E 'redis_version|redis_mode'
d INFO keyspace
d CONFIG GET maxmemory maxmemory-policy

echo "=== SOURCE LATENCY (from this pod) ==="
timeout 10 redis-cli -h "$SRC_HOST" -p "$SRC_PORT" "${SRC_AUTH[@]}" --latency || true
