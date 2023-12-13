#!/bin/sh

prefix=$(echo ${NIC:-10.9.8.0} | sed 's/[^\.]*$//g')

echo "NET: ${prefix}0/24 --ifconfig ${prefix}1 ${prefix}2"

iptables -t nat -I POSTROUTING -s "${prefix}0/24" -j MASQUERADE
if [ "m_${MODE}" = 'm_RAW' ]; then
	openvpn --dev tun --proto tcp-server --ifconfig ${prefix}1 ${prefix}2 --keepalive 10 120

elif [ "m_${MODE}" = 'm_UDP' ]; then
	openvpn --dev tun --ifconfig ${prefix}1 ${prefix}2 --keepalive 10 120 2>&1 >/var/00_ovpn.log &

	gost -L=${GOST_ARGS}:8488 2>&1 >/var/01_ovpn-gost.log &

	udp-speeder -s -l 0.0.0.0:8499 -r 127.0.0.1:8488 2>&1 >/var/02_ovpn-udp-speeder.log

else
	# default MODE: TCP-WS
	openvpn --dev tun --proto tcp-server --ifconfig ${prefix}1 ${prefix}2 --keepalive 10 120 2>&1 >/var/00_ovpn.log &

	gost -L=${GOST_ARGS}:8488 2>&1 >/var/01_ovpn-gost.log &

	xray-plugin -server -remotePort=8488 -localAddr 0.0.0.0 -path=${WS_PATH} >/var/01_ovpn-plugin.log

fi

exit 0
