FROM chenhw2/v2ray-plugin:latest as plugin
FROM chenhw2/udp-speeder:latest as us
# FROM chenhw2/gost:latest as gost
FROM golang:buster as gost
RUN set -ex \
    && git clone https://github.com/ginuerzh/gost.git \
    && cd gost/cmd/gost \
    && CGO_ENABLED=0 go build \
    && mv gost /usr/bin/

FROM chenhw2/debian:base
LABEL MAINTAINER="https://github.com/chenhw2/Dockers"

RUN set -ex && cd / \
    && apt update \
    && apt install -y --no-install-recommends iptables openvpn \
    && rm -rf /tmp/* /var/cache/apt/* /var/log/*

COPY --from=gost /usr/bin/gost /usr/bin/
COPY --from=us /usr/bin/udp-speeder /usr/bin/
COPY --from=plugin /usr/bin/v2ray-plugin /usr/bin/

ENV WS_PATH='/websocket' \
    GOST_ARGS='' \
    MODE=''

EXPOSE 1984/tcp 8488/tcp 8488/udp 8499/udp

ADD entrypoint.sh /entrypoint.sh

CMD ["/entrypoint.sh"]
