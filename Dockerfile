FROM chenhw2/alpine:base
LABEL MAINTAINER HONWEN <https://github.com/honwen>

# /usr/bin/gost
RUN mkdir -p /usr/bin/ \
    && cd /usr/bin/ \
    && curl -skSL $(curl -skSL 'https://api.github.com/repos/go-gost/gost/releases' \
    | yq -r '.[]|.assets[]|.browser_download_url' | grep 'linux_amd64.tar.gz$' | head -n1) | tar -zxv gost \
    && gost -V

ENV ARGS="-L=:8080"
CMD /usr/bin/gost ${ARGS} ${METRIC:+-metrics=:${METRIC}}
