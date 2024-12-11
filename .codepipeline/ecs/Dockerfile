# Ubuntu 18.04 is a requirement for MYSQL 5.7.
FROM ubuntu:18.04

# Fetch required args.
ARG AWS_ACCESS_KEY_ID
ARG AWS_SECRET_ACCESS_KEY
ARG AWS_SESSION_TOKEN
ARG CMFIVE_CORE_BRANCH

# Prevent install locking up of TZ or other user inputs.
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies.
RUN apt update
RUN apt install -y software-properties-common
RUN add-apt-repository ppa:ondrej/php
RUN apt install -y locales-all

RUN apt install -y \
    curl \
    git \
    gnupg2 \
    mysql-client-5.7 \
    nano \
    nginx \
    php8.1-bcmath \
    php8.1-curl \
    php8.1-fpm \
    php8.1-gd \
    php8.1-intl \
    php8.1-mbstring \
    php8.1-mysql \
    php8.1-xml \
    php8.1-zip \
    supervisor

# Install NodeJS and NPM, requires cURL to be installed first.
RUN curl -fsSL https://deb.nodesource.com/setup_14.x | bash
RUN apt install -y nodejs

# Copy Cmfive Boilerplate files into directory for Nginx.
COPY . /var/www/html

# Install Cmfive Core.
WORKDIR /var/www/html
RUN php cmfive.php install core $CMFIVE_CORE_BRANCH

# Install NPM dependencies.
WORKDIR /var/www/html/composer/vendor/2pisoftware/cmfive-core/system/templates/base
RUN npm ci
RUN npm run prod

# Set file permissions.
WORKDIR /var/www/html
RUN chown -R www-data:www-data .

# Bootstrap environment.
WORKDIR /bootstrap

COPY /.codepipeline/ecs/configs/start.sh .
COPY /.codepipeline/ecs/configs/fpm/* /etc/php/8.1/fpm/
COPY /.codepipeline/ecs/configs/nginx/nginx.conf /etc/nginx/nginx.conf
COPY /.codepipeline/ecs/configs/nginx/default.conf /etc/nginx/conf.d/default.conf
COPY /.codepipeline/ecs/configs/supervisord/supervisord.conf /etc/supervisord.conf

RUN mkdir /run/php

RUN chmod -R 777 start.sh
CMD ["/bootstrap/start.sh"]
