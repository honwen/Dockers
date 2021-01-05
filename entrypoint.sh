#!/bin/bash
set -e

: ${PSK:='noPSK'}

if ! [[ $USERS ]]; then
  : ${USERNAME:=user$(cat /dev/urandom | tr -dc '0-9' | fold -w 4 | head -n 1)}
  : ${PASSWORD:=$(cat /dev/urandom | tr -dc '0-9' | fold -w 16 | head -n 1)}
  : ${USERS:=${USERNAME}:${PASSWORD}}
fi

echo "# $USERS"

# config re-generate
rm -f $(find / -name vpn_server.config) >/dev/null 2>&1
vpnserver start >/dev/null 2>&1
until vpncmd localhost /SERVER /CSV /CMD ServerInfoGet >/dev/null 2>&1; do :; done

# chiper and cert
vpncmd localhost /SERVER /CSV /CMD ServerCipherSet ECDHE-RSA-AES128-GCM-SHA256
vpncmd localhost /SERVER /CSV /CMD ServerCertRegenerate SVPN >/dev/null

# enable OpenVPN/UDP
echo '# Enable OpenVPN/UDP'
vpncmd localhost /SERVER /CSV /CMD OpenVpnEnable yes /PORTS:1194

# set DHCP/DNS
vpncmd localhost /SERVER /CSV /HUB:DEFAULT /CMD DhcpSet /START:192.168.30.100 /END:192.168.30.200 /MASK:255.255.255.0 /EXPIRE:7200 /GW:192.168.30.1 /DNS:${DNS1} /DNS2:${DNS} /DOMAIN /LOG:yes

# enable L2TP/IPsec
echo $VPN | grep -q L2TP && echo '# Enable L2TP/IPsec' &&
  vpncmd localhost /SERVER /CSV /CMD IPsecEnable /L2TP:yes /L2TPRAW:yes /ETHERIP:no /PSK:${PSK} /DEFAULTHUB:DEFAULT

# enable SstpVPN
echo $VPN | grep -q SSTP && echo '# Enable SSTP-VPN' &&
  vpncmd localhost /SERVER /CSV /CMD SstpEnable yes

# enable SecureNAT
vpncmd localhost /SERVER /CSV /HUB:DEFAULT /CMD SecureNatEnable

# disable extra ports
vpncmd localhost /SERVER /CSV /CMD ListenerDelete 992

# disable extra logs
vpncmd localhost /SERVER /CSV /HUB:DEFAULT /CMD LogDisable packet
vpncmd localhost /SERVER /CSV /HUB:DEFAULT /CMD LogDisable security

# add user
echo -n '# Creating user:'
while IFS=';' read -ra USER; do
  for i in "${USER[@]}"; do
    IFS=':' read username password <<<"$i"
    echo -n " $username"
    vpncmd localhost /SERVER /HUB:DEFAULT /CSV /CMD UserCreate $username /GROUP:none /REALNAME:none /NOTE:none
    vpncmd localhost /SERVER /HUB:DEFAULT /CSV /CMD UserPasswordSet $username /PASSWORD:$password
  done
done <<<"$USERS"

# set password for hub and server
if [ "V$DEBUG" == "V1" ]; then
  echo -e "\n# Initialized with Debug/UnSafe Mode"
else
  : ${HPW:=$(cat /dev/urandom | tr -dc 'A-Za-z0-9' | fold -w 16 | head -n 1)}
  : ${SPW:=$(cat /dev/urandom | tr -dc 'A-Za-z0-9' | fold -w 20 | head -n 1)}
  vpncmd localhost /SERVER /HUB:DEFAULT /CSV /CMD SetHubPassword ${HPW}
  vpncmd localhost /SERVER /CSV /CMD ServerPasswordSet ${SPW}
  echo -e "\n# Initialized with [HubPassword: ${HPW}] [ServerPassword: ${SPW}]"
fi

# stop and save config
vpnserver stop >/dev/null 2>&1
while pgrep vpnserver >/dev/null 2>&1; do :; done

echo '# Initialized OK'

# disable DDNS
__cfg=$(find / -name vpn_server.config)
__ll=$(sed -ne '/DDnsClient/=' $__cfg)
sed "$__ll,$((__ll + 10))s/Disabled false/Disabled true/g" -i $__cfg

vpnserver execsvc 2>>/var/log/error
