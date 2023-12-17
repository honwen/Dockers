#
# Alpine 3.19 CURL, WGET, YQ, HTTPS, HKT_TIMEZONE
#

FROM alpine:3.19

ARG TZ=Asia/Hong_Kong

RUN set -ex \
    && apk add --update --no-cache curl wget ca-certificates yq tzdata \
    && update-ca-certificates \
    && echo $TZ > /etc/timezone \
    && cp -Lf /usr/share/zoneinfo/$TZ /etc/localtime \
    && date \
    && apk del tzdata \
    && rm -rf /var/cache/apk/*
