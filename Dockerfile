# ==========================================================================
# ## Cmfive docker image ##
# ==========================================================================

# This image provides a fully working cmfive instance

# It provides two build arguments:
# - CORE_BRANCH: The branch to clone from the cmfive-core repository
# - PHP_VERSION: The version of PHP to use

# NOTE: See the .dockerignore file to see what is excluded from the image.

# --------------------------------------------------------------------------
# == Core stage ==
# --------------------------------------------------------------------------

# This stage clones the cmfive-core repository and compiles the theme

# Use the Node.js base image
FROM node:20-alpine AS core

# Install git
RUN apk --no-cache add \
    git

# Clone github.com/2pisoftware/cmfive-core
ARG CORE_BRANCH=master
RUN git clone --depth 1 https://github.com/2pisoftware/cmfive-core.git -b $CORE_BRANCH

# Compile the theme
RUN cd /cmfive-core/system/templates/base && npm install && npm run production

# --------------------------------------------------------------------------
# == Cmfive stage ==
# --------------------------------------------------------------------------

# This stage builds the final cmfive image

# Use the Alpine Linux base image
FROM alpine:3.20

# PHP version
# note: see Alpine packages for available versions
ARG PHP_VERSION=82

# Create cmfive user and group on ID 1000
RUN addgroup -g 1000 cmfive && \
    adduser -u 1000 -G cmfive -s /bin/bash -D cmfive

# Install required packages for PHP, Nginx etc
RUN apk --no-cache add \
    php$PHP_VERSION \
    php$PHP_VERSION-fpm \
    php$PHP_VERSION-cli \
    php$PHP_VERSION-curl \
    php$PHP_VERSION-gd \
    php$PHP_VERSION-json \
    php$PHP_VERSION-mbstring \
    php$PHP_VERSION-mysqli \
    php$PHP_VERSION-xml \
    php$PHP_VERSION-zip \
    php$PHP_VERSION-pdo \
    php$PHP_VERSION-pdo_mysql \
    php$PHP_VERSION-phar \
    php$PHP_VERSION-intl \
    php$PHP_VERSION-gettext \
    php$PHP_VERSION-session \
    php$PHP_VERSION-simplexml \
    php$PHP_VERSION-fileinfo \
    nginx \
    supervisor \
    bash \
    openssl \
    memcached \
    curl \
    wget \
    unzip \
    icu-data-full \
    git

# Link PHP cli
RUN ln -s /usr/bin/php$PHP_VERSION /usr/bin/php &&\
    ln -s /usr/sbin/php-fpm$PHP_VERSION /usr/sbin/php-fpm

# Create necessary directories
RUN mkdir -p /var/www && \
    mkdir -p /run/nginx

# Generate dev/placeholder self-signed SSL certificate
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/nginx/nginx.key \
    -out /etc/nginx/nginx.crt \
    -subj "/C=AU/ST=NSW/L=Bega/O=2pisoftware/OU=Development/CN=2pisoftware.com"

# Copy configuration files
COPY /.codepipeline/docker/configs/supervisord/supervisord.conf /etc/supervisord.conf
COPY /.codepipeline/docker/configs/nginx/nginx.conf /etc/nginx/nginx.conf
COPY /.codepipeline/docker/configs/nginx/default.conf /etc/nginx/conf.d/default.conf
COPY /.codepipeline/docker/configs/fpm/ /etc/php$PHP_VERSION/
COPY /.codepipeline/docker/setup.sh /bootstrap/setup.sh
COPY /.codepipeline/docker/config.default.php /bootstrap/config.default.php

# Copy source
COPY --chown=cmfive:cmfive . /var/www/html

# Set working directory
WORKDIR /var/www/html

# Remove .codepipeline
RUN rm -rf .codepipeline

# Copy the core
COPY --chown=cmfive:cmfive \
    --from=core \
    /cmfive-core/system/ \
    composer/vendor/2pisoftware/cmfive-core/system/

# Link system
RUN ln -s composer/vendor/2pisoftware/cmfive-core/system/ system

# Install core
RUN su cmfive -c 'INSTALL_ENV=docker php cmfive.php install core'

# Copy theme
COPY --chown=cmfive:cmfive \
    --from=core \
    /cmfive-core/system/templates/base/dist \
    system/templates/base/dist

# Fix permissions
RUN chmod -R ugo=rwX cache/ storage/ uploads/

# Expose HTTP, HTTPS
EXPOSE 80 443

# Healthcheck to ensure nginx is running and cmfive is installed
HEALTHCHECK --interval=15s --timeout=5m --start-period=5s --retries=15 \
  CMD curl -s -o /dev/null -w "%{http_code}" http://localhost | grep -q -E "^[1-3][0-9]{2}$" && \
      test -f /home/cmfive/.cmfive-installed

# Start supervisord
CMD ["supervisord", "--nodaemon", "--configuration", "/etc/supervisord.conf"]
