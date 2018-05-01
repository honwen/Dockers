### Source
- https://github.com/chenhw2/Dockers/tree/ss-aio
  
### Thanks to
- [https://github.com/shadowsocks/go-shadowsocks2][ss2ver]
  
### Usage
```
$ docker pull chenhw2/ss-aio

$ docker run -d \
    -e "ARGS=-s ss://AEAD_CHACHA20_POLY1305:your-password@:8488" \
    -p 8488:8488/tcp -p 8488:8488/udp \
    chenhw2/ss-aio
```

### ENV
```
ENV ARGS="-s ss://AEAD_CHACHA20_POLY1305:your-password@:8488"
```

 [ss2ver]: https://github.com/shadowsocks/go-shadowsocks2/commit/1c9b29ca973062e12bad6b3807dc9c178cf07115
