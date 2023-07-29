FROM caddy:2-builder AS builder
ARG GOPROXY="https://mirrors.tencent.com/go/,direct"

RUN xcaddy build \
    --with github.com/caddy-dns/alidns \
    --with github.com/caddy-dns/dnspod \
    --with github.com/mholt/caddy-webdav \
    --with github.com/caddyserver/forwardproxy@caddy2=github.com/klzgrad/forwardproxy@naive

RUN caddy version
RUN caddy build-info
RUN caddy list-modules

FROM chenhw2/alpine:base
LABEL MAINTAINER="https://github.com/honwen"

COPY --from=builder /usr/bin/caddy /usr/bin/caddy
