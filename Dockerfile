FROM chenhw2/alpine:base
LABEL MAINTAINER HONWEN <https://github.com/honwen>

# /usr/bin/gost
RUN mkdir -p /usr/bin/ \
    && cd /usr/bin/ \
    && curl -skSLO $(curl -skSL 'https://api.github.com/repos/ginuerzh/gost/releases/latest' | sed -n '/url.*linux-amd64/{s/.*\(https:.*.gz\).*/\1/p}') \
    && gunzip gost-*.gz \
    && chmod a+x gost-* \
    && ln -sf gost-* gost \
    && gost -V

ENV ARGS="-L=:8080"
CMD /usr/bin/gost ${ARGS}
