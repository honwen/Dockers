#!/bin/sh

CADDY_HOME=${CADDY_HOME:-/opt/caddy}
CADDY_DATAROOT=${CADDY_DATAROOT:-/var/run/caddy}
EXTRA_DOMAINS="$(echo ${EXTRA_DOMAINS} | grep -v 'example.com' | sed 's;[,;]; ;g')"
NOSSL=${NOSSL:-0}
ACME_CA=${ACME_CA:-https://acme.zerossl.com/v2/DV90}

# MKDIR Init
mkdir -p /etc/caddy /data/gitea $CADDY_DATAROOT $CADDY_HOME

echo "#DOMAIN: ${DOMAIN} ${EXTRA_DOMAINS}"
echo '=================================================='
echo

# Gitea Init
[ -f /data/gitea/app.ini ] || {
  cat <<EOF | grep -v 'UrGitTea' >/data/gitea/app.ini
APP_NAME = ${APP_NAME}
RUN_USER = root
RUN_MODE = prod
I_AM_BEING_UNSAFE_RUNNING_AS_ROOT = true

[server]
HTTP_PORT    = 8080
DOMAIN       = ${DOMAIN}
SSH_DOMAIN   = ${DOMAIN}
ROOT_URL     = https://${DOMAIN}/
DISABLE_SSH  = true
EOF

  [ "V$FAKE_MODE" == "Von" ] && cat <<EOF >>/data/gitea/app.ini
LFS_START_SERVER = true
LFS_CONTENT_PATH = /data/lfs
LFS_JWT_SECRET   = $(dd if=/dev/urandom bs=32 count=1 status=none | base64)
OFFLINE_MODE     = false

[security]
INTERNAL_TOKEN = $(dd if=/dev/urandom bs=24 count=1 status=none | base64).$(dd if=/dev/urandom bs=48 count=1 status=none | base64)
INSTALL_LOCK   = true
SECRET_KEY     = $(dd if=/dev/urandom bs=48 count=1 status=none | base64)

[database]
DB_TYPE  = sqlite3
HOST     = 127.0.0.1:3306
NAME     = gitea
USER     = gitea
PASSWD   = 
SSL_MODE = disable
PATH     = /data/gitea.db

[repository]
ROOT = /data/gitea/gitea-repositories

[mailer]
ENABLED = false

[service]
REGISTER_EMAIL_CONFIRM            = false
ENABLE_NOTIFY_MAIL                = false
DISABLE_REGISTRATION              = true
ALLOW_ONLY_EXTERNAL_REGISTRATION  = false
ENABLE_CAPTCHA                    = false
REQUIRE_SIGNIN_VIEW               = false
DEFAULT_KEEP_EMAIL_PRIVATE        = true
DEFAULT_ALLOW_CREATE_ORGANIZATION = true
DEFAULT_ENABLE_TIMETRACKING       = true
NO_REPLY_ADDRESS                  = noreply.example.org

[picture]
DISABLE_GRAVATAR        = false
ENABLE_FEDERATED_AVATAR = true

[openid]
ENABLE_OPENID_SIGNIN = false
ENABLE_OPENID_SIGNUP = false

[session]
PROVIDER = file

[log]
MODE      = file
LEVEL     = Info
ROOT_PATH = /data/log

[oauth2]
JWT_SECRET = $(dd if=/dev/urandom bs=32 count=1 status=none | base64)
EOF
}
/usr/bin/gitea web -c /data/gitea/app.ini >/dev/null 2>&1 &

# Caddy Init
cp -fL 404.html CADDY_DATAROOT
host_ip=$(route -n | awk '/^0.0.0.0/ { print $2 }')

web_config() {
  echo -n ' '
  cat <<EOF
{
  root CADDY_DATAROOT
  encode gzip zstd

  reverse_proxy ${WS_PREFIX} http://_LOCALHOST_:8888

$(for i in $(seq 0 9); do
    cat <<FOO
  reverse_proxy ${WS_PREFIX}${i} http://_LOCALHOST_:777${i}
FOO
  done)

$(echo "${EXTRA_PROXYS}" | tr ',' '\n' | grep -v 'example.com' | while read it; do
    echo $it | grep -q '.' || continue
    cat <<FOO
  reverse_proxy ${it}
FOO
  done)

  reverse_proxy http://localhost:8080 {
      @error status 500 502 404
      handle_response @error {
        rewrite * /404.html
        file_server
      }
  }
}
EOF
}

cat <<EOF | sed "s+_LOCALHOST_+${host_ip}+g" >$CADDY_HOME/Caddyfile
{
    admin off
    acme_ca ${ACME_CA}
    email   acme@${DOMAIN}
    servers {
        protocols h1 h2
    }
}

:80 {
  root CADDY_DATAROOT
  file_server
  handle_errors {
      @404 {
          expression {http.error.status_code} == 404
      }
      rewrite @404 /404.html
      file_server
  }
}

$(if echo ${EXTRA_DOMAINS} | grep -q '.'; then
  cat <<FOO
${EXTRA_DOMAINS} {
  redir {scheme}://${DOMAIN}{uri}
}
FOO
fi)

$(if [ "V$NOSSL" == "V0" ]; then
  echo -n ${DOMAIN}
  web_config
else
  echo -n http://${DOMAIN}
  web_config
fi)
EOF

# defualt port 80 443
export HOME="$CADDY_HOME"
caddy fmt -w "$CADDY_HOME/Caddyfile"
cat $CADDY_HOME/Caddyfile >&2

/usr/bin/caddy run --adapter=caddyfile --config=$CADDY_HOME/Caddyfile
