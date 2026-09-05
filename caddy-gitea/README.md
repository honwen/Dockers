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
    -e ACME_CA=https://acme-v02.api.letsencrypt.org/directory  # optional: switch CA if ZeroSSL is unstable
    -v /etc/ssl/caddy:/etc/ssl/caddy
    -v /var/gitea-data:/data
    -p 80:80 -p 443:443
    chenhw2/gitea:latest
```

### Available ACME CAs

| CA                    | Directory URL                                    |
| --------------------- | ------------------------------------------------ |
| ZeroSSL (default)     | `https://acme.zerossl.com/v2/DV90`               |
| Let's Encrypt         | `https://acme-v02.api.letsencrypt.org/directory` |
| Google Trust Services | `https://dv.acme-v02.api.pki.goog/directory`     |
| SSL.com               | `https://acme.ssl.com/sslcom-dv-rsa`             |
