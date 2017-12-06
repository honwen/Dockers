### Source
- https://github.com/chenhw2/Dockers/tree/libev-build
  
### Thanks
- https://github.com/shadowsocksrr/shadowsocksr-libev
- https://github.com/shadowsocks/shadowsocks-libev
- https://github.com/shadowsocks/simple-obfs
  
### Usage: get statically linked ELF 64-bit
```
$ docker run --rm -v /tmp:/to chenhw2/libev-build sh -c 'cp /usr/bin/ss-* /to; cp /usr/bin/ssr-* /to; cp /usr/bin/obfs-* /to'
```
