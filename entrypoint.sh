#!/bin/sh

set -e

CONFIG=${CONFIG:-/warp/config.json}
mkdir -p $(dirname ${CONFIG})

# config Init

echo >&2 "# Info: Config Init"

grep -q 'endpoints' "${CONFIG}" 2>/dev/null || {
  echo >&2 "# Info: Config Renew"

  source='/tmp/info.txt'
  $(which warp-reg) | tee ${source}
  local_v4=$(sed -n 's+^v4: *++p' ${source})
  local_v6=$(sed -n 's+^v6: *++p' ${source})
  reserved=$(sed -n 's+^reserved: *++p' ${source})
  private_key=$(sed -n 's+^private_key: *++p' ${source})
  peer_public_key=$(sed -n 's+^public_key: *++p' ${source})

  cat <<-EOF | yq -o=json '.' | tee ${CONFIG}
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
        "path": "/dns-query",
        "tls": {
          "record_fragment": true
        }
      }
    ],
    "final": "google-doh",
    "strategy": "ipv4_only"
  },
  "inbounds": [
    {
      "listen": "${LISTEN:-0.0.0.0}",
      "listen_port": ${LISTEN_PORT:-2000},
      "udp_timeout": 300,
      "type": "socks"
    }$(
    [ "V${EXTRA_LISTEN}" != "V" ] && {
      echo ','
      cat <<-EEE
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
            "enable_ip_scanner": ${WARP_AUTO_IP:-true},
            "enable_port_scanner": ${WARP_AUTO_PORT:-false},
            "cidrs": [
              "162.159.192.0/24",
              "188.114.96.0/24"
            ]
          },
          "warp_noise": {
            "enable": true,
            "packet_count": "10-20",
            "packet_delay": "1-5"
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
}

yq -o=json . ${CONFIG} >&2

echo >&2 "# Info: Config Done"
