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
  echo "$1" | sed 's+[ \t]*++g; s+^+"+g; s+,*$+"+g; s+,+","+g'
}

linesToList() {
  [ "V$1" = "V" ] && return
  echo "$1" | sed 's+^+"+g; s+$+"+g' | tr '\n' ',' | sed 's+,$++g'
}

genRoutes() {
  [ "V${1}" = "V" ] && return
  geosite=$(linesToList "$(echo ${1} | sed 's+[;,]+\n+g' | sort -u | grep -e '^\(geosite\|regexp\):')")
  domain=$(linesToList "$(echo ${1} | sed 's+[;,]+\n+g' | sort -u | grep -ve '^\(geo[a-z]*\|regexp\):' | grep '[a-z]$')")
  [ "V${domain}" != "V" ] && {
    [ "V${geosite}" = "V" ] && geosite="${domain}" || geosite="${geosite},${domain}"
  }

  geoip=$(linesToList "$(echo ${1} | sed 's+[;,]+\n+g' | sort -u | grep 'geoip')")
  ip=$(linesToList "$(echo ${1} | sed 's+[;,]+\n+g' | sort -u | grep -ve '^\(geo[a-z]*\|regexp\):' | grep -v '[a-z]$')")
  [ "V${ip}" != "V" ] && {
    [ "V${geoip}" = "V" ] && geoip="${ip}" || geoip="${geoip},${ip}"
  }

  [ "V${geosite}" != "V" ] && cat <<EOF
          {
              "type": "field",
              "domain": [${geosite}],
              "outboundTag": "${2:-redir}"
          }
EOF
  [ "V${geosite}" != "V" -a "V${geoip}" != "V" ] && echo ','
  [ "V${geoip}" != "V" ] && cat <<EOF
          {
              "type": "field",
              "ip": [${geoip}],
              "outboundTag": "${2:-redir}"
          }
EOF
}

genRouting() {
  [ "V${XRAY_REDIR_GEO_EX}" != "V" ] && {
    [ "V${XRAY_REDIR_GEO}" = "V" ] && XRAY_REDIR_GEO="${XRAY_REDIR_GEO_EX}" || XRAY_REDIR_GEO="${XRAY_REDIR_GEO};${XRAY_REDIR_GEO_EX}"
  }
  [ "V${XRAY_REDIR_GEO}" = "V" -a "V${XRAY_REDIR_GEO_EXTRA}" = "V" ] && return
  cat <<EOF
  "routing": {
      "domainStrategy": "IPIfNonMatch",
      "rules": [$(
    genRoutes ${XRAY_REDIR_GEO_EXTRA:-''} 'extra'
    [ "V${XRAY_REDIR_GEO}" != "V" -a "V${XRAY_REDIR_GEO_EXTRA}" != "V" ] && echo ','
    genRoutes ${XRAY_REDIR_GEO:-''}
  )
      ]
  },
EOF
}

genOtherOutbounds() {
  [ "V${XRAY_REDIR_DST}" = "V" ] && return
  [ "V${XRAY_REDIR_GEO_EXTRA}" != "V" ] && {
    echo ','
    echo ${XRAY_REDIR_DST_EXTRA:-${XRAY_REDIR_DST}} | jq '.tag = "extra"'
  }
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
      "sniffing": {
        "enabled": true,
        "destOverride": ["http", "tls"]
      },
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
  ],$(genRouting)
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
