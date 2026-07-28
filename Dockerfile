FROM alpine:3.20

RUN apk add --no-cache redis curl openssl

EXPOSE 6379

# bind 0.0.0.0 + protected-mode off: container has no loopback-only clients, network access is controlled at the Fly/deploy layer
CMD ["redis-server", "--bind", "0.0.0.0", "--protected-mode", "no"]
