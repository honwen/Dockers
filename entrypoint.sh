#!/bin/sh

workdir=$(pwd)
conf="${workdir}/entrypoint.conf"
yaml="${workdir}/config.yaml"
logs="${workdir}/log"
mkdir -p $logs

DNS_BOOTSTRAP="$(echo $DNS_FAILSAFE | sed 's/[ \t]//g; s/;/\n/g' | sed '/^$/d; s/^/ -b /g' | tr -d '\n')"
DNS_FAILSAFE="$(echo $DNS_FAILSAFE | sed 's/[ \t]//g; s/;/\n/g' | sed '/^$/d; s/^/ -f /g' | tr -d '\n')"
DNS_SAFE="$(echo $DNS_SAFE | sed 's/[ \t]//g; s/;/\n/g' | sed '/^$/d; s/^/ -u /g' | tr -d '\n')"

( /usr/bin/dnsproxy -z -s -p 53 $DNS_BOOTSTRAP $DNS_FAILSAFE $DNS_SAFE 2>&1 > $logs/dns.log ) &
while ! nslookup www.google.com 2>&1 | grep -q 1e100; do :;done

cat <<-EOF >> $conf
[program:DNS]
command=/usr/bin/dnsproxy -z -s -p 53 $DNS_BOOTSTRAP $DNS_FAILSAFE $DNS_SAFE
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
mode: Rule

dns:
  enable: true
  nameserver:
  - 127.0.0.1:53

Proxy:
EOF

port=18000
shadowsocks-helper subscribe2ssr -s $URL | tr -d ' ' | while read ssr; do
name=$(echo $ssr | sed 's/:.*//g')
ssr=$(echo $ssr | sed 's/^[^:]*://g')

cat <<-EOF >> $conf
[program:$name]
command=/usr/bin/glider -listen socks5://:$port -forward $ssr
autorestart=true
redirect_stderr=true
stdout_logfile=$logs/glider-$name.log
stdout_logfile_maxbytes=102400

EOF

cat <<-EOF >> $yaml
- { name: "$name", type: socks5, server: 127.0.0.1, port: $port }
EOF

echo -en "  \"$name\",\n" >> ${yaml}_group

port=$((port + 1))
done

cat <<-EOF | sed 's/,],/\n],/g' >> $yaml

Proxy Group:
- { name: "Proxy", type: url-test,
proxies: [
$(cat ${yaml}_group)],
url: "http://www.gstatic.com/generate_204", interval: 300 }

Rule:
$(sed "1,$(sed -n -e '/^Rule/=' Hackl0us_clash.yaml)d" Hackl0us_clash.yaml)
EOF

rm -f ${yaml}_group Hackl0us_clash.yaml
kill -9 $(pgrep -f dnsproxy)
echo -e "\n# Init: Done; Subscribe Server Count: $(grep -c bin/glider $conf); FINAL Supervisord"
/usr/bin/supervisord -c $conf
