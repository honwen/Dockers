FROM chenhw2/alpine:base
LABEL MAINTAINER CHENHW2 <https://github.com/chenhw2>

ARG FRP_VER=0.17.0
ARG FRP_URL=https://github.com/fatedier/frp/releases/download/v${FRP_VER}/frp_${FRP_VER}_linux_amd64.tar.gz

# /usr/bin/{frps, frpc}
# /frp/{frps, frpc, frps_full, frpc_full}.ini
RUN mkdir -p /frp \
    && cd /frp\
    && wget -qO- ${FRP_URL} | tar xz \
    && mv frp_*/frpc /usr/bin/ \
    && mv frp_*/frps /usr/bin/ \
    && mv frp_*/*.ini ./ \
    && rm frp_* -rf

VOLUME /frp

ENV ARGS=frps

CMD ${ARGS} -c /frp/${ARGS}.ini
