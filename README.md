### Source

- https://github.com/chenhw2/Dockers/tree/shadowquic

### Thanks

- https://github.com/spongebob888/shadowquic

### Usage

```shell
$ docker pull chenhw2/shadowquic

$ docker run -d \
    --name shadowquic \
    -e USERS=user:$(uuidgen) \
    -p 443:443/udp \
    chenhw2/shadowquic:latest
```
