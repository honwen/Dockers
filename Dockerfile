FROM chenhw2/alpine:base
LABEL MAINTAINER CHENHW2 <https://github.com/chenhw2>

ARG VER=20190114
ARG URL=https://github.com/shadowsocks/v2ray-plugin/releases/download/v${VER}/v2ray-plugin-linux-amd64-${VER}.tar.gz

# /usr/bin/v2ray-plugin
RUN mkdir -p /usr/bin/ \
    && cd /usr/bin/ \
    && wget -qO- ${URL} | tar xz \
    && ln -sf v2ray-plugin_linux_amd64 v2ray-plugin

ENV ARGS='-h'

CMD v2ray-plugin ${ARGS}
