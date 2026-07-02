FROM golang:alpine as builder
RUN apk add --update git
RUN go get -u -v github.com/goftp/server/exampleftpd

FROM chenhw2/alpine:base
LABEL MAINTAINER="https://github.com/chenhw2"

# /usr/bin/ftpd
COPY --from=builder /go/bin/exampleftpd /usr/bin/ftpd

ENV ROOT=/root \
    USER=root \
    PASS=pass

EXPOSE 21

CMD /usr/bin/ftpd -host 0.0.0.0 -port 21 -user $USER -pass $PASS -root $ROOT

