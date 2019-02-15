FROM siomiz/softethervpn:debian as build

RUN set -ex && cd / \
    && apt update && apt install -y --no-install-recommends zip \
    && zip -r9 /artifacts.zip /usr/vpn* /usr/bin/vpn*

FROM chenhw2/debian:base
LABEL MAINTAINER="https://github.com/chenhw2/Dockers"

COPY --from=build /artifacts.zip /

COPY entrypoint.sh /

RUN set -ex && cd / \
    && apt update && apt install -y --no-install-recommends \
    libncurses5 libreadline7 libssl1.1 iptables unzip zlib1g \
    && unzip -o /artifacts.zip -d / \
    && apt update && apt -y autoremove && rm -rf /var/cache/apt/* /artifacts.zip

ENV PSK='vpn' \
    USERS='user0001:password'

ENTRYPOINT ["/entrypoint.sh"]

EXPOSE 500/udp 4500/udp 1701/udp 1701/tcp 1194/udp 5555/tcp

CMD ["vpnserver", "execsvc"]
