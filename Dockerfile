FROM chenhw2/alpine:base
LABEL MAINTAINER="https://github.com/honwen"

# /usr/bin/shadowquic
RUN mkdir -p /opt/share/xray/ /tmp /var/cache/apk \
    && cd /tmp \
    && curl -skSL $(curl -skSL 'https://api.github.com/repos/spongebob888/shadowquic/releases/latest' | yq -r '.assets[]|.browser_download_url' | grep 'x86_64-linux-musl$') -o /usr/bin/shadowquic \
    && chmod a+x /usr/bin/shadowquic

ENV USERS="uuid00:pass00;uuid01:pass01"

ADD entrypoint.sh /

CMD ["/entrypoint.sh"]
