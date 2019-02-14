#!/bin/bash
set -e

: ${PSK:='noPSK'}

if ! [[ $USERS ]]; then
  : ${USERNAME:=user$(cat /dev/urandom | tr -dc '0-9' | fold -w 4 | head -n 1)}
  : ${PASSWORD:=$(cat /dev/urandom | tr -dc '0-9' | fold -w 16 | head -n 1)}
  : ${USERS:=${USERNAME}:${PASSWORD}}
fi

echo "# $USERS"

# config generate
/etc/init.d/softether-vpnserver start >/dev/null 2>&1
until vpncmd localhost /SERVER /CSV /CMD ServerInfoGet >/dev/null 2>&1 ; do :; done
/etc/init.d/softether-vpnserver stop >/dev/null 2>&1

# disable DDNS
ll=$(sed -ne '/DDnsClient/=' /usr/libexec/softether/vpnserver/vpn_server.config)
sed "$ll,$((ll + 10))s/Disabled false/Disabled true/g" -i /usr/libexec/softether/vpnserver/vpn_server.config

# offical start server
/etc/init.d/softether-vpnserver start >/dev/null 2>&1
until vpncmd localhost /SERVER /CSV /CMD ServerInfoGet >/dev/null 2>&1 ; do :; done

# chiper and cert
vpncmd localhost /SERVER /CSV /CMD ServerCipherSet TLS_AES_128_GCM_SHA256
vpncmd localhost /SERVER /CSV /CMD ServerCertRegenerate SVPN >/dev/null

# enable L2TP_IPsec
vpncmd localhost /SERVER /CSV /CMD IPsecEnable /L2TP:yes /L2TPRAW:yes /ETHERIP:no /PSK:${PSK} /DEFAULTHUB:DEFAULT

# enable OpenVPN
vpncmd localhost /SERVER /CSV /CMD OpenVpnEnable yes /PORTS:1194

# enable SstpVPN
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
    IFS=':' read username password <<< "$i"
    echo -n " $username"
    vpncmd localhost /SERVER /HUB:DEFAULT /CSV /CMD UserCreate $username /GROUP:none /REALNAME:none /NOTE:none
    vpncmd localhost /SERVER /HUB:DEFAULT /CSV /CMD UserPasswordSet $username /PASSWORD:$password
  done
done <<< "$USERS"

# set password for hub and server
if [ "V$DEBUG" == "V1" ]; then
  echo -e "\n# Initialized with Debug Mode"
else
  : ${HPW:=$(cat /dev/urandom | tr -dc 'A-Za-z0-9' | fold -w 16 | head -n 1)}
  : ${SPW:=$(cat /dev/urandom | tr -dc 'A-Za-z0-9' | fold -w 20 | head -n 1)}
  vpncmd localhost /SERVER /HUB:DEFAULT /CSV /CMD SetHubPassword ${HPW}
  vpncmd localhost /SERVER /CSV /CMD ServerPasswordSet ${SPW}
  echo -e "\n# Initialized with [HubPassword: ${HPW}] [ServerPassword: ${SPW}]"
fi


## SPEEDER
ss-aio -s ss://${SS_ARGS:-AEAD_AES_128_GCM:ssPWD}@:8488 2>&1 > /var/01_ss.log &
udp-speeder -s -l 0.0.0.0:8499 -r 127.0.0.1:8488 2>&1 > /var/02_udp-speeder.log
