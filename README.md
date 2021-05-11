### Source

- https://github.com/chenhw2/Dockers/tree/dnsproxy

### Thanks

- https://github.com/AdguardTeam/dnsproxy

### Usage

```
$ docker pull chenhw2/dnsproxy

$ docker run -d \
    -e "ARGS=--cache --fastest-addr --edns --all-servers --tls-min-version=1.2 -u=tls://8.8.4.4 -u=tls://162.159.36.1 -u=https://149.112.112.11:5053/dns-query" \
    chenhw2/dnsproxy
```

### Help

```
$ docker run --rm chenhw2/dnsproxy dnsproxy -h
Usage:
  dnsproxy [OPTIONS]

Application Options:
  -v, --verbose          Verbose output (optional)
  -o, --output=          Path to the log file. If not set, write to stdout.
  -l, --listen=          Listening addresses (default: 0.0.0.0)
  -p, --port=            Listening ports. Zero value disables TCP and UDP listeners (default: 53)
  -s, --https-port=      Listening ports for DNS-over-HTTPS
  -t, --tls-port=        Listening ports for DNS-over-TLS
  -q, --quic-port=       Listening ports for DNS-over-QUIC
  -y, --dnscrypt-port=   Listening ports for DNSCrypt
  -c, --tls-crt=         Path to a file with the certificate chain
  -k, --tls-key=         Path to a file with the private key
      --tls-min-version= Minimum TLS version, for example 1.0
      --tls-max-version= Maximum TLS version, for example 1.3
      --insecure         Disable secure TLS certificate validation
  -g, --dnscrypt-config= Path to a file with DNSCrypt configuration. You can generate one using https://github.com/ameshkov/dnscrypt
  -u, --upstream=        An upstream to be used (can be specified multiple times). You can also specify path to a file with the list of servers
  -b, --bootstrap=       Bootstrap DNS for DoH and DoT, can be specified multiple times (default: 8.8.8.8:53)
  -f, --fallback=        Fallback resolvers to use when regular ones are unavailable, can be specified multiple times. You can also specify path to a file with the list of
                         servers
      --all-servers      If specified, parallel queries to all configured upstream servers are enabled
      --fastest-addr     Respond to A or AAAA requests only with the fastest IP address
      --cache            If specified, DNS cache is enabled
      --cache-size=      Cache size (in bytes). Default: 64k
      --cache-min-ttl=   Minimum TTL value for DNS entries, in seconds. Capped at 3600. Artificially extending TTLs should only be done with careful consideration.
      --cache-max-ttl=   Maximum TTL value for DNS entries, in seconds.
  -r, --ratelimit=       Ratelimit (requests per second) (default: 0)
      --refuse-any       If specified, refuse ANY requests
      --edns             Use EDNS Client Subnet extension
      --edns-addr=       Send EDNS Client Address
      --dns64            If specified, dnsproxy will act as a DNS64 server
      --dns64-prefix=    If specified, this is the DNS64 prefix dnsproxy will be using when it works as a DNS64 server. If not specified, dnsproxy uses the 'Well-Known Prefix'
                         64:ff9b::
      --ipv6-disabled    If specified, all AAAA requests will be replied with NoError RCode and empty answer
      --bogus-nxdomain=  Transform responses that contain at least one of the given IP addresses into NXDOMAIN. Can be specified multiple times.
      --udp-buf-size=    Set the size of the UDP buffer in bytes. A value <= 0 will use the system default. (default: 0)
      --max-go-routines= Set the maximum number of go routines. A value <= 0 will not not set a maximum. (default: 0)
      --version          Prints the program version

Help Options:
  -h, --help             Show this help message

```
