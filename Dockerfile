FROM chenhw2/alpine:base
LABEL MAINTAINER="https://github.com/honwen"

# /usr/bin/xray
# /opt/share/xray/geo*.dat
RUN mkdir -p /opt/share/xray/ /tmp /var/cache/apk \
    && cd /tmp \
    && curl -skSLO $(curl -skSL 'https://api.github.com/repos/XTLS/Xray-core/releases/latest' \
    # | jq -r '.assets[]|.browser_download_url' | grep 'linux-64.zip$') \
    | jq -r '.assets[]|.browser_download_url' | grep 'linux-64.zip$' | sed 's+download/v[^/]*+download/v1.8.1+g') \
    && unzip Xray-linux-64.zip \
    && chmod a+x xray \
    && mv xray /usr/bin/ \
    && xray version \
    \
    && cd /opt/share/xray \
    && curl -skSLO https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geoip.dat \
    && curl -skSLO https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geosite.dat \
    && sha256sum *.dat \
    \
    && rm -rf /tmp/*

ENV XRAY_REDIR_GEO="geoip:cn;geosite:cn" \
    XRAY_REDIR_DST='{"protocol":"blackhole"}' \
    USERS="uuid00;uuid01:email01;uuid02:email02"

ADD entrypoint.sh /

CMD ["/entrypoint.sh"]
