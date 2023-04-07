FROM chenhw2/alpine:base
LABEL MAINTAINER="https://github.com/honwen"

# /usr/bin/warp-go
# /usr/bin/sing-box
RUN cd /tmp \
  && curl -skSL https://gitlab.com/ProjectWARP/warp-go/uploads/19fe0426e26d5448fd8b288b7e957530/warp-go_1.0.8_linux_amd64.tar.gz | tar -C /usr/bin -zxv warp-go \
  && chmod a+x /usr/bin/warp-go \
  && warp-go -v \
  \
  && curl -skSLO $(curl -skSL 'https://api.github.com/repos/SagerNet/sing-box/releases/latest' | \
  jq -r '.assets[]|.browser_download_url' | grep 'linux-amd64.tar.gz$') \
  && tar -C /usr/bin --strip-components=1 -zxvf sing-box-*-linux-amd64.tar.gz \
  && sing-box version \
  && rm -rf /tmp/* /usr/bin/LICENSE

ADD entrypoint.sh /

CMD ["/entrypoint.sh"]
