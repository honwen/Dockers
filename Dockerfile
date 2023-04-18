#
# Dockerfile for shadowsocks-rust, simple-obfs and v2ray-plugin/xray-plugin
#

FROM chenhw2/libev-build:musl as obfs

FROM chenhw2/alpine:base
LABEL MAINTAINER HONWEN <https://github.com/honwen>

COPY --from=obfs /usr/bin/obfs* /usr/bin/

RUN set -ex \
    && cd /usr/bin/ \
    && curl -skSL $(curl -skSL 'https://api.github.com/repos/shadowsocks/shadowsocks-rust/releases/latest' | sed -n '/url.*x86_64-unknown-linux-musl/{s/.*\(https:.*tar.xz\)[^\.].*/\1/p}') | tar xJv ssservice \
    && for it in ssserver ssmanager sslocal; do ln -sf ssservice $it; done \
    && ssserver -V \
    \
    && curl -skSL $(curl -skSL 'https://api.github.com/repos/teddysun/xray-plugin/releases/latest' | sed -n '/url.*linux-amd64/{s/.*\(https:.*tar.gz\).*/\1/p}' | sed 's+1.7.5+1.8.1+g') | tar xzv \
    && mv xray-plugin* xray-plugin \
    && xray-plugin -version \
    && ln -sf xray-plugin v2ray-plugin \
    \
    && curl -skSL $(curl -skSL 'https://api.github.com/repos/ihciah/shadow-tls/releases/latest' | sed -n '/url.*x86_64/{s/.*\(https:.*linux-musl\).*/\1/p}') -o shadow-tls \
    && chmod a+x shadow-tls \
    && shadow-tls -V \
    \
    && curl -skSL $(curl -skSL 'https://api.github.com/repos/xtaci/kcptun/releases/latest' | sed -n '/url.*linux-amd64/{s/.*\(https:.*tar.gz\)[^\.].*/\1/p}') | tar xz \
    && mv client_* kcpc \
    && kcpc -version \
    && mv server_* kcps \
    && kcps -version \
    && curl -skSLO https://github.com/honwen/openwrt-kcptun-plugin/raw/master/src/kcptun \
    && chmod a+x kcptun \
    && ln -sf kcptun kcptun-plugin

ENV ARGS='-c=/var/config.json'

CMD ssserver ${ARGS} ${NODELAY:+--tcp-no-delay} ${FASTOPEN:+--tcp-fast-open}
