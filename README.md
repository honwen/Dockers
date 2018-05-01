### Source
- https://github.com/chenhw2/Dockers/tree/brook
  
### Thanks to
- https://github.com/txthinking/brook
  
### Usage
```
$ docker pull chenhw2/brook

$ docker run -d \
    -e "ARGS=server -l :6060 -p password" \
    -p 6060:6060/tcp -p 6060:6060/udp \
    chenhw2/brook
```
  
### ENV
```
ENV ARGS="server -l :6060 -p password"
```
  
### HELP
```
NAME:
   Brook - A Cross-Platform Proxy Software

USAGE:
   brook [global options] command [command options] [arguments...]

VERSION:
   20171113

AUTHOR:
   Cloud <cloud@txthinking.com>

COMMANDS:
     server         Run as server mode
     servers        Run as multiple servers mode
     client         Run as client mode
     streamserver   Run as server mode
     streamservers  Run as multiple servers mode
     streamclient   Run as client mode
     ssserver       Run as shadowsocks server mode, fixed method is aes-256-cfb
     ssservers      Run as shadowsocks multiple servers mode, fixed method is aes-256-cfb
     ssclient       Run as shadowsocks client mode, fixed method is aes-256-cfb
     socks5         Run as raw socks5 server
     relay          Run as relay mode
     relays         Run as multiple relays mode
     qr             Print brook server QR code
     socks5tohttp   Convert socks5 to http proxy
     help, h        Shows a list of commands or help for one command

GLOBAL OPTIONS:
   --debug, -d               Enable debug
   --listen value, -l value  Listen address for debug (default: ":6060")
   --help, -h                show help
   --version, -v             print the version
```
