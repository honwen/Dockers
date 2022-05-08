#!/bin/sh

echo >&2 "# SMARTDNS: cn"
$(which smartdns) -c /etc/smartdns_cn.conf -p /var/run/smartdns_cn.pid

echo >&2 "# SMARTDNS: gfwlist"
$(which smartdns) -c /etc/smartdns.conf -p /var/run/smartdns.pid

echo >&2 "# DNSMASQ: gfwlist"
zcat /data/gfwlist.gz | sed "s/^/server=\//;s/$/\/127.0.0.1#7700/" >>/etc/dnsmasq.conf

echo >&2 "# DNSMASQ: configured"
$(which dnsmasq) -k --port=$PORT
