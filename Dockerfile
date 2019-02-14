FROM chenhw2/ssvpn:latest as ssvpn

FROM chenhw2/debian:base
LABEL MAINTAINER="https://github.com/chenhw2/Dockers"

COPY --from=ssvpn /usr/bin/ss-aio /usr/bin/
COPY --from=ssvpn /usr/bin/udp-speeder /usr/bin/

COPY apt-tools.sh /usr/local/bin/apt-tools
COPY entrypoint.sh /

RUN set -ex && cd / \
    && apt update && apt install -y gnupg unzip \
    && apt-tools ppa:paskal-07/softethervpn \
    && echo "deb http://deb.debian.org/debian sid main" >> /etc/apt/sources.list \
    && echo "deb http://deb.debian.org/debian experimental main" >> /etc/apt/sources.list \
    && apt update && apt install -y softether-common softether-vpnserver softether-vpncmd \
    && sed '/sid/d; /experimental/d' -i /etc/apt/sources.list \
    && apt update && apt -y autoremove && rm -rf /var/cache/apt/*

ENV PSK='vpn' \
    USERS='user0001:password'

ENTRYPOINT ["/entrypoint.sh"]

EXPOSE 500/udp 4500/udp 1701/udp 1701/tcp 1194/udp 5555/tcp
