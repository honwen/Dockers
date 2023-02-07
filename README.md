### Source
- https://github.com/chenhw2/Dockers/tree/kcptun
  
### Thanks
- https://github.com/xtaci/kcptun
  
### Usage
```
$ docker pull chenhw2/kcptun

$ docker run -d \
    -e "ARGS=server -t 10.0.0.1:80" \
    -p 29900:29900/udp \
    chenhw2/kcptun

$ docker run -d \
    -e "ARGS=client -r [kcp_server]:29900" \
    -p 12948:12948/tcp \
    chenhw2/kcptun
```
=================================================================================
### Help
```
$ docker run --rm chenhw2/kcptun client -h
NAME:
   kcptun - client(with SMUX)

USAGE:
   kcpc [global options] command [command options] [arguments...]

VERSION:
   20230207

COMMANDS:
   help, h  Shows a list of commands or help for one command

GLOBAL OPTIONS:
   --localaddr value, -l value      local listen address (default: ":12948")
   --remoteaddr value, -r value     kcp server address, eg: "IP:29900" a for single port, "IP:minport-maxport" for port range (default: "vps:29900")
   --key value                      pre-shared secret between client and server (default: "it's a secrect") [$KCPTUN_KEY]
   --crypt value                    aes, aes-128, aes-192, salsa20, blowfish, twofish, cast5, 3des, tea, xtea, xor, sm4, none, null (default: "aes")
   --mode value                     profiles: fast3, fast2, fast, normal, manual (default: "fast")
   --conn value                     set num of UDP connections to server (default: 1)
   --autoexpire value               set auto expiration time(in seconds) for a single UDP connection, 0 to disable (default: 0)
   --scavengettl value              set how long an expired connection can live (in seconds) (default: 600)
   --mtu value                      set maximum transmission unit for UDP packets (default: 1350)
   --sndwnd value                   set send window size(num of packets) (default: 128)
   --rcvwnd value                   set receive window size(num of packets) (default: 512)
   --datashard value, --ds value    set reed-solomon erasure coding - datashard (default: 10)
   --parityshard value, --ps value  set reed-solomon erasure coding - parityshard (default: 3)
   --dscp value                     set DSCP(6bit) (default: 0)
   --nocomp                         disable compression
   --sockbuf value                  per-socket buffer in bytes (default: 4194304)
   --smuxver value                  specify smux version, available 1,2 (default: 1)
   --smuxbuf value                  the overall de-mux buffer in bytes (default: 4194304)
   --streambuf value                per stream receive buffer in bytes, smux v2+ (default: 2097152)
   --keepalive value                seconds between heartbeats (default: 10)
   --snmplog value                  collect snmp to file, aware of timeformat in golang, like: ./snmp-20060102.log
   --snmpperiod value               snmp collect period, in seconds (default: 60)
   --log value                      specify a log file to output, default goes to stderr
   --quiet                          to suppress the 'stream open/close' messages
   --tcp                            to emulate a TCP connection(linux)
   -c value                         config from json file, which will override the command from shell
   --help, -h                       show help
   --version, -v                    print the version
```
=================================================================================
```
$ docker run --rm chenhw2/kcptun server -h
NAME:
   kcptun - server(with SMUX)

USAGE:
   kcps [global options] command [command options] [arguments...]

VERSION:
   20230207

COMMANDS:
   help, h  Shows a list of commands or help for one command

GLOBAL OPTIONS:
   --listen value, -l value         kcp server listen address, eg: "IP:29900" for a single port, "IP:minport-maxport" for port range (default: ":29900")
   --target value, -t value         target server address, or path/to/unix_socket (default: "127.0.0.1:12948")
   --key value                      pre-shared secret between client and server (default: "it's a secrect") [$KCPTUN_KEY]
   --crypt value                    aes, aes-128, aes-192, salsa20, blowfish, twofish, cast5, 3des, tea, xtea, xor, sm4, none, null (default: "aes")
   --mode value                     profiles: fast3, fast2, fast, normal, manual (default: "fast")
   --mtu value                      set maximum transmission unit for UDP packets (default: 1350)
   --sndwnd value                   set send window size(num of packets) (default: 1024)
   --rcvwnd value                   set receive window size(num of packets) (default: 1024)
   --datashard value, --ds value    set reed-solomon erasure coding - datashard (default: 10)
   --parityshard value, --ps value  set reed-solomon erasure coding - parityshard (default: 3)
   --dscp value                     set DSCP(6bit) (default: 0)
   --nocomp                         disable compression
   --sockbuf value                  per-socket buffer in bytes (default: 4194304)
   --smuxver value                  specify smux version, available 1,2 (default: 1)
   --smuxbuf value                  the overall de-mux buffer in bytes (default: 4194304)
   --streambuf value                per stream receive buffer in bytes, smux v2+ (default: 2097152)
   --keepalive value                seconds between heartbeats (default: 10)
   --snmplog value                  collect snmp to file, aware of timeformat in golang, like: ./snmp-20060102.log
   --snmpperiod value               snmp collect period, in seconds (default: 60)
   --pprof                          start profiling server on :6060
   --log value                      specify a log file to output, default goes to stderr
   --quiet                          to suppress the 'stream open/close' messages
   --tcp                            to emulate a TCP connection(linux)
   -c value                         config from json file, which will override the command from shell
   --help, -h                       show help
   --version, -v                    print the version
```
