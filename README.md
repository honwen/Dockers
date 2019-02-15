### Source
- https://github.com/chenhw2/Dockers/tree/SoftEtherVPN
  
### Thanks to
- https://www.softether.org
  
### Usage
```
$ docker pull chenhw2/softethervpn

$ docker run -d --env-file /etc/vpn.env \
    -p 500:500/udp -p 4500:4500/udp -p 1701:1701/udp -p 5555:5555/tcp \
    chenhw2/softethervpn
```

Mix and match published ports: 
- `-p 500:500/udp -p 4500:4500/udp -p 1701:1701/udp` for L2TP/IPSec
- `-p 5555:5555/tcp` for SoftEther VPN (recommended by vendor).

## Credentials

All optional:

- `-e PSK`: Pre-Shared Key (PSK), if not set: "notasecret" (without quotes) by default.
- `-e USERS`: Multiple usernames and passwords may be set with the following pattern: `username:password;user2:pass2;user3:pass3`. Username and passwords are separated by `:`. Each pair of `username:password` should be separated by `;`. If not set a single user account with a random username ("user[nnnn]") and a random weak password is created.
- `-e SPW`: Server management password. :warning:
- `-e HPW`: "DEFAULT" hub management password. :warning:

Examples (assuming bash; note the double-quotes `"` and backticks `` ` ``):

* `--env-file /path/to/envlist`
