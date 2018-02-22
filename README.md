### Source
- https://github.com/chenhw2/Dockers/tree/SSR-KCP-SERVER
  
### Thanks
- https://github.com/shadowsocksrr/shadowsocksr
- https://github.com/xtaci/kcptun
  
### Usage
```
$ docker pull chenhw2/ssr-kcp-server

$ docker run -d \
    -e "SSR=[ssr://protocol:method:obfs:pass]" \
    -e "KCP=[kcp://mode:crypt:key]" \
    -p 8388:8388/tcp -p 8388:8388/udp -p 18388:18388/udp \
    chenhw2/ssr-kcp-server
```

### ENV
```
# ssr://protocol:method:obfs:pass
ENV SSR=ssr://origin:chacha20-ietf:http_post_compatible:12345678
ENV SSR_OBFS_PARAM=alibabagroup.com

# kcp://mode:crypt:key
# KCP will be ignored while KCP_EXTRA_ARGS is NOT enpty
ENV KCP=kcp://fast2:aes:
ENV KCP_EXTRA_ARGS=''
```

### 参考配置
---
   键名           | 数据类型   | 说明
   ---------------|------------|-----------------------------------------------
   protocol       | 字符串     | [协议插件][P], 推荐使用 ```orgin, auth_aes128_{md5, sha1}, auth_chain_{a, b, c, d, e, f}```
   obfs           | 字符串     | [混淆插件][P], 推荐使用 ```plain, http_{simple, post}, tls1.2_ticket_auth```

  [P]: https://github.com/shadowsocksrr/shadowsocks-rss/blob/master/ssr.md
