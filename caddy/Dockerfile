FROM chenhw2/alpine:base
LABEL MAINTAINER CHENHW2 <https://github.com/chenhw2>

ARG CS_URL='https://caddyserver.com/download/linux/amd64?plugins=http.cache,http.cgi,http.expires,http.filebrowser,http.filter,http.forwardproxy,http.geoip,http.ipfilter,http.jwt,http.locale,http.login,http.minify,http.ratelimit,http.realip,http.upload,http.webdav,tls.dns.dnspod,tls.dns.godaddy,tls.dns.namecheap&license=personal&telemetry=off'

# /usr/bin/caddy
RUN mkdir -p /usr/bin/ /var/tmp/ /tmp/ \
    && cd /tmp/ \
    && wget -qO- ${CS_URL} | tar xz \
    && mv caddy /usr/bin/caddy \
    && rm -rf /tmp/*

EXPOSE 80/tcp 443/udp

VOLUME [ "/etc/caddy/Caddyfile" ]

CMD /usr/bin/caddy -log stdout -agree=true -conf=/etc/caddy/Caddyfile -root=/var/tmp
