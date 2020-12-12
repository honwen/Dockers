### Source

- https://github.com/chenhw2/Dockers/tree/xray

### Thanks

- https://github.com/XTLS/Xray-core

### Usage

```
$ docker pull chenhw2/xray

$ docker run -d \
    --name xray \
    -e ACME_DOMAIN=xray.example.org \
    -e USERS=$(uuidgen) \
    -v /etc/ssl/caddy:/etc/ssl/caddy \
    -p 443:443 \
    chenhw2/xray:latest
```
