FROM chenhw2/alpine:base
LABEL MAINTAINER="https://github.com/honwen"

# /usr/bin/kcptube
RUN cd /tmp \
  && curl -skSL $(curl -skSL 'https://api.github.com/repos/cnbatch/kcptube/releases/latest' | \
  yq -r '.assets[]|.browser_download_url' | grep 'musl-x64.tar') | tar -C /usr/bin -jxv \
  && kcptube \
  \
  && curl -skSL $(curl -skSL 'https://api.github.com/repos/cnbatch/udphop/releases/latest' | \
  yq -r '.assets[]|.browser_download_url' | grep 'musl-x64.tar') | tar -C /usr/bin -jxv \
  && udphop

ADD entrypoint.sh /

CMD ["/entrypoint.sh"]
