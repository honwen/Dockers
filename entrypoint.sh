#!/bin/sh

EXTRA_DOMAINS="$(echo ${EXTRA_DOMAINS} | grep -v 'example.com' | sed 's;[,;]; ;g')"
ACCEPT_NOSSL=${ACCEPT_NOSSL:-0}

echo "#DOMAIN: ${DOMAIN} ${EXTRA_DOMAINS}"
echo '=================================================='
echo

# MKDIR Init
mkdir -p /etc/ssl/caddy /etc/caddy /data/gitea /var/tmp

web_config() {
echo -n ' '
cat << EOF
{
  timeouts 120s
  gzip

  proxy ${WS_PREFIX} http://_LOCALHOST_:8888 {
    websocket
  }

$( for i in `seq 0 9`; do
cat << FOO
  proxy ${WS_PREFIX}${i} http://_LOCALHOST_:777${i} {
    websocket
  }
FOO
done )

$( echo "${EXTRA_PROXYS}" | tr ',' '\n' | grep -v 'example.com' | while read it; do
echo $it | grep -q '.' || continue
cat << FOO
  proxy ${it} {
    websocket
  }
FOO
done )

  proxy / http://localhost:8080 {
    except /404.html
    except ${WS_PREFIX}.*
  }
}
EOF
}

# Gitea Init
[ -f /data/gitea/app.ini ] || {
cat << EOF | grep -v 'UrGitTea' | tee /data/gitea/app.ini
APP_NAME = ${APP_NAME}
RUN_USER = root
RUN_MODE = prod

[server]
HTTP_PORT    = 8080
DOMAIN       = ${DOMAIN}
SSH_DOMAIN   = ${DOMAIN}
ROOT_URL     = https://${DOMAIN}/
DISABLE_SSH  = true
EOF

[ "V$FAKE_MODE" == "Von" ] && cat << EOF | tee -a /data/gitea/app.ini
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
/usr/bin/gitea web -c /data/gitea/app.ini &

# Caddy Init
cp 404.html /var/tmp/
host_ip=$(route -n | awk '/^0.0.0.0/ { print $2 }')
cat << EOF | sed "s+_LOCALHOST_+${host_ip}+g" > /etc/caddy/Caddyfile
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

$( if [ "V$ACCEPT_NOSSL" == "V0" ]; then
  echo -n ${DOMAIN}; web_config
else
  echo -n http://${DOMAIN}; web_config
  echo
  echo -n https://${DOMAIN}; web_config
fi )
EOF

# defualt port 80 443
export CADDYPATH=/etc/ssl/caddy
cat /etc/caddy/Caddyfile
/usr/bin/caddy -agree=true -log stdout -conf=/etc/caddy/Caddyfile -root=/var/tmp
