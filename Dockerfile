FROM chenhw2/alpine:base
LABEL MAINTAINER CHENHW2 <https://github.com/chenhw2>

ARG VER=2.5
ARG GOST_URL=https://github.com/ginuerzh/gost/releases/download/v${VER}/gost_${VER}_linux_amd64.tar.gz

# some package in gost need glibc
RUN set -ex \
    && cd /var/cache/apk/ \
    && wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub \
    && wget -q https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.28-r0/glibc-2.28-r0.apk \
    && apk add glibc-*.apk \
    && rm -rf /var/cache/apk/*

# /usr/bin/gost
RUN wget -qO- ${GOST_URL} | tar xz \
    && mv gost_*/gost /usr/bin/gost \
    && rm -rf gost_*

ENV ARGS="-L=:8080"
CMD /usr/bin/gost ${ARGS}
