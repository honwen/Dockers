FROM abiosoft/caddy:php-no-stats as caddy

ARG SPT_VER=4.7.1
WORKDIR /var/www

RUN curl -sSL https://github.com/adolfintel/speedtest/archive/${SPT_VER}.tar.gz | tar xzv --strip-components 1 \
    && sed '/adolfintel/d' example-gauges.html > index.html \
    && sed 's;^post_max_size.*M;post_max_size = 20M;g' -i /etc/php7/php.ini
