### Source
- https://github.com/honwen/Dockers/tree/ss-obfs
  
### Thanks
- https://github.com/shadowsocks/shadowsocks-rust
- https://github.com/shadowsocks/simple-obfs
- https://github.com/shadowsocks/v2ray-plugin
  
### Usage
```bash
$ docker run --rm chenhw2/ss-obfs ssserver -h

A fast tunnel proxy that helps you bypass firewalls.

USAGE:
    ssserver [FLAGS] [OPTIONS] --config <CONFIG>

FLAGS:
    -d, --daemonize           Daemonize
    -6                        Resolve hostname to IPv6 address first
        --log-without-time    Log without datetime prefix
        --no-delay            Set no-delay option for socket
    -U                        Server mode TCP_AND_UDP
    -u                        Server mode UDP_ONLY
    -v                        Set the level of debug
    -h, --help                Prints help information
    -V, --version             Prints version information

...
```
