#
# Alpine 3.12 CURL, WGET, HTTPS, HKT_TIMEZONE
#

FROM alpine:3.12

ARG TZ=Asia/Hong_Kong

RUN set -ex && \
    apk add --update --no-cache curl wget ca-certificates tzdata \
    && update-ca-certificates \
    && ln -sf /usr/share/zoneinfo/$TZ /etc/localtime \
    && rm -rf /var/cache/apk/*
