FROM chenhw2/alpine:base
LABEL MAINTAINER="https://github.com/honwen"

# /usr/bin/kcptube
RUN cd /tmp \
  && curl -skSL $(curl -skSL 'https://api.github.com/repos/cnbatch/kcptube/releases/latest' | \
  jq -r '.assets[]|.browser_download_url' | grep 'musl-x64.tar.gz$') | tar -C /usr/bin -zxv \
  && kcptube \
  \
  && curl -skSL $(curl -skSL 'https://api.github.com/repos/cnbatch/udphop/releases/latest' | \
  jq -r '.assets[]|.browser_download_url' | grep 'musl-x64.tar.gz$') | tar -C /usr/bin -zxv \
  && udphop

ADD entrypoint.sh /

CMD ["/entrypoint.sh"]
