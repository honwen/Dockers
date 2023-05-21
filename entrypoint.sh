#!/bin/sh

set -e

CONFIG=${CONFIG:-/warp/config.json}
mkdir -p $(dirname ${CONFIG})

# config Init

echo >&2 "# Info: Config Init"

[ -e ${CONFIG} ] || {
  echo >&2 "# Info: Config Renew"

  source='/tmp/info.txt'
  $(which warp-reg) | tee ${source}
  local_v4=$(sed -n 's+^v4: *++p' ${source})
  local_v6=$(sed -n 's+^v6: *++p' ${source})
  reserved=$(sed -n 's+^reserved: *++p' ${source})
  private_key=$(sed -n 's+^private_key: *++p' ${source})
  peer_public_key=$(sed -n 's+^public_key: *++p' ${source})

  cat <<-EOF | jq '.' | tee ${CONFIG}
{
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
  "outbounds": [
    {
      "type": "wireguard",
      "server": "${server:-engage.cloudflareclient.com}",
      "server_port": ${server_port:-2408},
      "local_address": [
        "${local_v4}/32",
        "${local_v6}/128"
      ],
      "private_key": "${private_key}",
      "peer_public_key": "${peer_public_key:-bmXOC+F1FxEMF9dyiK2H5/1SUtzH0JuVo51h2wPfgyo=}",
      "reserved": ${reserved},
      "mtu": 1280
    }
  ]
}
EOF
}

jq . ${CONFIG} >&2

echo >&2 "# Info: Config Done"

# $(which sing-box) format -c ${CONFIG}
