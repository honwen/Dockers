FROM chenhw2/alpine:base
LABEL MAINTAINER CHENHW2 <https://github.com/chenhw2>

# /usr/bin/xray-plugin
RUN mkdir -p /usr/bin/ \
    && cd /usr/bin/ \
    && curl -skSL $(curl -skSL 'https://api.github.com/repos/teddysun/xray-plugin/releases/latest' | sed -n '/url.*linux-amd64/{s/.*\(https:.*tar.gz\).*/\1/p}') | tar xz \
    && ln -sf xray-plugin_linux_amd64 xray-plugin \
    && xray-plugin -version

ENV ARGS='-h'

CMD v2ray-plugin ${ARGS}
