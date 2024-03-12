FROM chenhw2/alpine:base
LABEL MAINTAINER="https://github.com/honwen"

ARG GHPROXY="https://mirror.ghproxy.com/"

RUN set -ex \
    # && sed 's/dl-cdn.alpinelinux.org/mirrors.bfsu.edu.cn/g' -i /etc/apk/repositories \
    && apk add --no-cache dnsmasq \
    && curl -skSL ${GHPROXY}https://github.com/mr-karan/doggo/releases/download/v0.5.6/doggo_0.5.6_linux_amd64.tar.gz | tar -C /usr/bin -zx doggo \
    # && wget ${GHPROXY}https://github.com/pymumu/smartdns/releases/latest/download/smartdns-x86_64 -qO /usr/bin/smartdns \
    && wget ${GHPROXY}https://github.com/PikuZheng/smartdns/releases/download/1.2024.v45.0.10/smartdns-x86_64-edns -qO /usr/bin/smartdns \
    # && wget ${GHPROXY}https://github.com/PikuZheng/smartdns/releases/latest/download/smartdns-x86_64-edns -qO /usr/bin/smartdns \
    && wget ${GHPROXY}https://github.com/honwen/dcompass/releases/download/build-20220316_1022/dcompass-x86_64-unknown-linux-musl -qO /usr/bin/dcompass \
    && chmod a+x /usr/bin/smartdns /usr/bin/dcompass \
    && doggo -h \
    && smartdns -v \
    && dcompass -V \
    && rm -rf /var/cache/apk/*

RUN set -ex \
    && mkdir -p /etc/dnsmasq.d /data \
    && curl -sSL ${GHPROXY}https://raw.githubusercontent.com/honwen/openwrt-dnsmasq-extra/master/dnsmasq-extra/Makefile | sed -n 's+^PKG_VERSION:=++p' | tee /data/VERSION \
    && wget ${GHPROXY}https://raw.githubusercontent.com/honwen/openwrt-dnsmasq-extra/master/dnsmasq-extra/files/data/bogus.conf -qO /etc/dnsmasq.d/bogus.conf \
    && wget ${GHPROXY}https://raw.githubusercontent.com/honwen/openwrt-dnsmasq-extra/master/dnsmasq-extra/files/data/chnroute.txt -qO /data/chnroute.txt \
    && wget ${GHPROXY}https://raw.githubusercontent.com/honwen/openwrt-dnsmasq-extra/master/dnsmasq-extra/files/data/direct.gz -qO /data/direct.gz \
    && wget ${GHPROXY}https://raw.githubusercontent.com/honwen/openwrt-dnsmasq-extra/master/dnsmasq-extra/files/data/gfwlist.lite.gz -qO /data/gfwlist.gz \
    && wget ${GHPROXY}https://raw.githubusercontent.com/honwen/openwrt-dnsmasq-extra/master/dnsmasq-extra/files/data/tldn.gz -qO /data/tldn.gz

COPY root /

ENV PORT=53

HEALTHCHECK --start-period=15s --timeout=3s \
    CMD /healthcheck.sh

CMD ["/entrypoint.sh"]
