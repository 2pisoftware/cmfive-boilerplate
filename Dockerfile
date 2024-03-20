# ==========================================================================
# ## Cmfive Boilerplate image ##
# ==========================================================================

# This image provides a base environment to install cmfive upon.
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
FROM alpine:3.19

# Create cmfive user and group on ID 1000
RUN addgroup -g 1000 cmfive && \
    adduser -u 1000 -G cmfive -s /bin/bash -D cmfive

# Install required packages for PHP, Nginx etc
RUN apk --no-cache add \
    php81 \
    php81-fpm \
    php81-cli \
    php81-curl \
    php81-gd \
    php81-json \
    php81-mbstring \
    php81-mysqli \
    php81-xml \
    php81-zip \
    php81-pdo \
    php81-pdo_mysql \
    php81-phar \
    php81-intl \
    php81-gettext \
    php81-session \
    php81-simplexml \
    php81-fileinfo \
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
RUN ln -s /usr/bin/php81 /usr/bin/php

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
COPY /.codepipeline/docker/configs/fpm/ /etc/php81/
COPY /.codepipeline/docker/setup.sh /bootstrap/setup.sh
COPY /.codepipeline/docker/config.default.php /bootstrap/config.default.php

# Expose HTTP, HTTPS
EXPOSE 80 443

# Copy source
COPY --chown=cmfive:cmfive . /var/www/html

# Set working directory
WORKDIR /var/www/html

# Remove .codepipeline
RUN rm -rf .codepipeline

# Healthcheck to ensure nginx is running and cmfive is installed
HEALTHCHECK --interval=15s --timeout=5m --start-period=5s --retries=15 \
  CMD curl -s -o /dev/null -w "%{http_code}" http://localhost | grep -q -E "^[1-3][0-9]{2}$" && \
      test -f /home/cmfive/.cmfive-installed

# Start supervisord
CMD ["supervisord", "--nodaemon", "--configuration", "/etc/supervisord.conf"]
