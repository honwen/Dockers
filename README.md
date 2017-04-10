### Source
- https://github.com/chenhw2/Dockers/tree/DNSMASQ
  
### Thanks to
- https://en.wikipedia.org/wiki/Dnsmasq

### Usage
```
$ docker pull chenhw2/dnsmasq

$ docker run -d \
    -v data:/etc/dnsmasq.d/ \
    -p 53:5353/tcp -p 53:5353/udp \
    chenhw2/dnsmasq
```
