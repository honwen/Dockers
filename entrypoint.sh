#!/bin/sh

CONFIG=/var/hysteria.json
QUIC_PORT=${QUIC_PORT:-443}
ACME_PREFIX=${ACME_PREFIX:-/etc/ssl/caddy/acme/acme-v02.api.letsencrypt.org/sites}
ACME_DOMAIN=${ACME_DOMAIN:-example.org}

# Xray config Init
cat <<EOF | jq '.' | tee $CONFIG
{
  "listen": ":${QUIC_PORT}",
  "cert": "${ACME_PREFIX}/${ACME_DOMAIN}/${ACME_DOMAIN}.crt",
  "key": "${ACME_PREFIX}/${ACME_DOMAIN}/${ACME_DOMAIN}.key",
  "down_mbps": ${DOWN_MBPS},
  "up_mbps": ${UP_MBPS},
  "obfs": "${OBFS_KEY}"
}
EOF

ARGS=''
echo ${MODE} | grep -q 'client' && {
  ARGS='-socks5-addr :1080 -http-addr :8080'
}

/usr/bin/hysteria proxy ${MODE} -config ${CONFIG} ${ARGS}
