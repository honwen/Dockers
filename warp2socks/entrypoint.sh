#!/bin/sh

set -e

CONFIG=${CONFIG:-/warp/config.json}
mkdir -p $(dirname ${CONFIG})

grep -q 'endpoints' "${CONFIG}" || {
  echo >&2 "# Info: Config Clean"
  rm -f ${CONFIG}
}

if grep -q 'endpoints' "${CONFIG}" 2>/dev/null; then
  local_v4="$(yq -roy '.endpoints[0].address[0]' ${CONFIG} | sed 's+/.*++g')"
  local_v6="$(yq -roy '.endpoints[0].address[1]' ${CONFIG} | sed 's+/.*++g')"
  reserved="[$(yq -roc '.endpoints[0].peers[0].reserved' ${CONFIG})]"
  private_key="$(yq -roj '.endpoints[0].private_key' ${CONFIG})"
  peer_public_key="$(yq -roc '.endpoints[0].peers[0].public_key' ${CONFIG})"
else
  source='/tmp/info.txt'
  $(which warp-reg) | tee ${source}
  local_v4="$(sed -n 's+^v4: *++p' ${source})"
  local_v6="$(sed -n 's+^v6: *++p' ${source})"
  reserved="$(sed -n 's+^reserved: *++p' ${source})"
  private_key="$(sed -n 's+^private_key: *++p' ${source})"
  peer_public_key="$(sed -n 's+^public_key: *++p' ${source})"
fi

# https://github.com/kyochikuto/sing-box-plus/tree/main/examples
echo >&2 "# Info: Config Generated"

cat <<EOF | yq -oj . >${CONFIG}
{
  "log": {
    "disabled": false,
    "level": "debug",
    "timestamp": true
  },
  "dns": {
    "servers": [
      {
        "tag": "local-dns",
        "type": "local"
      },
      {
        "tag": "google-doh",
        "type": "https",
        "server": "8.8.8.8",
        "server_port": 443,
        "path": "/dns-query"
      }
    ],
    "final": "google-doh",
    "strategy": "ipv4_only"
  },
  "route": {
    "default_domain_resolver": {
      "server": "google-doh",
      "rewrite_ttl": 600,
    }
  },
  "inbounds": [
    {
      "listen": "${LISTEN:-0.0.0.0}",
      "listen_port": ${LISTEN_PORT:-2000},
      "udp_timeout": 300,
      "type": "socks"
    }$(
  [ "V${EXTRA_LISTEN}" != "V" ] && {
    cat <<EEE
    ,
    {
      "listen": "${EXTRA_LISTEN:-0.0.0.0}",
      "listen_port": ${EXTRA_LISTEN_PORT:-${LISTEN_PORT:-2000}},
      "udp_timeout": 300,
      "type": "socks"
    }
EEE
  }
)
  ],
  "endpoints": [
    {
      "type": "wireguard",
      "tag": "warp-out",
      "system": false,
      "address": [
        "${local_v4}/32",
        "${local_v6}/128"
      ],
      "private_key": "${private_key}",
      "peers": [
        {
          "address": "${server:-engage.cloudflareclient.com}",
          "port": 2408,
      		"public_key": "${peer_public_key:-bmXOC+F1FxEMF9dyiK2H5/1SUtzH0JuVo51h2wPfgyo=}",
          "allowed_ips": ["0.0.0.0/0"],
          "reserved": ${reserved},
          "warp_scanner": {
            "enable_ip_scanner": ${WARP_AUTO_IP:-false},
            "enable_port_scanner": ${WARP_AUTO_PORT:-false},
            "cidrs": [
              "162.159.192.0/24",
              "188.114.96.0/24"
            ]
          },
          "warp_noise": {
            "enable": ${WARP_NOISE:-true},
            "packet_count": "8-24",
            "packet_delay": "1-4"
          }
        }
      ],
      "mtu": 1280
    }
  ],
  "outbounds": [
    {
      "type": "urltest",
      "tag": "auto",
      "outbounds": [
        "warp-out"
      ],
      "url": "http://cp.cloudflare.com"
    }
  ]
}
EOF

yq -oj . ${CONFIG} >&2

echo >&2 "# Info: Config Done"
