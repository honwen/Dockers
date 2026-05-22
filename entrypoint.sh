#!/bin/sh

SQ_RUNDIR=/var/run/shadowquic
SQ_CONFIG=/opt/shadowquic.yaml

SQ_LOGLEVEL=${SQ_LOGLEVEL:-'trace'} # `trace`, `debug`, `info`, `warn`, `error`
SQ_BIND_PORT=${SQ_BIND_PORT:-':443'}

echo $SQ_BIND_PORT | grep -qE '^:' && SQ_BIND_PORT="0.0.0.0$SQ_BIND_PORT"

cat <<EOF | yq -Poy | tee $SQ_CONFIG
inbound:
  type: shadowquic
  bind-addr: $SQ_BIND_PORT
  users:
  - username: "87654321"
    password: "12345678"
  - username: "88888888"
    password: "99999999"
  jls-upstream:
     addr: "cloudflare.com:443"
  alpn: ["h3"]
  congestion-control: bbr
  zero-rtt: true
  gso: true
outbound:
  type: direct
  dns-strategy: prefer-ipv4
log-level: $SQ_LOGLEVEL
EOF

set -e
mkdir -p $SQ_RUNDIR
cd $SQ_RUNDIR
/usr/bin/shadowquic -c ${SQ_CONFIG}
