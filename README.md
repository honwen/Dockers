### Source

- https://github.com/chenhw2/Dockers/tree/warp2socks

### Thanks

<!-- - https://github.com/SagerNet/sing-box -->
- https://github.com/badafans/warp-reg

### Usage

```shell
$ docker pull chenhw2/warp2socks

$ docker run --rm \
    -v /opt/warp:/warp \
    chenhw2/warp2socks

$ docker run --rm \
    --name warp2socks \
    -v /opt/warp:/opt:ro \
    --network=host \
    chenhw2/sing-box
```
