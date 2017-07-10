### Source
- https://github.com/chenhw2/Dockers/tree/ss-obfs
  
### Thanks to
- https://github.com/shadowsocks/shadowsocks-libev
- https://github.com/shadowsocks/simple-obfs
  
### Usage
```
$ docker pull chenhw2/ss-obfs

$ docker run -d \
    -e 'PASSWORD=12345678' \
    -e 'ARGS=--plugin obfs-server --plugin-opts obfs=tls;failover=www.cloudfront.com' \
    -p 8388:8388/tcp -p 8388:8388/udp \
    chenhw2/ss-obfs
```
  
### Example
- https://github.com/chenhw2/Dockers/tree/ss-obfs/example
  
### ENV
```
ENV SERVER_PORT 8388
ENV METHOD      chacha20-ietf-poly1305
ENV PASSWORD=
ENV Args=
```
