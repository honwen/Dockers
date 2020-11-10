FROM chenhw2/alpine:base
LABEL MAINTAINER HONWEN <https://github.com/honwen>

ARG VER=v0.33.1
ARG URL=https://github.com/AdguardTeam/dnsproxy/releases/download/${VER}/dnsproxy-linux-amd64-${VER}.tar.gz

# /usr/bin/dnsproxy
RUN cd /tmp \
    && wget -qO- ${URL} | tar xzv \
    && mv linux-amd64/dnsproxy /usr/bin/ \
    && rm -rf /tmp/*

ENV ARGS="--cache --fastest-addr --edns --all-servers -u tls://1.0.0.1:853 -u tls://8.8.4.4:853 -u tls://162.159.36.1:853 -u tls://185.222.222.222:853"

CMD /usr/bin/dnsproxy ${ARGS}

