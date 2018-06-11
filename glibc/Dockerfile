#
# Dockerfile for shadowsocks-libev and simple-obfs
#
FROM ubuntu:16.04 as builder

ARG BUILD_GIST=https://gist.github.com/chenhw2/e57359378cd4699d19d10eb34f8069b4

RUN apt update && apt install build-essential automake autoconf libtool wget curl git clang -yqq
RUN set -ex && cd / && \
    git clone $BUILD_GIST --depth 1 /build && \
    sed '/_proxy/d' /build/*.sh > /build.sh && \
    chmod +x /build.sh && \
    /build.sh

FROM chenhw2/alpine:base
MAINTAINER CHENHW2 <https://github.com/chenhw2>

COPY --from=builder /dists/shadowsocks-libev/bin  /usr/bin
COPY --from=builder /dists/shadowsocksr-libev/bin /usr/bin
