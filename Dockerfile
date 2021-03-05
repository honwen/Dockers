#
# Dockerfile for shadowsocks-rust, simple-obfs and v2ray-plugin/xray-plugin
#

FROM chenhw2/libev-build:musl as obfs
FROM teddysun/shadowsocks-rust:alpine as misc

FROM chenhw2/alpine:base
LABEL MAINTAINER HONWEN <https://github.com/honwen>

COPY --from=obfs /usr/bin/obfs* /usr/bin/
COPY --from=misc /usr/bin/ss* /usr/bin/
COPY --from=misc /usr/bin/*ray-plugin /usr/bin/

ENV ARGS='-c /var/config.json'

CMD ssserver ${ARGS}
