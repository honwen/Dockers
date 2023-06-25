FROM chenhw2/alpine:base
LABEL MAINTAINER="https://github.com/honwen"

# /usr/bin/warp-reg
RUN cd /tmp \
  && curl -skSL $(curl -skSL 'https://api.github.com/repos/badafans/warp-reg/releases' | \
  yq -r '.[]|.assets[]|.browser_download_url' | grep 'linux-amd64$' | head -n1) -o /usr/bin/warp-reg \
  && chmod a+x /usr/bin/warp-reg \
  \
  && rm -rf /tmp/* /usr/bin/LICENSE

ADD entrypoint.sh /

CMD ["/entrypoint.sh"]
