#
# Alpine 3.18 CURL, WGET, YQ, HTTPS, HKT_TIMEZONE
#

FROM alpine:3.18

ARG TZ=Asia/Hong_Kong

RUN set -ex \
    && apk add --update --no-cache curl wget ca-certificates yq tzdata \
    && update-ca-certificates \
    && echo $TZ > /etc/timezone \
    && ln -sf /usr/share/zoneinfo/$TZ /etc/localtime \
    && date \
    && apk del tzdata \
    && rm -rf /var/cache/apk/*
