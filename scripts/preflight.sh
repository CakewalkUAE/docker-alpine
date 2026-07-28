#!/usr/bin/env bash
set -euo pipefail

: "${SRC_HOST:?}" "${SRC_PORT:?}" "${SRC_PW:?}"
: "${DST_HOST:?}" "${DST_PORT:?}" "${DST_PW:?}"

s() { REDISCLI_AUTH="$SRC_PW" redis-cli -h "$SRC_HOST" -p "$SRC_PORT" --no-auth-warning "$@"; }
d() { REDISCLI_AUTH="$DST_PW" redis-cli -h "$DST_HOST" -p "$DST_PORT" --no-auth-warning "$@"; }

echo "=== SOURCE ==="
s PING
s INFO server   | grep -E 'redis_version|redis_mode'
s INFO keyspace
s INFO memory   | grep -E 'used_memory_human|maxmemory_human'
s CONFIG GET maxmemory-policy 2>/dev/null || echo "(CONFIG restricted on Essentials)"

echo "=== TARGET ==="
d PING
d INFO server | grep -E 'redis_version|redis_mode'
d INFO keyspace
d CONFIG GET maxmemory maxmemory-policy

echo "=== SOURCE LATENCY (from this pod) ==="
REDISCLI_AUTH="$SRC_PW" timeout 10 redis-cli -h "$SRC_HOST" -p "$SRC_PORT" --no-auth-warning --latency || true
