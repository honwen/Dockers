FROM chenhw2/alpine:base
LABEL MAINTAINER CHENHW2 <https://github.com/chenhw2>

ARG VER=20180806.0
ARG URL=https://github.com/wangyu-/UDPspeeder/releases/download/${VER}/speederv2_linux.tar.gz

# /usr/bin/udp-speeder
RUN mkdir -p /usr/bin/ \
    && cd /usr/bin/ \
    && wget -qO- ${URL} | tar xz \
    && mv speederv2_amd64 udp-speeder \
    && rm -f speederv2_*

USER nobody

ENV ARGS='-s -l 0.0.0.0:6666 -r 8.8.8.8:53'

EXPOSE 6666/udp

CMD udp-speeder ${ARGS}

