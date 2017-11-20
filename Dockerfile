#
# Dockerfile for shadowsocks-libev and simple-obfs
#

FROM chenhw2/alpine:base
MAINTAINER CHENHW2 <https://github.com/chenhw2>

ARG SS_VER=3.1.1
ARG SS_URL=https://github.com/shadowsocks/shadowsocks-libev/releases/download/v$SS_VER/shadowsocks-libev-$SS_VER.tar.gz
ARG OBFS_VER=v0.0.5
ARG OBFS_URL=https://github.com/shadowsocks/simple-obfs/archive/$OBFS_VER.tar.gz

RUN set -ex && \
    apk add --update --no-cache --virtual \
                                .build-deps \
                                autoconf \
                                automake \
                                build-base \
                                curl \
                                libev-dev \
                                libtool \
                                linux-headers \
                                libsodium-dev \
                                mbedtls-dev \
                                openssl-dev \
                                pcre-dev \
                                tar \
                                c-ares-dev && \

    cd /tmp && \
    curl -sSL $SS_URL | tar xz --strip 1 && \
    ./configure --prefix=/usr --disable-documentation && \
    make install && \

    cd /tmp && \
    curl -sSL $OBFS_URL | tar xz --strip 1 && \
    ./autogen.sh && \
    ./configure --prefix=/usr --disable-documentation && \
    make install && \

    runDepsSS="$( \
        scanelf --needed --nobanner /usr/bin/ss-* \
            | awk '{ gsub(/,/, "\nso:", $2); print "so:" $2 }' \
            | xargs -r apk info --installed \
            | sort -u \
    )" && \
    runDepsOBFS="$( \
        scanelf --needed --nobanner /usr/bin/obfs-* \
            | awk '{ gsub(/,/, "\nso:", $2); print "so:" $2 }' \
            | xargs -r apk info --installed \
            | sort -u \
    )" && \

    apk add --no-cache --virtual .run-deps $( \
        echo $runDepsSS $runDepsOBFS \
            | tr ' ' '\n' \
            | sort -u \
    ) && \
    apk del --purge .build-deps && \
    rm -rf /tmp/*

# USER nobody

ENV SERVER_PORT=8388 \
    METHOD=chacha20-ietf-poly1305 \
    TIMEOUT=120
ENV PASSWORD=''
ENV ARGS='-a nobody'

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
 ${ARGS:--d 8.8.8.8}
