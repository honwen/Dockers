FROM chenhw2/alpine:base
LABEL MAINTAINER HONWEN <https://github.com/honwen>

# /usr/bin/gost
RUN mkdir -p /usr/bin/ \
    && cd /usr/bin/ \
    && curl -skSL https://github.com/go-gost/gost/releases/download/v3.0.0-rc6/gost_3.0.0-rc6_linux_amd64.tar.gz | tar -zxv gost \
    && gost -V

ENV ARGS="-L=:8080"
CMD /usr/bin/gost ${ARGS} ${METRIC:+-metrics=:${METRIC}}
