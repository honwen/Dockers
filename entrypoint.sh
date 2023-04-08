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

genClients() {
  cat <<EOF | sed '/==TOD==/d' | jq '.'
[
  $(convertClients $1 ${XRAY_REALITY_NETWORK})==TOD==
]
EOF
}

convertToList() {
  echo $1 | sed 's+[ \t]*++g; s+^+"+g; s+,*$+"+g; s+,+","+g'
}

genRoutes() {
  XRAY_REDIR_GEO="${XRAY_REDIR_GEO};${XRAY_REDIR_GEO_EXRTA}"
  [ "V${XRAY_REDIR_GEO}" = "V;" ] && return
  cat <<EOF
  "routing": {
      "domainStrategy": "IPIfNonMatch",
      "rules": [
          {
              "type": "field",
              "domain": [$(echo ${XRAY_REDIR_GEO} | sed 's+[;,]+\n+g' | sort -u | grep 'geosite' |
    sed 's+^+"+g; s+$+"+g' | tr '\n' ',' | sed 's+,$++g')],
              "outboundTag": "redir"
          },
          {
              "type": "field",
              "ip": [$(echo ${XRAY_REDIR_GEO} | sed 's+[;,]+\n+g' | sort -u | grep 'geoip' |
      sed 's+^+"+g; s+$+"+g' | tr '\n' ',' | sed 's+,$++g')],
              "outboundTag": "redir"
          }
      ]
  },
EOF
}

genOtherOutbounds() {
  [ "V${XRAY_REDIR_DST}" = "V" ] && return
  echo ','
  echo ${XRAY_REDIR_DST} | jq '.tag = "redir"'
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
        "clients": $(genClients $USERS),
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
  ],$(genRoutes)
  "outbounds": [
    {
      "protocol": "freedom",
      "tag": "direct"
    }$(genOtherOutbounds)
  ]
}
EOF
}

/usr/bin/xray run -c ${XRAY_CONFIG}
