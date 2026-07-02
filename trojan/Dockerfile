FROM chenhw2/alpine:base
LABEL MAINTAINER CHENHW2 <https://github.com/chenhw2>

ARG VER=1.14.1
ARG URL=https://github.com/trojan-gfw/trojan/releases/download/v${VER}/trojan-${VER}-linux-amd64.tar.xz

# /usr/bin/trojan
RUN sh -ex \
    && wget -qO- ${URL} | tar Jx \
    && mv trojan/trojan /usr/bin/ \
    && rm -rf trojan

VOLUME /trojan

CMD /usr/bin/trojan -c /trojan/config.json
