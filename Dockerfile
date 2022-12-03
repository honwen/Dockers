FROM chenhw2/alpine:base
LABEL MAINTAINER HONWEN <https://github.com/honwen>

# /usr/bin/gost
RUN mkdir -p /usr/bin/ \
    && cd /usr/bin/ \
    && curl -skSLO https://github.com/go-gost/gost/releases/download/v3.0.0-rc.1/gost-linux-amd64-3.0.0-rc.1.gz \
    && gunzip gost-*.gz \
    && chmod a+x gost-* \
    && ln -sf gost-* gost \
    && gost -V

ENV ARGS="-L=:8080"
CMD /usr/bin/gost ${ARGS} ${METRIC:+-metrics=:${METRIC}}
