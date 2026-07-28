FROM alpine:3.20

RUN apk add --no-cache redis curl openssl

EXPOSE 6379

USER redis

# protected-mode stays on its default (yes): with no requirepass set, redis refuses non-loopback
# connections rather than serving them unauthenticated. Pass --requirepass to allow remote clients.
CMD ["redis-server", "--bind", "0.0.0.0"]
