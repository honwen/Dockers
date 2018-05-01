### Source
- https://github.com/chenhw2/Dockers/tree/ssvpn
  
### Thanks
- https://github.com/shadowsocks/go-shadowsocks2
- https://openvpn.net
  
### Usage
```
$ docker pull chenhw2/ssvpn

$ docker run -d \
    --cap-add NET_ADMIN --cap-add NET_RAW --device /dev/net/tun:/dev/net/tun
    -e 'PASSWORD=12345678' \
    -e 'ARGS=--plugin obfs-server --plugin-opts obfs=http;failover=www.cloudfront.com' \
    -p 8388:8388/tcp -p 8388:8388/udp \
    chenhw2/ssvpn
```
  
### ENV
```
ENV SERVER_PORT 8388
ENV METHOD      chacha20-ietf-poly1305
ENV PASSWORD=
ENV ARGS=
ENV NIC=10.9.8.0
```

### Client
```
/usr/bin/ss-aio -c ss://AEAD_... -tcptun :1194=127.0.0.1:1194
openvpn --dev tun --remote 127.0.0.1 --proto tcp-client --port 1194 --ifconfig 10.9.8.2 10.9.8.1
```
