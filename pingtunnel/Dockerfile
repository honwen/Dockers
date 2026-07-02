FROM chenhw2/alpine:base
LABEL MAINTAINER="https://github.com/honwen"

# /usr/bin/pingtunnel
RUN cd /tmp \
  && curl -skSLO $( \
  curl -skSL 'https://api.github.com/repos/honwen/pingtunnel/releases' | \
  yq -r '.[]|.assets[]|.browser_download_url' | grep 'linux-amd64.*.tar.gz$' \
  ) \
  && tar -C /usr/bin --strip-components=1 -zxvf pingtunnel*.tar.gz linux-amd64/pingtunnel \
  && pingtunnel -v \
  && rm -rf /tmp/*

ENV ACTION='server' \
    ARGS=''

CMD pingtunnel ${ACTION} ${ARGS}
