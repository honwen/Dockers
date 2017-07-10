### Source
- https://github.com/chenhw2/Dockers/tree/GOST
  
### Thanks to
- https://github.com/ginuerzh/gost
- https://github.com/sgerrand/alpine-pkg-glibc
  
### Usage
```
$ docker pull chenhw2/gost

$ docker run -d \
    -e "ARGS=-L=socks://:1080" \
    -p 1080:1080/tcp \
    chenhw2/gost
```
> http - standard HTTP proxy: http://:8080

> http+tls - standard HTTPS proxy (may need to provide a trusted certificate): http+tls://:443 or https://:443

> http2 - HTTP2 proxy and backwards-compatible with HTTPS proxy: http2://:443

> socks4(a) - standard SOCKS4(A) proxy: socks4://:1080 or socks4a://:1080

> socks - standard SOCKS5 proxy: socks://:1080

> socks+wss - SOCKS5 over websocket: socks+wss://:1080

> tls - HTTPS/SOCKS5 over TLS: tls://:443

> ss - standard shadowsocks proxy, ss://chacha20:123456@:8338

> ssu - shadowsocks UDP relay，ssu://chacha20:123456@:8338

> quic - standard QUIC proxy, quic://:6121

> kcp - standard KCP tunnel，kcp://:8388 or kcp://aes:123456@:8388

> pht - plain HTTP tunnel, pht://:8080

> redirect - transparent proxy，redirect://:12345

> ssh - SSH tunnel, ssh://admin:123456@:2222
  
=================================================================================

### Help
```
$ docker run --rm chenhw2/gost -h
Usage of /opt/gost:
  -C string
    	configure file
  -F value
    	forward address, can make a forward chain
  -L value
    	listen address, can listen on multiple ports
  -V	print version
  -alsologtostderr
    	log to standard error as well as files
  -log_backtrace_at value
    	when logging hits line file:N, emit a stack trace
  -log_dir string
    	If non-empty, write log files in this directory
  -logtostderr
    	log to standard error instead of files
  -stderrthreshold value
    	logs at or above this threshold go to stderr
  -v value
    	log level for V logs
  -vmodule value
    	comma-separated list of pattern=N settings for file-filtered logging
```
