FROM chenhw2/alpine:base
MAINTAINER CHENHW2 <https://github.com/chenhw2>

RUN apk add --update --no-cache python libsodium supervisor \
    && rm -rf /var/cache/apk/*

ENV RUN_ROOT=/ssr
ARG SSR_VER=b31885113aa95e0ba96cf9fa6a5b91d6c359364c
ARG SSR_URL=https://github.com/shadowsocksrr/shadowsocksr/archive/${SSR_VER}.tar.gz
ARG KCP_VER=20171201
ARG KCP_URL=https://github.com/xtaci/kcptun/releases/download/v${KCP_VER}/kcptun-linux-amd64-${KCP_VER}.tar.gz

# /ssr/shadowsocks/server.py
RUN mkdir -p ${RUN_ROOT} \
    && cd ${RUN_ROOT} \
    && wget -qO- ${SSR_URL} | tar xz \
    && mv shadowsocksr-*/shadowsocks shadowsocks \
    && rm -rf shadowsocksr-* *.zip

# /ssr/kcptun/server
RUN mkdir -p ${RUN_ROOT}/kcptun \
    && cd ${RUN_ROOT}/kcptun \
    && wget -qO- ${KCP_URL} | tar xz \
    && rm client_* \
    && mv server_* server

ENV SSR=ssr://origin:chacha20-ietf:http_post_compatible:12345678 \
    SSR_REDIRECT='["www.alibabagroup.com:80","www.alibabacloud.com:80","www.alibaba.co.jp:80"]' \
    SSR_OBFS_PARAM=alibabagroup.com \
    SSR_PROTOCOL_PARAM=''

ENV KCP=kcp://fast2:aes: \
    KCP_EXTRA_ARGS=''

EXPOSE 8388/tcp 8388/udp 18388/udp

ADD entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
