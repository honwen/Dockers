FROM chenhw2/udp-speeder as us
FROM chenhw2/ss-obfs as plugin
FROM chenhw2/gost3 as gost

FROM chenhw2/debian:base
LABEL MAINTAINER="https://github.com/honwen/Dockers"

RUN set -ex && cd / \
    && apt update -y --allow-releaseinfo-change \
    && apt install -y --no-install-recommends iptables openvpn \
    && rm -rf /tmp/* /var/cache/apt/* /var/log/*

COPY --from=gost /usr/bin/gost /usr/bin/
COPY --from=us /usr/bin/udp-speeder /usr/bin/
COPY --from=plugin /usr/bin/xray-plugin /usr/bin/
COPY --from=plugin /usr/bin/gost-plugin /usr/bin/
COPY --from=plugin /usr/bin/kcpc /usr/bin/
COPY --from=plugin /usr/bin/kcps /usr/bin/
COPY --from=plugin /usr/bin/kcptun /usr/bin/
COPY --from=plugin /usr/bin/shadow-tls /usr/bin/

ENV WS_PATH='/websocket' \
    GOST_ARGS='' \
    MODE=''

EXPOSE 1984/tcp 8488/tcp 8488/udp 8499/udp

ADD entrypoint.sh /entrypoint.sh

CMD ["/entrypoint.sh"]
