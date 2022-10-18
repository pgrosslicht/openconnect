FROM alpine:3.16

# BUILD_DATE="$(date -u +'%Y-%m-%dT%H:%M:%SZ')"
# COMMIT_SHA="$(git rev-parse HEAD 2>/dev/null || echo 'null')"
ARG BUILD_DATE
ARG COMMIT_SHA

# https://github.com/opencontainers/image-spec/blob/master/spec.md
LABEL org.opencontainers.image.title='openconnect' \
      org.opencontainers.image.created="${BUILD_DATE}" \
      org.opencontainers.image.description='AnyConnect-compatible client to route host traffic' \
      org.opencontainers.image.documentation='https://github.com/pgrosslicht/openconnect/blob/master/README.md' \
      org.opencontainers.image.version='1.0' \
      org.opencontainers.image.source='https://github.com/pgrosslicht/openconnect' \
      org.opencontainers.image.revision="${COMMIT_SHA}"

RUN apk add --no-cache openconnect \
    # add vpn-slice with dependencies (dig) https://github.com/dlenski/vpn-slice
    && apk add --no-cache python3 bind-tools py3-pip \
    && pip3 install "vpn-slice[dnspython,setproctitle]"

COPY ./entrypoint.sh /vpn/entrypoint.sh
WORKDIR /vpn

HEALTHCHECK --start-period=15s --retries=1 \
  CMD pgrep openconnect || exit 1

ENTRYPOINT ["/vpn/entrypoint.sh"]
