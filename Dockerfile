#
# Dockerfile for openvpn, shadowsocks-libev and simple-obfs
#
FROM chenhw2/go-ss2:latest as goss
FROM chenhw2/gost:latest as gost

FROM chenhw2/debian:base
LABEL MAINTAINER="https://github.com/chenhw2/Dockers"

RUN set -ex && cd / \
    && apt-get update \
    && apt-get -y dist-upgrade \
    && apt-get install -y --no-install-recommends iptables openvpn

COPY --from=goss /usr/bin/go-ss2 /usr/bin/
COPY --from=gost /usr/bin/gost /usr/bin/

ENV GOST_ARGS='http://ovpn:SS@:8499'
ENV GOSS_ARGS='ss://AEAD_CHACHA20_POLY1305:ssVPN@:8488'

EXPOSE 8488/tcp 8499/tcp

ADD entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
