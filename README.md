### Source
- https://github.com/chenhw2/Dockers/tree/mr2
  
### Thanks to
- https://github.com/txthinking/mr2
  
### Usage
```
$ docker pull chenhw2/mr2

$ docker run -d \
    -e "ARGS=server -l :6060 -p password" \
    -p 6060:6060/tcp -p 6060:6060/udp \
    chenhw2/mr2
```
  
### ENV
```
ENV ARGS="server -l :6060 -p password"
```
  
### HELP
```
NAME:
   mr2 server - Run as server mode

USAGE:
   mr2 server [command options] [arguments...]

OPTIONS:
   --listen value, -l value        Listen address, like: 1.2.3.4:5
   --password value, -p value      Password
   --portPassword value, -P value  Only allow this port and password, like '1000 password'. If you specify this parameter, --password will be ignored


NAME:
   mr2 client - Run as client mode

USAGE:
   mr2 client [command options] [arguments...]

OPTIONS:
   --server value, -s value        Server address, like: 1.2.3.4:5
   --password value, -p value      Password
   --serverPort value, -P value    Server port you want to use (default: 0)
   --clientServer value, -c value  Client server address, like: 1.2.3.4:5
   --clientDirectory value         Client directory, like: /path/to/www
   --clientPort value              With clientDirectory (default: 54321)
   --tcpTimeout value              connection tcp keepalive timeout (s) (default: 60)
   --tcpDeadline value             connection deadline time (s) (default: 0)
   --udpDeadline value             connection deadline time (s) (default: 60)
```
