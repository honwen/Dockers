### Source

- https://github.com/chenhw2/Dockers/tree/ssvpn

### Thanks

- https://github.com/ginuerzh/gost
- https://github.com/wangyu-/UDPspeeder
- https://openvpn.net

### Usage

```
$ docker pull chenhw2/ssvpn

$ docker run -d \
    --cap-add NET_ADMIN --cap-add NET_RAW --device /dev/net/tun:/dev/net/tun
    -e 'GOST_ARGS=ss://AEAD_AES_128_GCM:your-password@' \
    -p 8488:8488/tcp -p 8488:8488/udp -p 8499:8499/udp \
    chenhw2/ssvpn
```

### ENV

```
ENV GOST_ARGS=ss://AEAD_AES_128_GCM:your-password@
ENV NIC=10.9.8.0
```

### Client

```
/usr/bin/gost -L=tcp://:1194/127.0.0.1:1194 -F=ss://AEAD_...@...
openvpn --dev tun --remote 127.0.0.1 --proto tcp-client --port 1194 --ifconfig 10.9.8.2 10.9.8.1 --keepalive 10 120
```
