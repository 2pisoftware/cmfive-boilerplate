FROM ubuntu:19.10

RUN apt-get update
RUN apt-get install -y software-properties-common
RUN add-apt-repository ppa:ondrej/php
RUN apt-get install -y gnupg2

RUN apt-get install -y vim supervisor nginx gnupg2 \
	php7.2 \
    php7.2-zip \
    php7.2-curl \
    php7.2-fpm \
    php7.2-gd \
    php7.2-json \
    php7.2-mysql \
    php7.2-xml \
    php7.2-bcmath \
    php7.2-mbstring

COPY fpm/* /etc/php/7.2/fpm/
COPY supervisord.conf /etc/supervisord.conf
COPY nginx/nginx.conf /etc/nginx/nginx.conf
COPY nginx/default.conf /etc/nginx/conf.d/default.conf
COPY start.sh start.sh

RUN mkdir /run/php

CMD ["/start.sh"]