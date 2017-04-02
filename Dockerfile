FROM alpine:edge
MAINTAINER CHENHW2 <https://github.com/chenhw2>

RUN export BUILD_DEPS="gcc git make libc-dev" \
    && apk add --update $BUILD_DEPS \
    && git clone https://github.com/aa65535/hev-dns-forwarder /tmp/dnsforwarder \
    && cd /tmp/dnsforwarder \
    && make \
    && mv /tmp/dnsforwarder/src/hev-dns-forwarder /usr/local/bin/dnsforwarder \
    && apk del --purge $BUILD_DEPS \
    && rm -rf /tmp/* /var/cache/apk/*

ENTRYPOINT ["/usr/local/bin/dnsforwarder"]
CMD ["-s","208.67.222.222#443"]
