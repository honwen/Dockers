FROM chenhw2/alpine:base
LABEL MAINTAINER="https://github.com/honwen"
RUN apk add --update --no-cache jq && rm -rf /var/cache /tmp

# /usr/bin/xray /usr/share/xray/geo*.dat
RUN mkdir -p /usr/share/xray /tmp /var/cache/apk \
    && cd /tmp \
    && curl -skSLO $(curl -skSL 'https://api.github.com/repos/XTLS/Xray-core/releases/latest' | sed -n '/url.*linux-64/{s/.*\(https:.*zip\).*/\1/p}') \
    && unzip Xray-linux-64.zip \
    && chmod a+x xray \
    && mv xray /usr/bin/ \
    && mv geo*.dat /usr/share/xray \
    && xray version \
    && rm -rf /tmp/*

ENV ACME_DOMAIN="xray.example.org" \
    USERS="uuid00;uuid01:email01;uuid02:email02" \
    WS_PATH="/websocket"

ADD entrypoint.sh /

CMD ["/entrypoint.sh"]
