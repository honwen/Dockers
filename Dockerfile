FROM chenhw2/alpine:base
LABEL MAINTAINER="https://github.com/honwen"

# /usr/bin/sing-box
RUN cd /tmp \
    && curl -skSLO $(curl -skSL 'https://api.github.com/repos/SagerNet/sing-box/releases/latest' | \
        jq -r '.assets[]|.browser_download_url' | grep 'linux-amd64.tar.gz$') \
    && tar -C /usr/bin --strip-components=1 -zxvf sing-box-*-linux-amd64.tar.gz \
    && sing-box version \
    && rm -rf /tmp/* /usr/bin/LICENSE \
    \
    && cd /opt \
    && curl -skSLO https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geoip.dat \
    && curl -skSLO https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geosite.dat \
    && sha256sum *.dat

# ENV ACME_DOMAIN="xray.example.org" \
#     USERS="uuid00;uuid01:email01;uuid02:email02" \
#     WS_PATH="/websocket" \
#     XRAY_BANCNIP=1

# ADD entrypoint.sh /

# CMD ["/entrypoint.sh"]

CMD ["sing-box", "run", "-c", "/config.json"]
