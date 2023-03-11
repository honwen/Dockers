### Source

- https://github.com/chenhw2/Dockers/tree/xray

### Thanks

- https://github.com/XTLS/Xray-core

### Usage

```shell
$ docker pull chenhw2/xray

$ docker run -d \
    --name xray \
    -e USERS=$(uuidgen) \
    -p 443:443 \
    chenhw2/xray:latest
```
