FROM chenhw2/alpine:base as dler
LABEL MAINTAINER CHENHW2 <https://github.com/chenhw2>

ARG SS2_URL=https://github.com/shadowsocks/go-shadowsocks2/releases/download/v0.0.9/shadowsocks2-linux.gz

# /usr/bin/ss-aio
RUN set -ex && \
    apk add --update --no-cache --virtual gzip \
    && wget -qO- ${SS2_URL} | gzip -d > /usr/bin/ss-aio \
    && chmod +x /usr/bin/ss-aio

FROM chenhw2/alpine:base
LABEL MAINTAINER CHENHW2 <https://github.com/chenhw2>

# /usr/bin/ss-aio
COPY --from=dler /usr/bin/ss-aio /usr/bin

USER nobody
ENV ARGS="-s ss://AEAD_CHACHA20_POLY1305:your-password@:8488"
EXPOSE 8488/tcp 8488/udp

CMD /usr/bin/ss-aio ${ARGS} -verbose
