FROM chenhw2/alpine:base
LABEL MAINTAINER HONWEN <https://github.com/honwen>

ARG VER=0.51.3
ARG URL=https://github.com/fatedier/frp/releases/download/v${VER}/frp_${VER}_linux_amd64.tar.gz

# /usr/bin/{frps, frpc}
# /frp/{frps, frpc, frps_full, frpc_full}.ini
RUN mkdir -p /frp \
    && cd /frp\
    && wget -qO- ${URL} | tar xz \
    && mv frp_*/frpc /usr/bin/ \
    && mv frp_*/frps /usr/bin/ \
    && mv frp_*/*.ini ./ \
    && rm frp_* -rf

VOLUME /frp

ENV ARGS=frps

CMD /usr/bin/${ARGS} -c /frp/${ARGS}.ini
