FROM alioygur/wait-for as wait
FROM chenhw2/gost as gost
FROM chenhw2/frp as frp
FROM chenhw2/mr2 as mr2

FROM chenhw2/debian:base
LABEL MAINTAINER="https://github.com/chenhw2/Dockers"

ARG TOOLS="dnsutils iputils-ping ipcalc"
ARG DEPS="kmod xl2tpd strongswan"

RUN set -ex && cd / \
  && apt update && apt install -y --no-install-recommends $TOOLS $DEPS

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
