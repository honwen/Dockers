### Source
- https://github.com/chenhw2/Dockers/tree/caddy-gitea
  
### Thanks
- https://github.com/go-gitea/gitea
- https://github.com/mholt/caddy
  
### Usage
```
$ docker pull chenhw2/gitea

$ docker run -d \
    -e DOMAIN=%I
    -v /etc/ssl/caddy:/etc/ssl/caddy
    -v /var/gitea-data:/data
    -p 80:80 -p 443:443
    chenhw2/gitea:latest
```
