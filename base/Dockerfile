#
# Debian 12 CURL, WGET, YQ, HTTPS, HKT_TIMEZONE
#

# FROM debian:12-slim
FROM bitnami/minideb:bookworm

ARG TZ=Asia/Hong_Kong

RUN set -ex && cd / \
    && apt-get update \
    && apt-get install -y --no-install-recommends curl wget ca-certificates net-tools procps \
    && curl https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64 -sSLo /usr/bin/yq \
    && chmod a+x /usr/bin/yq \
    && echo $TZ > /etc/timezone \
    && ln -sf /usr/share/zoneinfo/$TZ /etc/localtime \
    && date \
    && rm -rf /var/cache/apt/* /var/log/apt/*
