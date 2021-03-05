#
# Dockerfile for shadowsocks-rust, simple-obfs and v2ray-plugin/xray-plugin
#

FROM chenhw2/libev-build:musl as obfs

FROM chenhw2/alpine:base
LABEL MAINTAINER HONWEN <https://github.com/honwen>

COPY --from=obfs /usr/bin/obfs* /usr/bin/

RUN set -ex \
    && cd /usr/bin/ \
    && curl -skSL $(curl -skSL 'https://api.github.com/repos/shadowsocks/shadowsocks-rust/releases/latest' | sed -n '/url.*x86_64-unknown-linux-musl/{s/.*\(https:.*tar.xz\)[^\.].*/\1/p}') | tar xJ \
    && ssserver -V \
    \
    && curl -skSL $(curl -skSL 'https://api.github.com/repos/teddysun/v2ray-plugin/releases/latest' | sed -n '/url.*linux-amd64/{s/.*\(https:.*tar.gz\).*/\1/p}') | tar xz \
    && mv v2ray-plugin* v2ray-plugin \
    && v2ray-plugin -version \
    \
    && curl -skSL $(curl -skSL 'https://api.github.com/repos/teddysun/xray-plugin/releases/latest' | sed -n '/url.*linux-amd64/{s/.*\(https:.*tar.gz\).*/\1/p}') | tar xz \
    && mv xray-plugin* xray-plugin \
    && xray-plugin -version

ENV ARGS='-c /var/config.json'

CMD ssserver ${ARGS}
