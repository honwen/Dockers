FROM gitea/gitea:1           as gitea
FROM abiosoft/caddy:no-stats as caddy

FROM chenhw2/alpine:base
LABEL MAINTAINER="https://github.com/chenhw2"
RUN apk add --update --no-cache git && rm -rf /var/cache/apk/*

RUN set -ex && \
    addgroup -S -g 1000 git && \
    adduser -S -H -D -h /data/git -s /bin/nologin -u 1000 -G git git && \
    echo "git:$(dd if=/dev/urandom bs=24 count=1 status=none | base64)" | chpasswd

# /usr/bin/{gitea, caddy}
COPY --from=gitea /app/gitea/gitea /usr/bin/
COPY --from=caddy /usr/bin/caddy   /usr/bin/

ENV ACME_AGREE=true \
    DOMAIN=example.com \
    EXTRA_DOMAINS="www.example.com,git.example.com" \
    USER=git \
    GITEA_CUSTOM=/data/gitea \
    WS_PREFIX=/websocket \
    FAKE_MODE=on \
    EXTRA_PROXYS="/example http://git.example.com/git,/git https://www.example.com/example"

VOLUME ["/data"]

EXPOSE 80/tcp 443/tcp

ADD entrypoint.sh 404.html /

CMD ["/entrypoint.sh"]
