FROM dreamacro/clash as clash
FROM ochinchina/supervisord as supervisord
FROM chenhw2/dnsproxy as dnsproxy
FROM golang as golang
RUN CGO_ENABLED=0 GO111MODULE='on' go get -v github.com/chenhw2/shadowsocks-helper@v0.10.0

FROM chenhw2/alpine:base
LABEL MAINTAINER="https://github.com/chenhw2"

WORKDIR /subscribe

# /usr/bin/{dnsproxy, clash, glider, supervisord, shadowsocks-helper}
COPY --from=clash /clash /usr/bin/
COPY --from=dnsproxy /usr/bin/dnsproxy /usr/bin/
COPY --from=supervisord /usr/local/bin/supervisord /usr/bin/
COPY --from=golang /go/bin/* /usr/bin/

RUN set -ex \
    && curl -skSLO https://raw.githubusercontent.com/alecthw/mmdb_china_ip_list/release/Country.mmdb \
    && curl -skSL https://github.com/Hackl0us/SS-Rule-Snippet/raw/master/LAZY_RULES/clash.yaml | sed 's/ *#.*//g' | sed '/^[ \t]*$/d' > Hackl0us_clash.yaml

ENV URL=https://subscribe.entrypoint \
    TEST_URL="http://www.gstatic.com/generate_204" \
    CLASH_POLICY="url-test" \
    CLASH_INTERVAL="120" \
    SRV_GREP="ssr://" \
    DNS_SAFE="tls://dns.adguard.com;tls://185.222.222.222:853;tls://8.8.4.4:853;tls://149.112.112.112:853;sdns://AgMAAAAAAAAADzE3Ni4xMDMuMTMwLjEzMCD5_zfwLmMstzhwJcB-V5CKPTcbfJXYzdA5DeIx7ZQ6Eg9kbnMuYWRndWFyZC5jb20KL2Rucy1xdWVyeQ;sdns://AgMAAAAAAAAADDQ1Ljc3LjE4MC4xMCBsA2QQ3lR1Nl9Ygfr8FdBIpL-doxmHECRx3T5NIXYYtxNkbnMuY29udGFpbmVycGkuY29tCi9kbnMtcXVlcnk" \
    DNS_FAILSAFE="tls://162.159.36.1:853;tcp://119.29.107.85:9090;tcp://118.24.208.197:9090"

EXPOSE 8080/tcp 1080/tcp

ADD entrypoint.sh /

CMD /entrypoint.sh
