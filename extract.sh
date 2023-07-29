#!/bin/bash

docker build -t chenhw2/caddy2 .

docker run --rm -i -t -v $(pwd):/out:rw chenhw2/caddy2 cp /usr/bin/caddy /out

./caddy version

exit 0
