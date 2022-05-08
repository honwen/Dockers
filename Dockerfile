FROM chenhw2/alpine:base
LABEL MAINTAINER="https://github.com/chenhw2"

RUN apk update \
    && apk add --no-cache dnsmasq \
    && rm -rf /var/cache/apk/*

RUN set -ex \
    && mkdir -p /etc/dnsmasq.d /data \
    && wget https://github.com/pymumu/smartdns/releases/download/Release36.1/smartdns-x86_64 -O /usr/bin/smartdns \
    && chmod a+x /usr/bin/smartdns \
    && wget https://raw.githubusercontent.com/honwen/openwrt-dnsmasq-extra/master/dnsmasq-extra/files/data/bogus.conf -O /etc/dnsmasq.d/bogus.conf \
    && wget https://raw.githubusercontent.com/honwen/openwrt-dnsmasq-extra/master/dnsmasq-extra/files/data/gfwlist.gz -O /data/gfwlist.gz

COPY etc/* /etc/

ADD entrypoint.sh /

ENV PORT=53

CMD ["/entrypoint.sh"]
