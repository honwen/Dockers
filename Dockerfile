FROM chenhw2/alpine:base
LABEL MAINTAINER="https://github.com/honwen"

# /usr/bin/hysteria
RUN cd /tmp \
  && curl -skSLo /usr/bin/hysteria $( \
  curl -skSL 'https://api.github.com/repos/apernet/hysteria/releases/latest' | \
  yq -r '.assets[]|.browser_download_url' | grep 'linux-amd64$' \
  ) \
  && chmod a+x /usr/bin/hysteria \
  && hysteria version

ENV MODE=server

CMD ["sh", "-c", "hysteria ${MODE} -c /opt/config.yaml"]

