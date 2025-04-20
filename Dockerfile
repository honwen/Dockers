FROM chenhw2/alpine:base
LABEL MAINTAINER="https://github.com/honwen"

ARG GHPROXY="https://"
# ARG GHPROXY="https://files.m.daocloud.io/"
# ARG GHPROXY="https://ghproxy.cn/https://"
# ARG GHPROXY="https://cdn.wget.la/https://"

RUN set -ex \
    # && sed 's/dl-cdn.alpinelinux.org/mirrors.bfsu.edu.cn/g' -i /etc/apk/repositories \
    && apk add --no-cache dnsmasq uuidgen tini \
    && curl -skSL ${GHPROXY}github.com/atkrad/wait4x/releases/download/v3.2.0/wait4x-linux-amd64.tar.gz | tar -C /usr/bin -zx wait4x \
    # && curl -skSL ${GHPROXY}github.com/mr-karan/doggo/releases/download/v1.0.5/doggo_1.0.5_Linux_x86_64.tar.gz | tar -C /usr/bin --strip-components 1 -zx doggo_1.0.5_Linux_x86_64/doggo \
    # && wget ${GHPROXY}github.com/pymumu/smartdns/releases/latest/download/smartdns-x86_64 -qO /usr/bin/smartdns \
    && wget ${GHPROXY}github.com/PikuZheng/smartdns/releases/download/1.2025.v46.1.28/smartdns-x86_64-edns -qO /usr/bin/smartdns \
    # && wget ${GHPROXY}github.com/PikuZheng/smartdns/releases/latest/download/smartdns-x86_64-edns -qO /usr/bin/smartdns \
    && wget ${GHPROXY}github.com/honwen/dcompass/releases/download/build-20220316_1022/dcompass-x86_64-unknown-linux-musl -qO /usr/bin/dcompass \
    && chmod a+x /usr/bin/smartdns /usr/bin/dcompass \
    # && doggo -h \
    && wait4x version \
    && smartdns -v \
    && dcompass -V \
    && rm -rf /var/cache/apk/*

RUN set -ex \
    && mkdir -p /etc/dnsmasq.d /data \
    && curl -sSL ${GHPROXY}raw.githubusercontent.com/honwen/openwrt-dnsmasq-extra/master/dnsmasq-extra/Makefile | sed -n 's+^PKG_VERSION:=++p' | tee /data/VERSION \
    && wget ${GHPROXY}raw.githubusercontent.com/honwen/openwrt-dnsmasq-extra/master/dnsmasq-extra/files/data/bogus.conf -qO /etc/dnsmasq.d/bogus.conf \
    && wget ${GHPROXY}raw.githubusercontent.com/honwen/openwrt-dnsmasq-extra/master/dnsmasq-extra/files/data/chnroute.txt -qO /data/chnroute.txt \
    && wget ${GHPROXY}raw.githubusercontent.com/honwen/openwrt-dnsmasq-extra/master/dnsmasq-extra/files/data/direct.gz -qO /data/direct.gz \
    && wget ${GHPROXY}raw.githubusercontent.com/honwen/openwrt-dnsmasq-extra/master/dnsmasq-extra/files/data/gfwlist.lite.gz -qO /data/gfwlist.gz \
    && wget ${GHPROXY}raw.githubusercontent.com/honwen/openwrt-dnsmasq-extra/master/dnsmasq-extra/files/data/tldn.gz -qO /data/tldn.gz

COPY root /

ENV PORT=53

HEALTHCHECK --start-period=15s --timeout=3s \
    CMD /healthcheck.sh

CMD ["/sbin/tini", "--", "/entrypoint.sh"]
