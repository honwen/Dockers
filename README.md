### Source
- https://github.com/chenhw2/Dockers/tree/HEV-DNS-FORWARDER
  
### Thanks to
- https://github.com/aa65535/hev-dns-forwarder
  
### Usage
```
$ docker pull chenhw2/hev-dns-forwarder

$ docker run -d \
    -p 53:5300/tcp \
    chenhw2/hev-dns-forwarder
```
### Help
```
$ docker run --rm chenhw2/hev-dns-forwarder -h
usage: /usr/local/bin/dnsforwarder [-h] [-b BIND_ADDR] [-p BIND_PORT] [-s DNS]
Forwarding DNS queries on TCP transport.

  -b BIND_ADDR          address that listens, default: 0.0.0.0
  -p BIND_PORT          port that listens, default: 5300
  -s DNS:[PORT]         DNS servers to use, default: 8.8.8.8:53
  -h                    show this help message and exit
```
