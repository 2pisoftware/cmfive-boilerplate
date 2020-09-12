# ubuntu version limited for simple mysql5.7 packaging
FROM ubuntu:18.04

# prevent install locking up o TZ or other user inputs
ENV DEBIAN_FRONTEND=noninteractive

# set up basics for apt-get'ting
RUN apt-get update
RUN apt-get install -y software-properties-common
RUN add-apt-repository ppa:ondrej/php
RUN apt-get install -y locales-all

# allow retries & break up apt-get for recovery
# of build from apt cache in case of connection failures
RUN apt-get install -y -o "APT::Acquire::Retries=6" \
    vim supervisor nginx gnupg2	

RUN apt-get install -y -o "APT::Acquire::Retries=6" \
    php7.2-fpm \
    php7.2-zip \
    php7.2-curl \
    php7.2-gd \
    php7.2-json \
    php7.2-mysql \
    php7.2-xml \
    php7.2-bcmath \
    php7.2-mbstring

# toolbox extras, to allow for DB commands & subnet examination etc
RUN apt-get update
RUN apt-get install -y -o "APT::Acquire::Retries=6" \
    git \
    iputils-ping \
    curl \
    mysql-client-5.7

# PHP extras, for test+debug
RUN apt-get update
RUN apt-get install -y -o "APT::Acquire::Retries=6" \ 
    phpunit \
    php-xdebug

# bootstrap environment
WORKDIR /bootstrap
COPY ./stage .

RUN cp fpm/* /etc/php/7.2/fpm/ &\
    cp nginx/nginx.conf /etc/nginx/nginx.conf &\
    cp nginx/default.conf /etc/nginx/conf.d/default.conf &\
    cp supervisord.conf /etc/supervisord.conf

RUN mkdir /run/php

RUN chmod -R 777 start.sh
CMD ["/bootstrap/start.sh"]