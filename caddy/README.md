### Source
- https://github.com/chenhw2/Dockers/tree/caddy
  
### Thanks
- https://github.com/mholt/caddy
  
### Usage
```
$ docker pull chenhw2/caddy

$ docker run -d \
    -v /path_to_Caddyfile:/etc/caddy/Caddyfile:ro
    -v /etc/ssl/caddy:/etc/ssl/caddy
    -p 80:80 -p 443:443
    chenhw2/gitea:latest
```
