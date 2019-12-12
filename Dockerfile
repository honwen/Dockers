FROM chenhw2/alpine:base
LABEL MAINTAINER CHENHW2 <https://github.com/chenhw2>

ARG SRC_URL=https://www.neiwangchuantou.vip/client/linux_amd64_client.tar

# /usr/bin/npc
RUN set -ex \
    && wget -qO- ${SRC_URL} | tar xz \
    && mv npc /usr/bin/ \
    && chmod a+x /usr/bin/npc

VOLUME /frp

CMD /usr/bin/npc -config /npc/config.ini

