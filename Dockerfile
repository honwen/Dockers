FROM chenhw2/alpine:base
LABEL MAINTAINER="https://github.com/honwen"

# /usr/bin/warp-reg
# /usr/bin/sing-box
RUN cd /tmp \
  && curl -skSL $(curl -skSL 'https://api.github.com/repos/badafans/warp-reg/releases/latest' | \
  jq -r '.assets[]|.browser_download_url' | grep 'linux-amd64$') -o /usr/bin/warp-reg \
  && chmod a+x /usr/bin/warp-reg \
  \
  # && curl -skSLO $(curl -skSL 'https://api.github.com/repos/SagerNet/sing-box/releases/latest' | \
  # jq -r '.assets[]|.browser_download_url' | grep 'linux-amd64.tar.gz$') \
  # && tar -C /usr/bin --strip-components=1 -zxvf sing-box-*-linux-amd64.tar.gz \
  # && sing-box version \
  && rm -rf /tmp/* /usr/bin/LICENSE

ADD entrypoint.sh /

CMD ["/entrypoint.sh"]
