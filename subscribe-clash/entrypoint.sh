#!/bin/sh

workdir=$(pwd)
conf="${workdir}/entrypoint.conf"
yaml="${workdir}/config.yaml"
logs="${workdir}/log"
mkdir -p $logs

DNS_BOOTSTRAP="$(echo $DNS_FAILSAFE | sed 's/[ \t]//g; s/;/\n/g' | sed '/^$/d; s/^/ -b /g' | tr -d '\n')"
DNS_FAILSAFE="$(echo $DNS_FAILSAFE | sed 's/[ \t]//g; s/;/\n/g' | sed '/^$/d; s/^/ -f /g' | tr -d '\n')"
DNS_SAFE="$(echo $DNS_SAFE | sed 's/[ \t]//g; s/;/\n/g' | sed '/^$/d; s/^/ -u /g' | tr -d '\n')"

( /usr/bin/dnsproxy --cache --edns --all-servers --ipv6-disabled $DNS_BOOTSTRAP $DNS_FAILSAFE $DNS_SAFE 2>&1 > $logs/dns.log ) &
while ! nslookup www.google.com 2>&1 | grep -q 1e100; do :;done

cat <<-EOF >> $conf
[program:DNS]
command=/usr/bin/dnsproxy --cache --edns --all-servers --ipv6-disabled $DNS_BOOTSTRAP $DNS_FAILSAFE $DNS_SAFE
autorestart=true
redirect_stderr=true
stdout_logfile=$logs/dns.log
stdout_logfile_maxbytes=102400

[program:CLASH]
command=/usr/bin/clash -d $workdir
autorestart=true
redirect_stderr=true
stdout_logfile=/dev/stdout,$logs/clash.log
stdout_logfile_maxbytes=102400

EOF

cat <<-EOF >> $yaml
port: 8080
socks-port: 1080
allow-lan: true
log-level: debug
mode: rule

dns:
  enable: true
  nameserver:
  - 127.0.0.1:53

proxies:
EOF

port=18000
shadowsocks-helper subscribe2ssr -s $URL | tr -d ' ' > subscribe.list
grep $SRV_GREP subscribe.list | while read ssr; do
ssr=$(echo $ssr | sed 's/^[^:]*://g')
shadowsocks-helper ssr2clash -s $ssr | sed 's+^+  +g' >> $yaml
port=$((port + 1))
done

sed -n 's/.*name: /      - /p' $yaml | grep -v 'Proxy' >> ${yaml}_group

cat <<-EOF | sed 's/,],/\n],/g' >> $yaml

proxy-groups:
  - name: Proxy
    type: url-test
    proxies:
$(cat ${yaml}_group)
    url: "${TEST_URL}"
    interval: ${CLASH_INTERVAL}

rules:
$(sed "1,$(sed -n -e '/^rules:/=' Hackl0us_clash.yaml)d" Hackl0us_clash.yaml)
EOF

kill -9 $(pgrep -f dnsproxy)
echo -e "\n# Init: Done; Subscribe Server Count: $(cat ${yaml}_group | wc -l); FINAL Supervisord"
rm -f ${yaml}_group Hackl0us_clash.yaml
/usr/bin/supervisord -c $conf
