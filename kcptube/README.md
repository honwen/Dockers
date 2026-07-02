### Source

- https://github.com/chenhw2/Dockers/tree/warp2socks

### Thanks

- https://github.com/SagerNet/sing-box
- https://gitlab.com/ProjectWARP/warp-go

### Usage

```shell
$ docker pull chenhw2/warp2socks

$ docker run -d \
    --name warp2socks \
    -v /opt/warp:/warp \
    -p 1080:2000 \
    chenhw2/warp2socks
```
