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
	php${php_version:-7.2}-fpm

RUN apt-get install -y -o "APT::Acquire::Retries=6" \
    ${php_version:-7.2}-zip \
    ${php_version:-7.2}-curl \
    ${php_version:-7.2}-gd \
    ${php_version:-7.2}-json \
    ${php_version:-7.2}-mysql \
    ${php_version:-7.2}-xml \
    ${php_version:-7.2}-bcmath \
    ${php_version:-7.2}-mbstring

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

# setup preprocessor runtime
RUN apt-get install -y -o "APT::Acquire::Retries=6" \
    python3 \
    python3-pip
RUN pip3 install jinja2

# preprocess config files with php version
RUN mkdir /deploy
WORKDIR /deploy
COPY . .
RUN python3 preprocessor.py php_version=${php_version:-7.2}
RUN chmod -R 777 start.sh

RUN cp fpm/* /etc/php/${php_version:-7.2}/fpm/
RUN cp supervisord.conf /etc/supervisord.conf
RUN cp nginx/nginx.conf /etc/nginx/nginx.conf
RUN cp nginx/default.conf /etc/nginx/conf.d/default.conf

RUN mkdir /run/php

CMD ["/deploy/start.sh"]