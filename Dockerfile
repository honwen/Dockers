#
# Dockerfile for shadowsocks-rust, simple-obfs and v2ray-plugin
#

FROM chenhw2/libev-build:musl as obfs
FROM chenhw2/v2ray-plugin:latest as plugin
FROM teddysun/shadowsocks-rust:alpine as ss

FROM chenhw2/alpine:base
LABEL MAINTAINER CHENHW2 <https://github.com/chenhw2>

COPY --from=ss /usr/bin/ss* /usr/bin/
COPY --from=obfs /usr/bin/obfs* /usr/bin/
COPY --from=plugin /usr/bin/v2ray-plugin /usr/bin/

ENV ARGS='-c /var/config.json'

CMD ssserver ${ARGS}

