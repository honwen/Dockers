#
# Dockerfile for shadowsocks-libev and simple-obfs
#
FROM chenhw2/libev-build:latest as builder

FROM busybox:glibc
MAINTAINER CHENHW2 <https://github.com/chenhw2>

COPY --from=builder /usr/bin/ss-* /usr/bin/
COPY --from=builder /usr/bin/obfs-* /usr/bin/

ENV SERVER_PORT=8388 \
    METHOD=chacha20-ietf-poly1305 \
    TIMEOUT=120
ENV PASSWORD=''
ENV ARGS='-d 8.8.8.8'

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
