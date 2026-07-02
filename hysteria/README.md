### Source

- https://github.com/chenhw2/Dockers/tree/hysteria

### Thanks

- https://github.com/apernet/hysteria

### Usage

```shell
$ docker pull chenhw2/hysteria

$ docker run -d \
    --name hysteria \
    -v /etc/hysteria.yaml:/opt/config.yaml:ro \
    -p 443:443/udp \
    chenhw2/hysteria:latest
```
