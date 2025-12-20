#
# Alpine 3.23 CURL, WGET, YQ, HTTPS, HKT_TIMEZONE
#

FROM alpine:3.23

ARG TZ=Asia/Hong_Kong

RUN set -ex \
    && sed 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' -i /etc/apk/repositories \
    && apk add --update --no-cache curl wget ca-certificates yq-go tzdata \
    && update-ca-certificates \
    && echo $TZ > /etc/timezone \
    && cp -Lf /usr/share/zoneinfo/$TZ /etc/localtime \
    && date \
    && apk del tzdata \
    && rm -rf /var/cache/apk/*
