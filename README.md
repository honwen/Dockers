### Source
- https://github.com/chenhw2/Dockers/tree/v2ray-plugin
  
### Thanks
- https://github.com/shadowsocks/v2ray-plugin
  
### Help
```
$ docker run --rm chenhw2/v2ray-plugin -h
Usage of /usr/bin/v2ray-plugin:
  -V    Run in VPN mode.
  -cert string
        Path to TLS certificate file. Overrides certRaw. Default: ~/.acme.sh/{host}/fullchain.cer
  -certRaw string
        Raw TLS certificate content. Intended only for Android.
  -fast-open
        Enable TCP fast open.
  -host string
        Host header for websocket. (default "cloudfront.com")
  -key string
        (server) Path to TLS key file. Default: ~/.acme.sh/{host}/{host}.key
  -localAddr string
        local address to listen on. (default "127.0.0.1")
  -localPort string
        local port to listen on. (default "1984")
  -loglevel string
        loglevel for v2ray: debug, info, warning (default), error, none.
  -mode string
        Transport mode: websocket, quic (enforced tls). (default "websocket")
  -path string
        URL path for websocket. (default "/")
  -remoteAddr string
        remote address to forward. (default "127.0.0.1")
  -remotePort string
        remote port to forward. (default "1080")
  -server
        Run in server mode
  -tls
        Enable TLS.
```
