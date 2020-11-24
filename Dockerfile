FROM chenhw2/alpine:base
LABEL MAINTAINER HONWEN <https://github.com/honwen>

# /usr/bin/dnsproxy
RUN cd /tmp \
    && curl -skSL $(curl -skSL 'https://api.github.com/repos/AdguardTeam/dnsproxy/releases/latest' | sed -n '/url.*linux-amd64/{s/.*\(https:.*tar.gz\).*/\1/p}') | tar xz \
    && mv linux-amd64/dnsproxy /usr/bin/ \
    && dnsproxy --version \
    && rm -rf /tmp/*

ENV ARGS="--cache --fastest-addr --edns --all-servers -u tls://1.0.0.1:853 -u tls://8.8.4.4:853 -u tls://162.159.36.1:853 -u tls://185.222.222.222:853"

CMD /usr/bin/dnsproxy ${ARGS}
