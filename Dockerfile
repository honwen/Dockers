FROM ginuerzh/gost:latest as gost

FROM chenhw2/alpine:base
LABEL MAINTAINER CHENHW2 <https://github.com/chenhw2>

COPY --from=gost /bin/gost /usr/bin/

ENV ARGS="-L=:8080"
CMD /usr/bin/gost ${ARGS}
