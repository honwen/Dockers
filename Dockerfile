FROM chenhw2/alpine:base
LABEL MAINTAINER="https://github.com/honwen"

# /usr/bin/sing-box /data/geo*.db
RUN cd /tmp \
  && curl -skSLO $(curl -skSL 'https://api.github.com/repos/SagerNet/sing-box/releases/latest' | \
  yq -r '.assets[]|.browser_download_url' | grep 'linux-amd64.tar.gz$') \
  && tar -C /usr/bin --strip-components=1 -zxvf sing-box-*-linux-amd64.tar.gz \
  && sing-box version \
  && rm -rf /tmp/* /usr/bin/LICENSE \
  && mkdir -p /geodata \
  && cd /geodata \
  && wget https://github.com/SagerNet/sing-geoip/releases/latest/download/geoip.db \
  && wget https://github.com/SagerNet/sing-geosite/releases/latest/download/geosite.db

CMD ["sing-box", "run", "-c", "/opt/config.json"]

