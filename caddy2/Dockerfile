FROM caddy:2-builder AS builder

ENV CGO_ENABLED=0
ARG GOPROXY="https://mirrors.aliyun.com/goproxy/,https://mirrors.tencent.com/go/,direct"
ARG CADDY_VERSION=v2.11.3

RUN xcaddy build \
    --with github.com/caddy-dns/alidns \
    --with github.com/caddy-dns/tencentcloud \
    --with github.com/mholt/caddy-webdav \
    --with github.com/caddyserver/replace-response \
    --with github.com/caddyserver/forwardproxy=github.com/klzgrad/forwardproxy@naive

RUN caddy version
RUN caddy build-info
RUN caddy list-modules

FROM chenhw2/alpine:base
LABEL MAINTAINER="https://github.com/honwen"

COPY --from=builder /usr/bin/caddy /usr/bin/caddy
