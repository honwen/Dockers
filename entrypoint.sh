#!/bin/sh

prefix=$(echo ${NIC:-10.9.8.0} | sed 's/[^\.]*$//g')

echo "NET: ${prefix}0/24 --ifconfig ${prefix}1 ${prefix}2"

iptables -t nat -I POSTROUTING -s "${prefix}0/24" -j MASQUERADE

openvpn --dev tun --proto tcp-server --ifconfig ${prefix}1 ${prefix}2 2>&1 > /var/ovpn-tcp.log &

ss-aio -s ss://${SS_ARGS}@:8488 2>&1 > /var/ovpn-ss.log

