#
# Alpine 3.16 CURL, WGET, JQ, HTTPS, HKT_TIMEZONE
#

FROM alpine:3.16

ARG TZ=Asia/Hong_Kong

RUN set -ex \
    && apk add --update --no-cache curl wget ca-certificates jq tzdata \
    && update-ca-certificates \
    && echo $TZ > /etc/timezone \
    && ln -sf /usr/share/zoneinfo/$TZ /etc/localtime \
    && date \
    && apk del tzdata \
    && rm -rf /var/cache/apk/*
