#!/bin/sh

# ssr://protocol:method:obfs:pass
# SSR=${SSR:-ssr://origin:aes-256-cfb:tls1.2_ticket_auth_compatible:12345678}
# SSR_OBFS_PARAM=${SSR_OBFS_PARAM:-bing.com}

# kcp://mode:crypt:key
# KCP=${KCP:-kcp://fast2:aes:}
# KCP_EXTRA_ARGS=${KCP_EXTRA_ARGS:-''}

echo "#CONFIG: ${SSR} ${SSR_OBFS_PARAM}"
echo "#CONFIG: ${KCP} ${KCP_EXTRA_ARGS}"
echo '=================================================='
echo

# Path Init
root_dir=${RUN_ROOT:-'/ssr'}
ssr_cli="${root_dir}/shadowsocks/server.py"
kcp_cli="${root_dir}/kcptun/server"
ssr_conf="${root_dir}/_shadowsocksr.json"
cmd_conf="${root_dir}/_supervisord.conf"
ssr_port=8388

# Gen ssr_conf
ssr2json(){
  ssr=$1
  ssr_obfs_param=$2
  ssr_protocol_param=$3
  json='"protocol": "\1",\n "method": "\2",\n "obfs": "\3",\n "password": "\4"'
  cfg=$(echo ${ssr} | sed -n "s#ssr://\([^:]*\):\([^:]*\):\([^:]*\):\([^:]*\).*#${json}#p")
  cat <<EOF
{
 "server_port": "${ssr_port}",
 ${cfg},
 "protocol_param": "${ssr_protocol_param}",
 "obfs_param": "${ssr_obfs_param}"
}
EOF
}

ssr2json ${SSR} ${SSR_OBFS_PARAM} ${SSR_PROTOCOL_PARAM} > ${ssr_conf}


# Gen kcp_conf
kcp2cmd(){
  kcp=$1
  kcp_extra_agrs=$2
  cmd='--mode \1 --crypt \2'
  cli=$(echo ${kcp} | sed "s#kcp://\([^:]*\):\([^:]*\):\([^:]*\).*#${cmd}#g")
  key=$(echo ${kcp} | sed "s#kcp://\([^:]*\):\([^:]*\):\([^:]*\).*#\3#g")
  [ "Z${key}" = 'Z' ] || cli=$(echo "${cli} --key ${key}")
  echo "${cli} ${kcp_extra_agrs}"
}

kcp_cmd=$(kcp2cmd ${KCP} ${KCP_EXTRA_ARGS})


# Gen supervisord.conf
cat > ${cmd_conf} <<EOF
[supervisord]
nodaemon=true

[program:shadowsocks]
command=/usr/bin/python ${ssr_cli} -c ${ssr_conf}
autorestart=true
redirect_stderr=true
stdout_logfile=/dev/stdout
stdout_logfile_maxbytes=0

[program:kcptun]
command=${kcp_cli} -t 127.0.0.1:${ssr_port} -l :1${ssr_port} ${kcp_cmd}
autorestart=true
redirect_stderr=true
stdout_logfile=/dev/stdout
stdout_logfile_maxbytes=0

EOF

/usr/bin/supervisord -c ${cmd_conf}
