### Source
- https://github.com/chenhw2/Dockers/tree/caddy-hugo
  
### Thanks
- https://github.com/gohugoio/hugo
- https://github.com/mholt/caddy
  
### Usage
```
$ docker pull chenhw2/hugo

$ docker run -d \
    -e DOMAIN=%I
    -v /www:/www/%I
    -v /etc/ssl/caddy:/etc/ssl/caddy
    -p 80:80 -p 443:443
    chenhw2/hugo:latest
```
