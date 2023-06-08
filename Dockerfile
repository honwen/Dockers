FROM chenhw2/alpine:base
LABEL MAINTAINER="https://github.com/honwen"

# /usr/bin/tuic-{client, server}
RUN cd /usr/bin \
  && curl -skSL $(curl -skSL 'https://api.github.com/repos/EAimTY/tuic/releases' | \
  jq -r '.[]|.assets[]|.browser_download_url' | grep 'x86_64-unknown-linux-musl$' | grep 'client') -o tuic-client \
  && curl -skSL $(curl -skSL 'https://api.github.com/repos/EAimTY/tuic/releases' | \
  jq -r '.[]|.assets[]|.browser_download_url' | grep 'x86_64-unknown-linux-musl$' | grep 'server') -o tuic-server \
  && chmod a+x tuic-* \
  && tuic-client -v \
  && tuic-server -v

ENV \
  MODE='server' \
  ARGS='-c /opt/config.json' \
  EXTRA_ARGS=''

CMD "$(which tuic-${MODE})" $ARGS $EXTRA_ARGS
