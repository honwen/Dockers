FROM chenhw2/alpine:base

ARG VER=1.1.5
ARG BIN=https://github.com/librespeed/speedtest-go/releases/download/v${VER}/speedtest-go_${VER}_linux_amd64.tar.gz
ARG ASSETS=https://github.com/librespeed/speedtest-go/archive/refs/tags/v${VER}.tar.gz

WORKDIR /app

RUN set +ex \
    && curl -sSL ${BIN} | tar -xz \
    && curl -sSL ${ASSETS} | tar --strip-components=2 -zx "speedtest-go-${VER}/web/assets/" \
    && mv assets/example-singleServer-progressBar.html assets/index.html \
    && rm -f assets/example-*.html README.md LICENSE \
    && find $(pwd) \
    && sed '/^<a .*a>$/d' -i assets/index.html \
    && sed 's+^assets_path=.*+assets_path="assets"+g' -i settings.toml \
    && sed 's+^listen_port=.*+listen_port=_PORT_+g' -i settings.toml

ENV PORT=80

CMD [ "sh", "-cx", "sed s+_PORT_+${PORT}+g -i settings.toml && ./speedtest-backend" ]
