FROM dreamacro/clash as clash
FROM ochinchina/supervisord as supervisord
FROM golang:alpine as builder
RUN apk add --update git
RUN CGO_ENABLED=0 go get -u -v github.com/honwen/shadowsocks-helper github.com/nadoo/glider github.com/AdguardTeam/dnsproxy

FROM chenhw2/alpine:base
LABEL MAINTAINER="https://github.com/chenhw2"

WORKDIR /subscribe

# /usr/bin/{clash, glider, supervisord, shadowsocks-helper}
COPY --from=clash /clash /usr/bin/
COPY --from=supervisord /usr/local/bin/supervisord /usr/bin/
COPY --from=builder /go/bin/* /usr/bin/

RUN set -ex \
    && curl -skSL https://github.com/Hackl0us/SS-Rule-Snippet/raw/master/LAZY_RULES/clash.yaml > Hackl0us_clash.yaml \
    && curl -skSL http://geolite.maxmind.com/download/geoip/database/GeoLite2-Country.tar.gz | tar zxv \
    && mv */GeoLite*.mmdb Country.mmdb \
    && rm -rf GeoLite*

ENV URL=https://subscribe.entrypoint\
    DNS_SAFE="sdns://AgcAAAAAAAAADTQ3LjEwMS4xMzYuMzcADmVkbnMuMjMzcHkuY29tCi9kbnMtcXVlcnk;tls://8.8.8.8:853;tls://8.8.4.4:853;https://dns.adguard.com/dns-query" \
    DNS_FAILSAFE="119.29.107.85:9090;47.101.136.37:9090;114.115.240.175:9090"

EXPOSE 8080/tcp 1080/tcp

ADD entrypoint.sh /

CMD /entrypoint.sh
