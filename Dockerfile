#
# Dockerfile for openvpn, shadowsocks-libev and simple-obfs
#
FROM chenhw2/libev-build:latest as builder

FROM chenhw2/debian:base
LABEL MAINTAINER="https://github.com/chenhw2/Dockers"

RUN set -ex && cd / \
    && apt-get update \
    && apt-get -y dist-upgrade \
    && apt-get install -y --no-install-recommends iptables openvpn

COPY --from=builder /usr/bin/*s-server /usr/bin/

ENV SERVER_PORT=8388 \
    METHOD=chacha20-ietf-poly1305 \
    TIMEOUT=120 \
    PASSWORD='' \
    ARGS='-d 8.8.8.8 --plugin obfs-server --plugin-opts obfs=http' \
    NIC='10.9.8.0'

EXPOSE $SERVER_PORT/tcp $SERVER_PORT/udp

ADD entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
