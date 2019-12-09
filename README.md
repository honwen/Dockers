### Source
- https://github.com/chenhw2/Dockers/tree/dnsproxy
  
### Thanks
- https://github.com/AdguardTeam/dnsproxy
  
### Usage
```
$ docker pull chenhw2/dnsproxy

$ docker run -d \
    -e "ARGS=-z -s -p 5300 -u tls://8.8.8.8:853 -u tls://8.8.4.4:853" \
    chenhw2/dnsproxy
```

### Help
```
$ docker run --rm chenhw2/dnsproxy dnsproxy -h
Usage:
  dnsproxy [OPTIONS]

Application Options:
  -v, --verbose        Verbose output (optional)
  -o, --output=        Path to the log file. If not set, write to stdout.
  -l, --listen=        Listen address (default: 0.0.0.0)
  -p, --port=          Listen port. Zero value disables TCP and UDP listeners
                       (default: 53)
  -h, --https-port=    Listen port for DNS-over-HTTPS (default: 0)
  -t, --tls-port=      Listen port for DNS-over-TLS (default: 0)
  -c, --tls-crt=       Path to a file with the certificate chain
  -k, --tls-key=       Path to a file with the private key
  -b, --bootstrap=     Bootstrap DNS for DoH and DoT, can be specified multiple
                       times (default: 8.8.8.8:53)
  -r, --ratelimit=     Ratelimit (requests per second) (default: 0)
  -z, --cache          If specified, DNS cache is enabled
  -e, --cache-size=    Cache size (in bytes). Default: 64k
  -a, --refuse-any     If specified, refuse ANY requests
  -u, --upstream=      An upstream to be used (can be specified multiple times)
  -f, --fallback=      Fallback resolvers to use when regular ones are
                       unavailable, can be specified multiple times
  -s, --all-servers    If specified, parallel queries to all configured
                       upstream servers are enabled
  -d, --ipv6-disabled  If specified, all AAAA requests will be replied with
                       NoError RCode and empty answer
      --edns           Use EDNS Client Subnet extension
      --version        Prints the program version

Help Options:
  -h, --help           Show this help message

```
