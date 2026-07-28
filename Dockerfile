FROM alpine:3.20

WORKDIR /app

# Install dependencies: redis (redis-cli, redis-check-rdb/aof, redis-benchmark), curl, openssl (for TLS-enabled redis endpoints)
RUN apk add --no-cache \
        redis \
        curl \
        openssl

COPY . .

ENTRYPOINT ["/bin/sh"]
