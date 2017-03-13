FROM alpine:edge
MAINTAINER CHENHW2 <https://github.com/chenhw2>

RUN apk update \
    && apk add --no-cache dnsmasq \
    && rm -rf /var/cache/apk/*

RUN echo 'conf-dir=/etc/dnsmasq.d/,*.conf' > /etc/dnsmasq.conf
RUN echo "user=root" >> /etc/dnsmasq.conf
# slove "dnsmasq: setting capabilities failed: Operation not permitted"
# refs:https://github.com/nicolasff/docker-cassandra/issues/8

ENTRYPOINT ["dnsmasq","-k","--port=5353"]
