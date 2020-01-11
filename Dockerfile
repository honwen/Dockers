#
# Dockerfile for shadowsocks-libev, simple-obfs and v2ray-plugin
#

FROM chenhw2/libev-build:musl as builder
FROM chenhw2/v2ray-plugin:latest as plugin

FROM chenhw2/alpine:base
LABEL MAINTAINER CHENHW2 <https://github.com/chenhw2>

COPY --from=builder /usr/bin/ss-* /usr/bin/
COPY --from=builder /usr/bin/obfs-* /usr/bin/
COPY --from=plugin /usr/bin/v2ray-plugin /usr/bin/

RUN set -ex \
    && ls /usr/bin/ss-* | xargs -n1 setcap cap_net_bind_service+ep \
    && ls /usr/bin/obfs-* | xargs -n1 setcap cap_net_bind_service+ep \
    && ls /usr/bin/v2ray-* | xargs -n1 setcap cap_net_bind_service+ep

ENV SERVER_PORT=8388 \
    METHOD=chacha20-ietf-poly1305 \
    TIMEOUT=120 \
    PASSWORD='' \
    ARGS='-d 8.8.8.8'

EXPOSE $SERVER_PORT/tcp $SERVER_PORT/udp

CMD ss-server \
 -s 0.0.0.0 \
 -p $SERVER_PORT \
 -k ${PASSWORD:-$(hostname)} \
 -m $METHOD \
 -t $TIMEOUT \
 --fast-open \
 --no-delay \
 -u \
 ${ARGS}
