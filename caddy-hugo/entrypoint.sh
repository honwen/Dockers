#!/bin/sh

# ENV DOMAIN=example.com

EXTRA_DOMAINS="$(echo ${EXTRA_DOMAINS} | grep -v 'example.com' | sed 's;[,;]; ;g')"

echo "#DOMAIN: ${DOMAIN} ${EXTRA_DOMAINS}"
echo '=================================================='
echo

# defualt port 1313
/usr/bin/hugo server -s=/www/${DOMAIN} --baseUrl=${DOMAIN} --appendPort=false &

# Caddy Init
cp 404.html /var/tmp/
host_ip=$(route | awk '/^default/ { print $2 }')
cat << EOF > /etc/caddy/Caddyfile
:80 {
  redir {
    if {path} not /404.html
    / /404.html
  }
}

$( if echo ${EXTRA_DOMAINS} | grep -q '.'; then
cat << FOO
${EXTRA_DOMAINS} {
  redir {scheme}://${DOMAIN}{uri}
}
FOO
fi )

${DOMAIN} {
  tls ssl@${DOMAIN}
  timeouts 30s
  gzip
  proxy ${WS_PREFIX} http://${host_ip}:8888 {
    websocket
  }

$( for i in `seq 0 9`; do
cat << FOO
  proxy ${WS_PREFIX}${i} http://${host_ip}:777${i} {
    websocket
  }
FOO
done )

  proxy / http://localhost:1313 {
    except /404.html
    except ${WS_PREFIX}.*
  }
}
EOF

# defualt port 80 443
export CADDYPATH=/etc/ssl/caddy
/usr/bin/caddy -log stdout -agree=true -conf=/etc/caddy/Caddyfile -root=/var/tmp
