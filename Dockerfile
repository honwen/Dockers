FROM chenhw2/gost as gost

FROM chenhw2/debian:base
LABEL MAINTAINER="https://github.com/chenhw2/Dockers"

ARG TOOLS="dnsutils iputils-ping ipcalc"
ARG DEPS="kmod xl2tpd strongswan"

RUN set -ex && cd / \
  && apt update && apt install -y --no-install-recommends $TOOLS $DEPS

COPY --from=gost /usr/bin/gost /usr/bin/
COPY entrypoint.sh /

ENV GOST_ARGS='-L=:8080'

EXPOSE 8080

VOLUME ["/lib/modules"]

CMD ["/entrypoint.sh"]
