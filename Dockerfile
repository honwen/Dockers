FROM golang:alpine as builder
RUN apk add --update git
RUN go get -u -v github.com/gohugoio/hugo github.com/mholt/caddy/caddy

FROM chenhw2/alpine:base
LABEL MAINTAINER="https://github.com/chenhw2"

# /usr/bin/{hugo, caddy}
COPY --from=builder /go/bin/* /usr/bin/

ENV DOMAIN=example.com

EXPOSE 80/tcp 443/tcp

ADD entrypoint.sh 404.html /
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
