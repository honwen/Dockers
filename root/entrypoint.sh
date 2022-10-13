#!/bin/sh

mkdir -p /var/log/smartdns
chmod 777 /var/log/smartdns
echo "nameserver 127.0.0.1" >/etc/resolv.conf

echo >&2 "# SMARTDNS: cn"
$(which smartdns) -p- -c /etc/smartdns_cn.conf

echo >&2 "# SMARTDNS: gfwlist"
$(which smartdns) -p- -c /etc/smartdns.conf

echo >&2 "# DNSMASQ: tldn/gfwlist"
zcat /data/tldn.gz | sed "s/^/server=\//;s/$/\/127.0.0.1#7700/" >>/etc/dnsmasq.conf
zcat /data/gfwlist.gz | sed "s/^/server=\//;s/$/\/127.0.0.1#7700/" >>/etc/dnsmasq.conf

echo >&2 "# DNSMASQ: direct"
zcat /data/direct.gz | sed "s/^/server=\//;s/$/\/127.0.0.1#7800/" >>/etc/dnsmasq.conf

echo >&2 "# DCOMPASS: chinadns"
$(which dcompass) -c /etc/chinadns.yaml >/var/log/dcompass.log 2>&1 &

echo >&2 "# DNSMASQ: configured"
$(which dnsmasq) -k --port=$PORT
