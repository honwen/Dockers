FROM golang:alpine as builder
ENV CGO_ENABLED=0
RUN apk add --update git
RUN go get github.com/shadowsocks/go-shadowsocks2

FROM chenhw2/alpine:base
LABEL MAINTAINER CHENHW2 <https://github.com/chenhw2>

# /usr/bin/ss-aio
COPY --from=builder /go/bin/go-shadowsocks2 /usr/bin/ss-aio

USER nobody
ENV ARGS="-s ss://AEAD_CHACHA20_POLY1305:your-password@:8488"
EXPOSE 8488/tcp 8488/udp

CMD /usr/bin/ss-aio ${ARGS} -verbose
