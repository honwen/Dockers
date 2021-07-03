#!/bin/sh
#
# Docker script to configure and start an IPsec VPN server
#
# DO NOT RUN THIS SCRIPT ON YOUR PC OR MAC! THIS IS ONLY MEANT TO BE RUN
# IN A DOCKER CONTAINER!
#

exiterr() {
  echo "Error: $1" >&2
  exit 1
}
nospaces() { printf '%s' "$1" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//'; }
noquotes() { printf '%s' "$1" | sed -e 's/^"\(.*\)"$/\1/' -e "s/^'\(.*\)'$/\1/"; }

check_ip() {
  IP_REGEX='^(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])$'
  printf '%s' "$1" | tr -d '\n' | grep -Eq "$IP_REGEX"
}

resolveip() {
  ping -q -c 1 -s 0 -W 1 -w 1 $1 2>/dev/null | sed '1{s/[^(]*(//; s/).*//;q}' | sed 's/[^(]*(//; s/).*//'
}

if [ ! -f "/.dockerenv" ]; then
  exiterr "This script ONLY runs in a Docker container."
fi

if ip link add dummy0 type dummy 2>&1 | grep -q "not permitted"; then
  cat 1>&2 <<'EOF'
Error: This Docker image must be run in privileged mode.

For detailed instructions, please visit:
https://github.com/hwdsl2/docker-ipsec-vpn-server

EOF
  exit 1
fi
ip link delete dummy0 >/dev/null 2>&1

# Remove whitespace and quotes around VPN variables, if any
VPN_IPSEC_PSK="$(nospaces "$VPN_IPSEC_PSK")"
VPN_IPSEC_PSK="$(noquotes "$VPN_IPSEC_PSK")"
VPN_USER="$(nospaces "$VPN_USER")"
VPN_USER="$(noquotes "$VPN_USER")"
VPN_PASSWORD="$(nospaces "$VPN_PASSWORD")"
VPN_PASSWORD="$(noquotes "$VPN_PASSWORD")"
VPN_SERVER_ADDR="$(nospaces "$VPN_SERVER_ADDR")"
VPN_SERVER_ADDR="$(noquotes "$VPN_SERVER_ADDR")"

if [ -z "$VPN_IPSEC_PSK" ] || [ -z "$VPN_USER" ] || [ -z "$VPN_PASSWORD" ] || [ -z "$VPN_SERVER_ADDR" ]; then
  exiterr "All VPN credentials must be specified. Edit your 'env' file and re-enter them."
fi

if printf '%s' "$VPN_IPSEC_PSK $VPN_USER $VPN_PASSWORD $VPN_SERVER_ADDR" | LC_ALL=C grep -q '[^ -~]\+'; then
  exiterr "VPN credentials must not contain non-ASCII characters."
fi

case "$VPN_IPSEC_PSK $VPN_USER $VPN_PASSWORD $VPN_SERVER_ADDR" in
*[\\\"\']*)
  exiterr "VPN credentials must not contain these special characters: \\ \" '"
  ;;
esac

echo
echo 'Trying to auto discover IP of this server...'

# of this server in your 'env' file, as variable 'VPN_SERVER_ADDR'.
PUBLIC_IP=${VPN_SERVER_ADDR:-''}
check_ip $PUBLIC_IP || PUBLIC_IP=$(resolveip ${VPN_SERVER_ADDR})
check_ip $PUBLIC_IP || exiterr 'CAN NOT Resolve VPN_SERVER_ADDR'
LOCAL_GW_NET=${VPN_LOCAL_GW_NET:-''}

# Create Stronswan config
cat >/etc/ipsec.conf <<EOF
# ipsec.conf - strongSwan IPsec configuration file

# basic configuration

config setup
  # strictcrlpolicy=yes
  # uniqueids = no

# Add connections here.

# Sample VPN connections

conn %default
  ikelifetime=60m
  keylife=20m
  rekeymargin=3m
  keyingtries=1
  keyexchange=ikev1
  authby=secret
  forceencaps=yes
  ike=aes128-sha1-modp1024,3des-sha1-modp1024!
  esp=aes128-sha1-modp1024,3des-sha1-modp1024!

conn myvpn
  keyexchange=ikev1
  left=%defaultroute
  auto=add
  authby=secret
  type=transport
  leftprotoport=17/1701
  rightprotoport=17/1701
  right=$PUBLIC_IP
  rightid=%any
EOF

cat >/etc/ipsec.secrets <<EOF
: PSK "$VPN_IPSEC_PSK"
EOF

chmod 600 /etc/ipsec.secrets

# Create xl2tpd config
cat >/etc/xl2tpd/xl2tpd.conf <<EOF
[lac myvpn]
lns = $PUBLIC_IP
ppp debug = yes
pppoptfile = /etc/ppp/options.l2tpd.client
length bit = yes
EOF

# Set xl2tpd options
cat >/etc/ppp/options.l2tpd.client <<EOF
logfile /var/log/xl2tpd.log
ipcp-accept-local
ipcp-accept-remote
refuse-eap
require-chap
noccp
noauth
mtu 1280
mru 1280
noipdefault
defaultroute
usepeerdns
connect-delay 5000
name $VPN_USER
password $VPN_PASSWORD
EOF

chmod 600 /etc/ppp/options.l2tpd.client

cat <<EOF

================================================

IPsec VPN client is now ready for use!

Connect to the VPN with these details:

Server IP: $PUBLIC_IP
IPsec PSK: $VPN_IPSEC_PSK
Username: $VPN_USER
Password: $VPN_PASSWORD


Important notes:   https://git.io/vpnnotes2
Setup VPN clients: https://git.io/vpnclients

================================================

EOF

#Create xl2tpd control file:
mkdir -p /var/run/xl2tpd
touch /var/run/xl2tpd/l2tp-control

service rsyslog restart

#Restart services:
service ipsec restart
service xl2tpd restart

#Start the IPsec connection:
ipsec up myvpn

#Start the L2TP connection:
echo "c myvpn" >/var/run/xl2tpd/l2tp-control

#Setup routes
GW="$(ip route | grep default | grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b")"
[ -z "$LOCAL_GW_NET" ] || ip r a $LOCAL_GW_NET via $GW
ip r a $PUBLIC_IP via $GW

for _ in $(seq ${RETRY_TIMES:-30}); do
  sleep 1
  ip a show ppp0 2>/dev/null | grep -q ',UP,' && break
  echo "$(date): [ WaitFor Ready: link/ppp ]"
done
ip a show ppp0 2>/dev/null | grep -q ',UP,' || exiterr 'L2TP/IPSec Connect Timeout'
echo "$(date): [ Ready: link/ppp ]"
ip a show ppp0

route add default dev ppp0
# ip r a default dev ppp0

sort -u /etc/ppp/resolv.conf >/etc/resolv.conf

gost ${GOST_ARGS}
# exec /bin/bash
