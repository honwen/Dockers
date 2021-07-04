FROM chenhw2/alpine:base
LABEL MAINTAINER CHENHW2 <https://github.com/chenhw2>

RUN set -ex \
    && cd /usr/bin/ \
    && curl -skSL -o /usr/bin/mr2 $(curl -skSL 'https://api.github.com/repos/txthinking/mr2/releases/latest' | sed -n '/url.*linux_amd64/{s/.*\(https:.*\)[^\.].*/\1/p}') \
    && chmod a+x /usr/bin/mr2 \
    && mr2 -v

USER nobody
ENV ARGS="server -l :6666 -p password"
EXPOSE 6060/tcp 6060/udp

CMD /usr/bin/mr2 ${ARGS}
