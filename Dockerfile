FROM chenhw2/alpine:base
LABEL MAINTAINER CHENHW2 <https://github.com/chenhw2>

# /usr/bin/v2ray-plugin
RUN mkdir -p /usr/bin/ \
    && cd /usr/bin/ \
    && curl -skSL $(curl -skSL "https://circleci.com/api/v1.1/project/github/shadowsocks/v2ray-plugin/latest/artifacts?branch=master" | sed -n '/url.*linux-amd64/{s/.*\(https:.*tar.gz\).*/\1/p}') | tar xz \
    && ln -sf v2ray-plugin_linux_amd64 v2ray-plugin

ENV ARGS='-h'

CMD v2ray-plugin ${ARGS}
