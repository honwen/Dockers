FROM chenhw2/alpine:base
LABEL MAINTAINER="https://github.com/honwen"

# /usr/bin/sing-box /data/geo*.db
RUN cd /tmp \
  && curl -skSLO $( \
  curl -skSL 'https://api.github.com/repos/SagerNet/sing-box/releases/latest' | \
  yq -r '.assets[]|.browser_download_url' | grep 'linux-amd64.tar.gz$' \
  ) \
  && tar -C /usr/bin --strip-components=1 -zxvf sing-box-*-linux-amd64.tar.gz \
  && sing-box version \
  && rm -rf /tmp/* /usr/bin/LICENSE

CMD ["sing-box", "run", "-c", "/opt/config.json"]

