#!/bin/sh

set -e

mkdir -p /warp
CONFIG=/warp/config.json

# config Init

echo >&2 "# Info: Config Init"

[ -e ${CONFIG} ] || {
  cd $(dirname ${CONFIG})
  warp-go --register
  warp-go -export-singbox $(basename ${CONFIG})
}

echo "$(jq ".inbounds[0].listen = \"${LISTEN:-0.0.0.0}\"" ${CONFIG})" >${CONFIG}

jq . ${CONFIG} >&2

echo >&2 "# Info: Config Done"

echo >&2 "# Info: SING-BOX VERSION"
$(which sing-box) version

$(which sing-box) run -c ${CONFIG}
