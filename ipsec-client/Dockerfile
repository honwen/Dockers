FROM alioygur/wait-for as wait
FROM chenhw2/gost as gost
FROM chenhw2/frp as frp
FROM chenhw2/mr2 as mr2

FROM chenhw2/debian:base
LABEL MAINTAINER="https://github.com/chenhw2/Dockers"

ARG TOOLS="dnsutils iputils-ping ipcalc"
ARG DEPS="kmod xl2tpd strongswan ca-certificates"

RUN set -ex && cd / \
  && apt update && apt install -y --no-install-recommends $TOOLS $DEPS \
  && update-ca-certificates \
  && rm -rf /var/cache/apt/*

RUN set -ex && cd /tmp \
  && curl -sSL https://github.com/ochinchina/supervisord/releases/download/v0.7.3/supervisord_0.7.3_Linux_64-bit.tar.gz | tar zx --strip-components=1 \
  && mv *_static /usr/bin/supervisord \
  && supervisord version \
  && rm -rf /tmp/*

COPY --from=mr2 /usr/bin/mr2 /usr/bin/
COPY --from=frp /usr/bin/frpc /usr/bin/
COPY --from=gost /usr/bin/gost /usr/bin/
COPY --from=wait /app/wait-for /usr/bin/
COPY entrypoint.sh /

ENV TOOL='gost'
ENV TOOL_ARGS='-L=:8080'
# ENV PROBE_TCP='127.0.0.1:8080'

EXPOSE 8080

VOLUME ["/lib/modules"]

CMD ["/entrypoint.sh"]
