FROM chenhw2/udp-speeder as us
FROM chenhw2/ss-obfs as plugin
FROM chenhw2/gost3 as gost

FROM chenhw2/debian:base as temp

COPY --from=gost /usr/bin/gost /usr/bin/
COPY --from=us /usr/bin/udp-speeder /usr/bin/
COPY --from=plugin /usr/bin/xray-plugin /usr/bin/kcpc /usr/bin/kcps /usr/bin/kcptun /usr/bin/kcptube /usr/bin/kcptube-plugin /usr/bin/shadow-tls /usr/bin/
ADD entrypoint.sh /usr/bin/

FROM chenhw2/debian:base
LABEL MAINTAINER="https://github.com/honwen/Dockers"

RUN set -ex && cd / \
    && apt update -y --allow-releaseinfo-change \
    && apt install -y --no-install-recommends iptables openvpn \
    && rm -rf /tmp/* /var/cache/apt/* /var/log/*

COPY --from=temp /usr/bin/entrypoint.sh /usr/bin/gost /usr/bin/udp-speeder \
    /usr/bin/xray-plugin /usr/bin/shadow-tls \
    /usr/bin/kcpc /usr/bin/kcps /usr/bin/kcptun /usr/bin/kcptube /usr/bin/kcptube-plugin \
    /usr/bin/

ENV WS_PATH='/websocket' \
    GOST_ARGS='' \
    MODE=''

EXPOSE 1984/tcp 8488/tcp 8488/udp 8499/udp

CMD ["/usr/bin/entrypoint.sh"]
