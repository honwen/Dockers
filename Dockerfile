FROM chenhw2/alpine:base
LABEL MAINTAINER="https://github.com/honwen"
RUN apk add --update --no-cache jq && rm -rf /var/cache /tmp/*

# /usr/bin/hysteria
RUN cd /tmp \
    && curl -skSLO $(curl -skSL 'https://api.github.com/repos/honwen/hysteria/releases/latest' \
    | jq -r '.assets[]|.browser_download_url' | grep 'linux-amd64') \
    && chmod a+x hysteria-* \
    && mv hysteria-* /usr/bin/hysteria \
    && hysteria version

ENV MODE="server" \
    ACME_DOMAIN="hysteria.example.org" \
    OBFS_KEY="BlueberryHysteria" \
    DOWN_MBPS="10" \
    UP_MBPS="10"

ADD entrypoint.sh /

CMD ["/entrypoint.sh"]
