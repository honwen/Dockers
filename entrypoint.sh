#!/bin/sh

XRAY_CONFIG=/opt/xray.json

XRAY_LOGLEVEL=${XRAY_LOGLEVEL:-'warning'}
XRAY_REALITY_PORT=${XRAY_REALITY_PORT:-443}
XRAY_REALITY_NETWORK=${XRAY_REALITY_NETWORK:-'raw'} # h2
XRAY_REALITY_DEST=${XRAY_REALITY_DEST:-'127.0.0.1:443'}
XRAY_REALITY_PATH=${XRAY_REALITY_PATH:-'/x'}
XRAY_REALITY_SN=${XRAY_REALITY_SN:-'example.org,demo.example.com'}
XRAY_REALITY_SID=${XRAY_REALITY_SID:-'ab,abcd,123456'}
XRAY_REALITY_PRKEY=${XRAY_REALITY_PRKEY:-$(xray x25519 | sed -n 's+Private.*: *++p')}

convertClients() {
  echo $1 | sed 's_;_\n_g' | while read user; do
    uuid=$(echo -n $user | sed 's_:.*__g')
    email=$(echo -n $user | sed 's_.*:__g')
    if [ "${2:-raw}" = "raw" ]; then
      yq -n -o=json ".id=\"$uuid\" | .email=\"$email\" | .flow=\"xtls-rprx-vision\""
    else
      yq -n -o=json ".id=\"$uuid\" | .email=\"$email@$2\""
    fi
    echo ','
  done
}

genClients() {
  cat <<EOF | sed '/==TOD==/d' | yq -o=json '.'
[
  $(convertClients $1 $2)==TOD==
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
  echo -n ','
}

genRouting() {
  [ "V${XRAY_REDIR_GEO_EX}" != "V" ] && {
    [ "V${XRAY_REDIR_GEO}" = "V" ] && XRAY_REDIR_GEO="${XRAY_REDIR_GEO_EX}" || XRAY_REDIR_GEO="${XRAY_REDIR_GEO};${XRAY_REDIR_GEO_EX}"
  }
  [ "V${XRAY_REDIR_GEO}" = "V" -a "V${XRAY_REDIR_GEO_EXTRA}" = "V" ] && return
  echo -n '  "routing": '
  cat <<EOF | sed 's+,_LIST_END_+]+g' | yq -o=json '.'
  {
      "domainStrategy": "IPIfNonMatch",
      "rules": [
        {
          "type": "field",
          "network": "udp",
          "port": 443,
          "outboundTag": "block"
        },
        {
          "type": "field",
          "protocol": [
            "bittorrent"
          ],
          "outboundTag": "block"
        },
$(
    genRoutes ${XRAY_DIRECT_GEO:-''} 'direct'
    genRoutes ${XRAY_REDIR_GEO_EXTRA:-''} 'extra'
    genRoutes ${XRAY_REDIR_GEO:-''}
  )_LIST_END_
  }
EOF
  echo -n ","
}

genOtherOutbounds() {
  [ "V${XRAY_REDIR_DST}" = "V" ] && return
  [ "V${XRAY_REDIR_GEO_EXTRA}" != "V" ] && {
    echo ','
    echo ${XRAY_REDIR_DST_EXTRA:-${XRAY_REDIR_DST}} | yq -o=json '.tag="extra"'
  }
  echo ','
  echo ${XRAY_REDIR_DST} | yq -o=json '.tag="redir"'
}

# Xray config Init
# refer: https://github.com/lxhao61/integrated-examples/tree/main/Xray(M+K)
[ -e ${XRAY_CONFIG} ] || {
  cat <<EOF | yq -o=json '.' | tee ${XRAY_CONFIG}
{
  "log": {
    "loglevel": "${XRAY_LOGLEVEL}"
  },
  "inbounds": [
  $([ "V${SOCKS_ADDR}" != "V" ] && {
    echo "$SOCKS_ADDR" | sed 's+[,; ]+\n+g' | sort -u | while read it; do
      [ "V${it}" = "V" ] && continue
      cat <<FFF | yq -o=json '.'
    {
      "protocol": "socks",
      "port": ${SOCKS_PORT:-1080},
      "listen": "${it}",
      "sniffing": {
        "enabled": true,
        "destOverride": ["http", "tls", "quic"]
      },
      "settings": {
        "udp": true
      }
    }
FFF
      echo ','
    done
  })
    {
      "port": ${XRAY_REALITY_PORT},
      "protocol": "vless",
      "sniffing": {
        "enabled": true,
        "destOverride": ["http", "tls", "quic"]
      },
      "settings": {
        "clients": $(genClients $USERS ${XRAY_REALITY_NETWORK}),
        "fallbacks": [
          {
            "dest": "@xhttp.sock",
            "xver": 1
          }
        ],
        "decryption": "none"
      },
      "streamSettings": {
        "network": "${XRAY_REALITY_NETWORK}",
        "security": "reality",
        "realitySettings": {
          "target": "${XRAY_REALITY_DEST}",
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
    },
    {
      "listen": "@xhttp.sock",
      "protocol": "vless",
      "sniffing": {
        "enabled": true,
        "destOverride": ["http", "tls", "quic"]
      },
      "settings": {
        "clients": $(genClients $USERS 'xhttp'),
        "decryption": "none"
      },
      "streamSettings": {
        "network": "xhttp",
        "xhttpSettings": {
          "path": "${XRAY_REALITY_PATH}"
        },
        "sockopt": {
          "acceptProxyProtocol": true
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
