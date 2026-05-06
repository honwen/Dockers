FROM chenhw2/alpine:base
LABEL MAINTAINER="HONWEN <https://github.com/honwen>"

# /usr/bin/dnsproxy
RUN cd /tmp \
    && curl -skSL $(curl -skSL 'https://api.github.com/repos/AdguardTeam/dnsproxy/releases/latest' | sed -n '/url.*linux-amd64/{s/.*\(https:.*tar.gz\).*/\1/p}') | tar xz \
    && mv linux-amd64/dnsproxy /usr/bin/ \
    && dnsproxy --version \
    && rm -rf /tmp/*

ENV ARGS="--timeout=500ms --cache --cache-optimistic --edns --upstream-mode=fastest_addr --tls-min-version=1.2 -u=https://unfiltered.adguard-dns.com/dns-query -u=tls://8.8.4.4 -u=tls://162.159.36.1 -f=tcp://9.9.9.11:9953"
ENV ARGS_EX="-u=[/gov.cn/]tcp://223.5.5.5 -u=[/gov.cn/]tcp://119.29.29.29 -u=[/aliyuncs.com/]tcp://223.5.5.5 -u=[/aliyuncs.com/]tcp://223.6.6.6 -u=[/tencentyun.com/]tcp://183.60.83.19 -u=[/tencentyun.com/]tcp://183.60.82.98"
# ENV ARGS_SP="-u=[/github.com/]tcp://80.80.80.80 -u=[/githubassets.com/]tcp://80.80.80.80 -u=[/githubusercontent.com/]tcp://80.80.80.80"

CMD ["/bin/sh", "-c", "/usr/bin/dnsproxy ${ARGS} ${ARGS_EX} ${ARGS_SP}"]
