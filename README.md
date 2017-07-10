### Source
- https://github.com/chenhw2/Dockers/tree/SSR-KCP-SERVER-lite
  
### Thanks to
- https://github.com/shadowsocksr/shadowsocksr
- https://github.com/xtaci/kcptun
  
### Usage
```
$ docker pull chenhw2/ssr-kcp-server-lite

$ docker run -d \
    -e "SSR=[ssr://protocol:method:obfs:pass]" \
    -e "KCP=[kcp://mode:crypt:key]" \
    -p 8388:8388/tcp -p 8388:8388/udp -p 18388:18388/udp \
    chenhw2/ssr-kcp-server-lite
```

### ENV
```
# ssr://protocol:method:obfs:pass
ENV SSR=ssr://origin:aes-256-cfb:tls1.2_ticket_auth_compatible:12345678
ENV SSR_OBFS_PARAM=bing.com

# kcp://mode:crypt:key
ENV KCP=cp://fast2:aes:
ENV KCP_EXTRA_ARGS=''

```