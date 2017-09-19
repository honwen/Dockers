FROM chenhw2/alpine:base
MAINTAINER CHENHW2 <https://github.com/chenhw2>

ARG KCP_VER=20170904
ARG KCP_URL=https://github.com/xtaci/kcptun/releases/download/v${KCP_VER}/kcptun-linux-amd64-${KCP_VER}.tar.gz

# /usr/bin/{server, client}
RUN mkdir -p /usr/bin/ \
    && cd /usr/bin/ \
    && wget -qO- ${KCP_URL} | tar xz \
    && mv client_* client \
    && mv server_* server

USER nobody

ENV ARGS=server

EXPOSE 12948/tcp 29900/udp

CMD ${ARGS}
