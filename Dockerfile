#
# Dockerfile for shadowsocks-libev and simple-obfs
#

FROM chenhw2/alpine:base
MAINTAINER CHENHW2 <https://github.com/chenhw2>

ARG SS_VER=3.0.8
ARG SS_URL=https://github.com/shadowsocks/shadowsocks-libev/releases/download/v$SS_VER/shadowsocks-libev-$SS_VER.tar.gz
ARG OBFS_VER=0.0.3
ARG OBFS_URL=https://github.com/shadowsocks/simple-obfs/archive/v$OBFS_VER.tar.gz

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
                                udns-dev && \

    cd /tmp && \
    curl -sSL $SS_URL | tar xz --strip 1 && \
    ./configure --prefix=/usr --disable-documentation && \
    make install && \
    cd .. && \

    runDeps="$( \
        scanelf --needed --nobanner /usr/bin/ss-* \
            | awk '{ gsub(/,/, "\nso:", $2); print "so:" $2 }' \
            | xargs -r apk info --installed \
            | sort -u \
    )" && \
    apk add --no-cache --virtual .run-deps $runDeps && \

    cd /tmp && \
    curl -sSL $OBFS_URL | tar xz --strip 1 && \
    ./autogen.sh && \
    ./configure --prefix=/usr --disable-documentation && \
    make install && \
    cd .. && \

    runDeps="$( \
        scanelf --needed --nobanner /usr/bin/obfs-* \
            | awk '{ gsub(/,/, "\nso:", $2); print "so:" $2 }' \
            | xargs -r apk info --installed \
            | sort -u \
    )" && \
    apk add --no-cache --virtual .run-deps $runDeps && \

    apk del --purge \
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
                    udns-dev && \
    rm -rf /tmp/* /var/cache/apk/*

USER nobody

ENV SERVER_PORT=8388 \
    METHOD=chacha20-ietf-poly1305 \
    TIMEOUT=120
ENV PASSWORD=''
ENV ARGS=''

EXPOSE $SERVER_PORT/tcp $SERVER_PORT/udp

CMD ss-server \
 -s 0.0.0.0 \
 -p $SERVER_PORT \
 -k ${PASSWORD:-$(hostname)} \
 -m $METHOD \
 -t $TIMEOUT \
 --fast-open -u \
 ${ARGS:--d 8.8.8.8}
