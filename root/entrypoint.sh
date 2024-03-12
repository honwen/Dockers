#!/bin/sh

mkdir -p /var/log/smartdns
chmod 777 /var/log/smartdns
echo "nameserver 127.0.0.1" >/etc/resolv.conf

[ -e /data/VERSION ] && echo "# VERSION: $(cat /data/VERSION)"

echo >&2 "# SMARTDNS: cn"
$(which smartdns) -p- -c /etc/smartdns_cn.conf

echo >&2 "# SMARTDNS: gfwlist"
[ "V${EDNS}" != "V" ] && {
  echo ${EDNS} | grep -q '/' || EDNS=$(echo -n ${EDNS} | sed 's+\.[0-9]*$+.0/24+g')
  sed "s+^edns-client-subnet .*+edns-client-subnet ${EDNS}+g" -i /etc/smartdns.conf &&
    echo >&2 "# SMARTDNS: EDNS[${EDNS}]"
}
$(which smartdns) -p- -c /etc/smartdns.conf

echo >&2 "# DNSMASQ: init"
cp -f /etc/dnsmasq.init.conf /etc/dnsmasq.conf

echo >&2 "# DNSMASQ: tldn/gfwlist"
zcat /data/tldn.gz | sed "s/^/server=\//;s/$/\/127.0.0.1#7700/" >>/etc/dnsmasq.conf
zcat /data/gfwlist.gz | sed "s/^/server=\//;s/$/\/127.0.0.1#7700/" >>/etc/dnsmasq.conf

echo >&2 "# DNSMASQ: direct"
zcat /data/direct.gz | sed "s/^/server=\//;s/$/\/127.0.0.1#7800/" >>/etc/dnsmasq.conf

echo >&2 "# DNSMASQ: extra"
echo "$DNSMASQ_EXTRAS" | sed 's+;+\n+g' >>/etc/dnsmasq.conf

echo >&2 "# DCOMPASS: chinadns"
$(which dcompass) -c /etc/chinadns.yaml >/var/log/dcompass.log 2>&1 &

echo >&2 "# DNSMASQ: configured"
$(which dnsmasq) -k --port=$PORT
