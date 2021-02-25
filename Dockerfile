#
# Dockerfile for shadowsocks-rust, simple-obfs and v2ray-plugin/xray-plugin
#

FROM chenhw2/libev-build:musl as obfs
FROM chenhw2/xray-plugin:latest as pluginX
FROM chenhw2/v2ray-plugin:latest as pluginV
FROM teddysun/shadowsocks-rust:alpine as ss

FROM chenhw2/alpine:base
LABEL MAINTAINER HONWEN <https://github.com/honwen>

COPY --from=ss /usr/bin/ss* /usr/bin/
COPY --from=obfs /usr/bin/obfs* /usr/bin/
COPY --from=pluginX /usr/bin/xray-plugin /usr/bin/
COPY --from=pluginV /usr/bin/v2ray-plugin /usr/bin/

ENV ARGS='-c /var/config.json'

CMD ssserver ${ARGS}
