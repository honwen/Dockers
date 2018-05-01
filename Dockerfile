#
# Dockerfile for openvpn, shadowsocks-libev and simple-obfs
#
FROM chenhw2/ss-aio:latest as ss

FROM chenhw2/debian:base
LABEL MAINTAINER="https://github.com/chenhw2/Dockers"

RUN set -ex && cd / \
    && apt-get update \
    && apt-get -y dist-upgrade \
    && apt-get install -y --no-install-recommends iptables openvpn

COPY --from=ss /usr/bin/ss-aio /usr/bin/

ENV SS_ARGS='AEAD_CHACHA20_POLY1305:ssVPN'

EXPOSE 8488/tcp

ADD entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
