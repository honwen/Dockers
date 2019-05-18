FROM golang:alpine as builder
RUN apk add --update git
RUN go get github.com/txthinking/mr2/cli/mr2


FROM chenhw2/alpine:base
LABEL MAINTAINER CHENHW2 <https://github.com/chenhw2>

# /usr/bin/mr2
COPY --from=builder /go/bin /usr/bin

USER nobody
ENV ARGS="server -l :6666 -p password"
EXPOSE 6060/tcp 6060/udp

CMD /usr/bin/mr2 ${ARGS}
