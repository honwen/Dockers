### Source
- https://github.com/chenhw2/Dockers/tree/frp
  
### Thanks
- https://github.com/fatedier/frp
  
### Usage
```
$ docker pull chenhw2/frp

$ docker run -d \
    -e "ARGS=frps" \
    -v path_to_frps.ini:/frp/frps.ini \
    --net host \
    chenhw2/frp

$ docker run -d \
    -e "ARGS=frpc" \
    -v path_to_frpc.ini:/frp/frpc.ini \
    chenhw2/frp
```
=================================================================================
### Help
```
$ docker run --rm chenhw2/frp frps -h
frps is the server of frp

Usage: 
    frps [-c config_file] [-L log_file] [--log-level=<log_level>] [--addr=<bind_addr>]
    frps [-c config_file] --reload
    frps -h | --help
    frps -v | --version

Options:
    -c config_file            set config file
    -L log_file               set output log file, including console
    --log-level=<log_level>   set log level: debug, info, warn, error
    --addr=<bind_addr>        listen addr for client, example: 0.0.0.0:7000
    --reload                  reload ini file and configures in common section won't be changed
    -h --help                 show this screen
    -v --version              show version
```
=================================================================================
```
$ docker run --rm chenhw2/frp frps -h
frpc is the client of frp

Usage: 
    frpc [-c config_file] [-L log_file] [--log-level=<log_level>] [--server-addr=<server_addr>]
    frpc -h | --help
    frpc -v | --version

Options:
    -c config_file              set config file
    -L log_file                 set output log file, including console
    --log-level=<log_level>     set log level: debug, info, warn, error
    --server-addr=<server_addr> addr which frps is listening for, example: 0.0.0.0:7000
    -h --help                   show this screen
    --version                   show version
```
