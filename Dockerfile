FROM siomiz/softethervpn:4.28-debian as build
RUN set -ex && cd / \
    && tar zcvf /binarys.tgz /usr/vpn* /usr/bin/vpn*

FROM chenhw2/debian:base
LABEL MAINTAINER="https://github.com/chenhw2/Dockers"

ARG NET_TOOLS="iptables iproute iputils-ping"
ARG LIB_NEEDS="libssl1.1 libncurses5 libreadline7 zlib1g"

COPY --from=build /binarys.tgz /

RUN set -ex && cd / \
    && tar zxvf /binarys.tgz \
    && apt update && apt install -y --no-install-recommends $NET_TOOLS $LIB_NEEDS \
    && apt update && apt -y autoremove && rm -rf /var/cache/apt/* /binarys.tgz

COPY entrypoint.sh /

ENV VPN="L2TP SSTP" \
    DNS1=8.8.8.8 \
    PSK=vpn \
    USERS=user0001:password

EXPOSE 500/udp 4500/udp 1701/udp 1701/tcp 1194/udp 5555/tcp

CMD ["/entrypoint.sh"]
