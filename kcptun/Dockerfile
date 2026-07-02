FROM chenhw2/alpine:base
LABEL MAINTAINER CHENHW2 <https://github.com/chenhw2>

# /usr/bin/{kcps, kcpc}
RUN cd /usr/bin/ \
    && curl -skSL $(curl -skSL 'https://api.github.com/repos/xtaci/kcptun/releases/latest' | sed -n '/url.*linux-amd64/{s/.*\(https:.*tar.gz\)[^\.].*/\1/p}') | tar xz \
    && mv client_* kcpc \
    && kcpc -version \
    && mv server_* kcps \
    && kcps -version

ENV ARGS='s --crypt=none'

EXPOSE 12948/tcp 29900/udp

CMD kcp${ARGS}
