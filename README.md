### Source

- https://github.com/honwen/Dockers/tree/dnsmasq-extra

### Thanks

- https://github.com/honwen/openwrt-dnsmasq-extra

### Usage

```
$ docker pull chenhw2/dnsmasq-extra

$ docker run -d \
    --name dnsmasq-extra \
    -p 53:53/udp \
    chenhw2/dnsmasq-extra
```
