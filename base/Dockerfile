#
# Alpine 3.13 CURL, WGET, JQ, HTTPS, HKT_TIMEZONE
#

FROM alpine:3.13

RUN set -ex \
    && apk add --update --no-cache curl wget ca-certificates jq tzdata \
    && update-ca-certificates \
    && cp -f /usr/share/zoneinfo/Asia/Hong_Kong /etc/localtime \
    && date \
    && apk del tzdata \
    && rm -rf /var/cache/apk/*
