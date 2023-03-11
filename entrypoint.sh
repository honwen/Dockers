#!/bin/sh

XRAY_CONFIG=/opt/xray.json

XRAY_REALITY_PORT=${XRAY_REALITY_PORT:-443}
XRAY_REALITY_NETWORK=${XRAY_REALITY_NETWORK:-'tcp'} # h2
XRAY_REALITY_DEST=${XRAY_REALITY_DEST:-'127.0.0.1:443'}
XRAY_REALITY_SN=${XRAY_REALITY_SN:-'example.org,demo.example.com'}
XRAY_REALITY_SID=${XRAY_REALITY_SID:-'ab,abcd,123456'}
XRAY_REALITY_PRKEY=${XRAY_REALITY_PRKEY:-$(xray x25519 | sed -n 's+Private.*: *++p')}

convertClients() {
  echo $1 | sed 's_;_\n_g' | while read user; do
    uuid=$(echo -n $user | sed 's_:.*__g')
    email=$(echo -n $user | sed 's_.*:__g')
    if [ "${2:-tcp}" = "tcp" ]; then
      echo '{}' | jq ".|{id:\"$uuid\",email:\"$email\",flow:\"xtls-rprx-vision\"}"
    else
      echo '{}' | jq ".|{id:\"$uuid\",email:\"$email\"}"
    fi
    echo ','
  done
}

genJsonClients() {
  cat <<EOF | sed '/==TOD==/d' | jq '.'
[
  $(convertClients $1 ${XRAY_REALITY_NETWORK})==TOD==
]
EOF
}

convertToList() {
  echo $1 | sed 's+[ \t]*++g; s+^+"+g; s+,*$+"+g; s+,+","+g'
}

genBanCHNIP() {
  [ "V${XRAY_BANCNIP}" = "V1" ] || return
  cat <<EOF
  "routing": {
      "domainStrategy": "IPIfNonMatch",
      "rules": [
          {
              "type": "field",
              "ip": [
                  "geoip:cn"
              ],
              "outboundTag": "block"
          }
      ]
  },
EOF
}

# Xray config Init

[ -e ${XRAY_CONFIG} ] || {
  cat <<EOF | jq '.' | tee ${XRAY_CONFIG}
{
  "log": {
    "loglevel": "warning"
  },
  "inbounds": [
    {
      "port": ${XRAY_REALITY_PORT},
      "protocol": "vless",
      "settings": {
        "clients": $(genJsonClients $USERS),
        "decryption": "none"
      },
      "streamSettings": {
        "network": "${XRAY_REALITY_NETWORK}",
        "security": "reality",
        "realitySettings": {
          "dest": "${XRAY_REALITY_DEST}",
          "serverNames": [
            $(convertToList ${XRAY_REALITY_SN})
          ],
          "privateKey": "${XRAY_REALITY_PRKEY}",
          "minVersion": "1.3",
          "shortIds": [
            $(convertToList ${XRAY_REALITY_SID})
          ]
        }
      }
    }
  ],$(genBanCHNIP)
  "outbounds": [
    {
      "protocol": "freedom",
      "tag": "direct"
    },
    {
        "protocol": "blackhole",
        "tag": "block"
    }
  ]
}
EOF
}

/usr/bin/xray run -c ${XRAY_CONFIG}
