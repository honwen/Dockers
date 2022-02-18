FROM chenhw2/alpine:base
LABEL MAINTAINER HONWEN <https://github.com/honwen>

# /usr/bin/dnsproxy
RUN cd /tmp \
    && curl -skSL $(curl -skSL 'https://api.github.com/repos/AdguardTeam/dnsproxy/releases/latest' | sed -n '/url.*linux-amd64/{s/.*\(https:.*tar.gz\).*/\1/p}') | tar xz \
    && mv linux-amd64/dnsproxy /usr/bin/ \
    && dnsproxy --version \
    && rm -rf /tmp/*

ENV ARGS="--cache --cache-optimistic --fastest-addr --edns --all-servers --tls-min-version=1.2 -u=tls://8.8.4.4 -u=tls://162.159.36.1 -u=https://149.112.112.11:5053/dns-query -f=tcp://9.9.9.11:9953"

CMD /usr/bin/dnsproxy ${ARGS}
