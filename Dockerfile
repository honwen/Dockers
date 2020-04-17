FROM chenhw2/v2ray-plugin:latest as plugin
FROM chenhw2/udp-speeder:latest as us
FROM golang:buster as gost
ENV CGO_ENABLED=0
RUN set -ex \
    && git clone https://github.com/ginuerzh/gost.git \
    && cd gost/cmd/gost \
    && go build \
    && mv gost /usr/bin/

FROM chenhw2/debian:base
LABEL MAINTAINER="https://github.com/chenhw2/Dockers"

RUN set -ex && cd / \
    && apt-get update \
    && apt-get -y dist-upgrade \
    && apt-get install -y --no-install-recommends iptables openvpn

COPY --from=gost /usr/bin/gost /usr/bin/
COPY --from=us /usr/bin/udp-speeder /usr/bin/
COPY --from=plugin /usr/bin/v2ray-plugin /usr/bin/

ENV WS_PATH='/websocket' \
    GOST_ARGS='' \
    MODE=''

EXPOSE 1984/tcp 8488/tcp 8488/udp 8499/udp

ADD entrypoint.sh /entrypoint.sh

CMD ["/entrypoint.sh"]
