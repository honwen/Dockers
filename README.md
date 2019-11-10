### Source

- https://github.com/chenhw2/Dockers/tree/subscribe-clash

### Thanks

- https://github.com/nadoo/glider
- https://github.com/Dreamacro/clash
- https://github.com/AdguardTeam/dnsproxy
- https://github.com/Hackl0us/SS-Rule-Snippet
- https://github.com/honwen/shadowsocks-helper

### Usage

```
$ docker pull chenhw2/subscribe-clash

$ docker run -d \
    -e URL=https://subscribe.entrypoint \
    -p 1080:1080 -p 8080:8080 \
    chenhw2/subscribe-clash
```
