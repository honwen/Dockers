#
# Debian 9.6 CURL, WGET, HTTPS, HKT_TIMEZONE
#

FROM debian:9.6-slim

ARG TZ=Asia/Hong_Kong

RUN set -ex && cd / \
    && apt-get update \
    && apt-get -y dist-upgrade \
    && apt-get install -y --no-install-recommends curl wget net-tools procps \
    && ln -sf /usr/share/zoneinfo/$TZ /etc/localtime \
    && rm -rf /var/cache/apt/*
