FROM chenhw2/alpine:base
LABEL MAINTAINER="https://github.com/honwen"
RUN apk add --update --no-cache jq && rm -rf /var/cache/apk/* /tmp/*

# /usr/bin/xray /etc/xray.d/geo*.dat
RUN cd /tmp \
    && curl -skSLO $(curl -skSL 'https://api.github.com/repos/XTLS/Xray-core/releases/latest' | sed -n '/url.*linux-64/{s/.*\(https:.*zip\).*/\1/p}') \
    && unzip Xray-linux-64.zip \
    && chmod a+x xray \
    && mv xray /usr/bin/ \
    && mkdir -p /etc/xray.d \
    && mv geo*.dat /etc/xray.d \
    && rm -rf /tmp/* \
    && xray version

ENV ACME_DOMAIN=xray.example.org \
    USERS="uuid00;uuid01:email01;uuid02:email02"

ADD entrypoint.sh /

CMD ["/entrypoint.sh"]
