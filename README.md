### Source

- https://github.com/chenhw2/Dockers/tree/hysteria

### Thanks

- https://github.com/tobyxdd/hysteria

### Usage

```
$ docker pull chenhw2/hysteria

$ docker run -d \
    --name hysteria \
    -e ACME_DOMAIN=hysteria.example.org \
    -e OBFS_KEY=$(uuidgen) \
    -v /etc/ssl/caddy:/etc/ssl/caddy \
    -p 443:443/udp \
    chenhw2/hysteria:latest
```
