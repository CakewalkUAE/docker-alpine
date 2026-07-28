FROM alpine:3.20

ARG RIOT_VERSION=4.2.4
ARG TARGETARCH

RUN apk add --no-cache \
      redis \
      curl \
      openssl \
      ca-certificates \
      bash \
      unzip \
      libstdc++ \
      tzdata \
 && update-ca-certificates

RUN set -eux; \
    case "${TARGETARCH}" in \
      amd64) RIOT_ARCH=x86_64 ;; \
      arm64) RIOT_ARCH=aarch64 ;; \
      *) echo "unsupported TARGETARCH=${TARGETARCH}" >&2; exit 1 ;; \
    esac; \
    curl -fsSL -o /tmp/riot.zip \
      "https://github.com/redis/riot/releases/download/v${RIOT_VERSION}/riot-standalone-${RIOT_VERSION}-linux_musl-${RIOT_ARCH}.zip"; \
    unzip -q /tmp/riot.zip -d /opt; \
    mv "/opt/riot-standalone-${RIOT_VERSION}-linux_musl-${RIOT_ARCH}" /opt/riot; \
    rm /tmp/riot.zip; \
    ln -s /opt/riot/bin/riot /usr/local/bin/riot

ENV PATH="/opt/riot/bin:${PATH}"

RUN riot --version && redis-cli -v

COPY scripts/ /opt/scripts/
RUN chmod +x /opt/scripts/*.sh

WORKDIR /work
CMD ["sleep", "infinity"]
