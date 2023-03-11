FROM chenhw2/alpine:base
LABEL MAINTAINER="https://github.com/honwen"

# /usr/bin/noisy-shuttle
RUN cd /usr/bin \
  && curl -skSL $(curl -skSL 'https://api.github.com/repos/Gowee/noisy-shuttle/releases/latest' | \
  jq -r '.assets[]|.browser_download_url' | grep 'x86_64-.*-linux-musl$') -o noisy-shuttle \
  && chmod a+x noisy-shuttle \
  && ln -sf noisy-shuttle noisy \
  && noisy-shuttle -V

ENV \
  mode='server' \
  listen_addr='0.0.0.0' \
  listen_port='443' \
  upstream='bing.com:443' \
  key='key' \
  EXTRA_ARGS='-q'

CMD "$(which noisy-shuttle)" "$mode" "${listen_addr}:${listen_port}" "$upstream" "$key" $EXTRA_ARGS
