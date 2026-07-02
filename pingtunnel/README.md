### Source

- https://github.com/honwen/Dockers/tree/sing-box

### Thanks

- https://github.com/honwen/pingtunnel

### Usage

```
$ docker pull chenhw2/pingtunnel
```

- server:

```shell
docker run -d --name ptS --privileged --restart=unless-stopped --network host \
  -e ACTION=server -e ARGS=--key=11223344 \
  chenhw2/pingtunnel
```

- client:

```shell
docker run -d --name ptC --restart=unless-stopped -p 1080:1080 \
  -e ACTION=client -e ARGS='-s=172.17.0.1 --key=11223344' \
  chenhw2/pingtunnel
```
