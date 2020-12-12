#!/bin/sh

XRAY_CONFIG=/etc/xray.d/server.json
XRAY_SSLPORT=443
XRAY_FALLBACK=80
ACME_PREFIX=${ACME_PREFIX:-/etc/ssl/caddy/acme/acme-v02.api.letsencrypt.org/sites}
ACME_DOMAIN=${ACME_DOMAIN:-example.org}

# Xray config Init
cat <<EOF | sed '/DELETE/d' | jq '.' | tee $XRAY_CONFIG
{
  "log": {
    "loglevel": "warning"
  },
  "inbounds": [
    {
      "port": ${XRAY_SSLPORT},
      "protocol": "vless",
      "settings": {
        "clients": [
$(echo $USERS | sed 's_;_\n_g' | while read user; do
uuid=$(echo -n $user | sed 's_:.*__g')
email=$(echo -n $user | sed 's_.*:__g')
echo '{}' | jq ".|{id:\"$uuid\",email:\"$email\",flow:\"xtls-rprx-direct\"}"
echo ','
done
)====TO-DELETE====
        ],
        "decryption": "none",
        "fallbacks": [
          {
            "dest": ${XRAY_FALLBACK}
          }
        ]
      },
      "streamSettings": {
        "network": "tcp",
        "security": "xtls",
        "xtlsSettings": {
          "alpn": ["http/1.1"],
          "certificates": [
            {
              "certificateFile": "${ACME_PREFIX}/${ACME_DOMAIN}/${ACME_DOMAIN}.crt",
              "keyFile": "${ACME_PREFIX}/${ACME_DOMAIN}/${ACME_DOMAIN}.key"
            }
          ]
        }
      }
    }
  ],
  "outbounds": [
    {
      "protocol": "freedom"
    }
  ]
}
EOF

/usr/bin/xray run -c $XRAY_CONFIG
