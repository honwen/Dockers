FROM golang:alpine as golang
RUN apk add --update git
RUN CGO_ENABLED=0 go get -u -v github.com/AdguardTeam/dnsproxy

FROM chenhw2/alpine:base
LABEL MAINTAINER CHENHW2 <https://github.com/honwen>

# /usr/bin/dnsproxy
COPY --from=golang /go/bin/* /usr/bin/

# RUN /usr/bin/dnsproxy --version

ENV ARGS="--cache --refuse-any --edns --all-servers -u tls://1.0.0.1:853 -u tls://8.8.4.4:853"

CMD /usr/bin/dnsproxy ${ARGS}
