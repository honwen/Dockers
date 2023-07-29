FROM caddy:2-builder AS builder
ARG GOPROXY="https://mirrors.tencent.com/go/,direct"

RUN xcaddy build \
    --with github.com/caddy-dns/alidns \
    --with github.com/caddy-dns/dnspod \
    --with github.com/mholt/caddy-webdav \
    --with github.com/caddyserver/replace-response \
    --with github.com/caddyserver/forwardproxy@caddy2=github.com/klzgrad/forwardproxy@naive

RUN caddy version
RUN caddy build-info
RUN caddy list-modules

FROM chenhw2/alpine:base
LABEL MAINTAINER="https://github.com/honwen"

COPY --from=builder /usr/bin/caddy /usr/bin/caddy

# FROM golang:1.19.10-bullseye AS builder
# ARG GOPROXY="https://mirrors.tencent.com/go/,direct"

# RUN go install github.com/caddyserver/xcaddy/cmd/xcaddy@latest

# RUN xcaddy build \
#     --with github.com/caddy-dns/alidns \
#     --with github.com/caddy-dns/dnspod \
#     --with github.com/mholt/caddy-webdav \
#     --with github.com/caddyserver/replace-response \
#     --with github.com/caddyserver/forwardproxy@caddy2=github.com/klzgrad/forwardproxy@naive

# RUN /go/caddy version
# RUN /go/caddy build-info
# RUN /go/caddy list-modules

# FROM chenhw2/alpine:base
# LABEL MAINTAINER="https://github.com/honwen"

# COPY --from=builder /go/caddy /usr/bin/caddy
