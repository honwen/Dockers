FROM chenhw2/alpine:base
LABEL MAINTAINER="https://github.com/chenhw2"

RUN apk update \
    && apk add --no-cache dnsmasq \
    && curl -skSL https://github.com/mr-karan/doggo/releases/download/v0.5.4/doggo_0.5.4_linux_amd64.tar.gz | tar -C /usr/bin -zx doggo \
    && wget https://github.com/pymumu/smartdns/releases/download/Release38/smartdns-x86_64 -qO /usr/bin/smartdns \
    && wget https://github.com/honwen/dcompass/releases/download/build-20220316_1022/dcompass-x86_64-unknown-linux-musl -qO /usr/bin/dcompass \
    && chmod a+x /usr/bin/smartdns /usr/bin/dcompass \
    && doggo -h \
    && smartdns -v \
    && dcompass -V \
    && rm -rf /var/cache/apk/*

RUN set -ex \
    && mkdir -p /etc/dnsmasq.d /data \
    && wget https://raw.githubusercontent.com/honwen/openwrt-dnsmasq-extra/master/dnsmasq-extra/files/data/bogus.conf -qO /etc/dnsmasq.d/bogus.conf \
    && wget https://raw.githubusercontent.com/honwen/openwrt-dnsmasq-extra/master/dnsmasq-extra/files/data/chnroute.txt -qO /data/chnroute.txt \
    && wget https://raw.githubusercontent.com/honwen/openwrt-dnsmasq-extra/master/dnsmasq-extra/files/data/direct.gz -qO /data/direct.gz \
    && wget https://raw.githubusercontent.com/honwen/openwrt-dnsmasq-extra/master/dnsmasq-extra/files/data/gfwlist.lite.gz -qO /data/gfwlist.gz \
    && wget https://raw.githubusercontent.com/honwen/openwrt-dnsmasq-extra/master/dnsmasq-extra/files/data/tldn.gz -qO /data/tldn.gz

COPY root /

ENV PORT=53

HEALTHCHECK --start-period=15s --timeout=3s \
    CMD /healthcheck.sh

CMD ["/entrypoint.sh"]
