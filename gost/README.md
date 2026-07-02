### Source
- https://github.com/chenhw2/Dockers/tree/gost
  
### Thanks to
- https://github.com/ginuerzh/gost
- https://github.com/sgerrand/alpine-pkg-glibc
  
### Usage
```
$ docker pull chenhw2/gost

$ docker run -d \
    -e "ARGS=-L=socks://:1080" \
    -p 1080:1080/tcp \
    chenhw2/gost
```

### Features
* Listening on multiple ports
* Multi-level forward proxy - proxy chain
* Standard HTTP/HTTPS/HTTP2/SOCKS4(A)/SOCKS5 proxy protocols support
* [Support multiple tunnel types](https://docs.ginuerzh.xyz/gost/en/configuration/)
* [TLS encryption via negotiation support for SOCKS5 proxy](https://docs.ginuerzh.xyz/gost/en/socks/)
* [Tunnel UDP over TCP](https://docs.ginuerzh.xyz/gost/en/socks/)
* [Transparent TCP proxy](https://docs.ginuerzh.xyz/gost/en/redirect/)
* [Local/remote TCP/UDP port forwarding](https://docs.ginuerzh.xyz/gost/en/port-forwarding/)
* [Shadowsocks protocol](https://docs.ginuerzh.xyz/gost/en/ss/)
* [SNI proxy](https://docs.ginuerzh.xyz/gost/en/sni/)
* [Permission control](https://docs.ginuerzh.xyz/gost/en/permission/)
* [Load balancing](https://docs.ginuerzh.xyz/gost/en/load-balancing/)
* Wiki: https://docs.ginuerzh.xyz/gost/en/

### Help
```
$ docker run --rm chenhw2/gost -h
  -C string
    	configure file
  -D	enable debug log
  -F value
    	forward address, can make a forward chain
  -L value
    	listen address, can listen on multiple ports
  -V	print version
  -obfs4-distBias
    	Enable obfs4 using ScrambleSuit style table generation
```
