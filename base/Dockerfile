#
# Debian 12 CURL, WGET, YQ, HTTPS, HKT_TIMEZONE
#

# FROM debian:12-slim
FROM bitnami/minideb:bookworm

ENV TZ="Asia/Hong_Kong" \
    LANG="C.utf8" \
    LANGUAGE="C.utf8" \
    LC_ALL="C.utf8"

RUN set -ex && cd /tmp \
    && apt update -y --allow-releaseinfo-change \
    && apt install -y --no-install-recommends curl wget ca-certificates net-tools procps \
    && curl https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64 -sSLo /usr/bin/yq \
    && chmod a+x /usr/bin/yq \
    && echo $TZ >/etc/timezone \
    && ln -sf /usr/share/zoneinfo/$TZ /etc/localtime \
    && date \
    && locale \
    && rm -rf /var/cache/apt/* /var/lib/apt/lists/* /var/cache/debconf/*-old /var/log/apt/* /var/log/*.log
