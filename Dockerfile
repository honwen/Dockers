#
# Dockerfile for simple-tun
#
FROM chenhw2/alpine:base
MAINTAINER CHENHW2 <https://github.com/chenhw2>

RUN apk add --update --no-cache iptables iproute2 net-tools \
    && rm -rf /var/cache/apk/*

COPY simple-tun /usr/bin

ENV SERVER=0.0.0.0 \
    SERVER_PORT=6060 \
    MODE=server

EXPOSE $SERVER_PORT/udp

CMD /usr/bin/simple-tun $MODE -s $SERVER:$SERVER_PORT --logtostderr -V 3
