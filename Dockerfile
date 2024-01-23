# ubuntu version limited for simple mysql5.7 packaging
FROM ubuntu:20.04

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
    php8.1-fpm

RUN apt-get update
RUN apt-get install -y -o "APT::Acquire::Retries=6" \
    php8.1-zip \
    php8.1-curl \
    php8.1-gd \
    php8.1-mysql \
    php8.1-xml \
    php8.1-bcmath \
    php8.1-mbstring \
    php8.1-intl

# toolbox extras, to allow for DB commands & subnet examination etc
RUN apt-get update
RUN apt-get install -y -o "APT::Acquire::Retries=6" \
    git \
    iputils-ping \
    curl \
    mysql-client-8.0

# PHP extras, for test+debug
RUN apt-get update
RUN apt-get install -y -o "APT::Acquire::Retries=6" \
    phpunit

RUN apt-get update
RUN apt-get install -y -o "APT::Acquire::Retries=6" \
    php8.1-xdebug

COPY . /var/www/html

# bootstrap environment
WORKDIR /bootstrap

COPY /.codepipeline/local-dev/start.sh .
COPY /.codepipeline/local-dev/setup.sh .
COPY /.codepipeline/local-dev/configs/fpm/* /etc/php/8.1/fpm/
COPY /.codepipeline/local-dev/configs/nginx/nginx.conf /etc/nginx/nginx.conf
COPY /.codepipeline/local-dev/configs/nginx/default.conf /etc/nginx/conf.d/default.conf
COPY /.codepipeline/local-dev/configs/supervisord/supervisord.conf /etc/supervisord.conf

RUN mkdir /run/php

RUN chmod -R 777 /bootstrap/start.sh

# Healthcheck to ensure nginx is running and cmfive is installed
HEALTHCHECK --interval=10s --timeout=10s --start-period=5s --retries=15 \
  CMD curl -s -o /dev/null -w "%{http_code}" http://localhost:3000 | grep -q -E "^[1-3][0-9]{2}$" && \
      test -f ~/.cmfive-installed

CMD ["/bootstrap/start.sh"]