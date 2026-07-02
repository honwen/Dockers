### Source
- https://github.com/chenhw2/Dockers/tree/libev-build
  
### Thanks
- https://github.com/shadowsocksrr/shadowsocksr-libev
- https://github.com/shadowsocks/shadowsocks-libev
- https://github.com/shadowsocks/simple-obfs
  
### Usage: get statically linked ELF 64-bit (If NOT sure, use glibc)
```
$ docker run --rm -v /tmp:/to chenhw2/libev-build:glibc sh -c 'cp /usr/bin/ss-* /to; cp /usr/bin/ssr-* /to; cp /usr/bin/obfs-* /to'
$ docker run --rm -v /tmp:/to chenhw2/libev-build:musl  sh -c 'cp /usr/bin/ss-* /to; cp /usr/bin/ssr-* /to; cp /usr/bin/obfs-* /to'
```
