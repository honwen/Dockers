#
# Dockerfile for openvpn, shadowsocks-libev and simple-obfs
#
FROM chenhw2/ss-aio:latest as ss
FROM chenhw2/v2ray-plugin:latest as plugin
FROM chenhw2/udp-speeder:latest as us

FROM chenhw2/debian:base
LABEL MAINTAINER="https://github.com/chenhw2/Dockers"

RUN set -ex && cd / \
    && apt-get update \
    && apt-get -y dist-upgrade \
    && apt-get install -y --no-install-recommends iptables openvpn

COPY --from=ss /usr/bin/ss-aio /usr/bin/
COPY --from=us /usr/bin/udp-speeder /usr/bin/
COPY --from=plugin /usr/bin/v2ray-plugin /usr/bin/

ENV SS_ARGS='AEAD_CHACHA20_POLY1305:ssVPN' \
    WS_PATH='/websocket' \
    MODE=''

EXPOSE 1984/tcp 8488/tcp 8488/udp 8499/udp

ADD entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
