#!/bin/sh

mkdir -p /var/log/smartdns
chmod 777 /var/log/smartdns

echo >&2 "# SMARTDNS: cn"
$(which smartdns) -c /etc/smartdns_cn.conf -p /var/run/smartdns_cn.pid

echo >&2 "# SMARTDNS: gfwlist"
$(which smartdns) -c /etc/smartdns.conf -p /var/run/smartdns.pid

echo >&2 "# DNSMASQ: tldn/gfwlist"
zcat /data/tldn.gz | sed "s/^/server=\//;s/$/\/127.0.0.1#7700/" >>/etc/dnsmasq.conf
zcat /data/gfwlist.gz | sed "s/^/server=\//;s/$/\/127.0.0.1#7700/" >>/etc/dnsmasq.conf

echo >&2 "# DNSMASQ: direct"
zcat /data/direct.gz | sed "s/^/server=\//;s/$/\/127.0.0.1#7800/" >>/etc/dnsmasq.conf

echo >&2 "# DNSMASQ: configured"
$(which dnsmasq) -k --port=$PORT
