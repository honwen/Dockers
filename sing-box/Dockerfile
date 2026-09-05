FROM chenhw2/alpine:base
LABEL MAINTAINER="https://github.com/honwen"

# /usr/bin/sing-box /data/geo*.db
RUN cd /tmp \
  && curl -skSLO https://github.com/SagerNet/sing-box/releases/download/v1.12.15/sing-box-1.12.15-linux-amd64.tar.gz \
  && tar -C /usr/bin --strip-components=1 -zxvf sing-box-*-linux-amd64.tar.gz \
  && sing-box version \
  && rm -rf /tmp/* /usr/bin/LICENSE

CMD ["sing-box", "run", "-c", "/opt/config.json"]
