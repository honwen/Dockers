FROM chenhw2/alpine:base

ARG VER=1.1.3
ARG URL=https://github.com/librespeed/speedtest-go/releases/download/v${VER}/speedtest-go_${VER}_linux_amd64.tar.gz
WORKDIR /librespeed

RUN set +ex \
    && curl -sSL ${URL} | tar -xzv \
    && mv assets/example-singleServer-progressBar.html assets/index.html \
    && rm -f assets/example* \
    && sed 's+^\(listen_port=\).*+\1_PORT_+g' -i settings.toml \
    && sed 's+ *Example *++g' -i assets/index.html

ENV PORT=80

CMD [ "sh", "-cx", "sed s+_PORT_+${PORT}+g -i settings.toml && ./speedtest-backend" ]
