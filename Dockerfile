# ==========================================================================
# ## Cosine docker image ##
# ==========================================================================

# This image provides a fully working Cosine instance

# It provides the following build arguments:
# - CORE_BRANCH: The branch to clone from the cmfive-core repository
# - PHP_VERSION: The version of PHP to use
# - UID: The user ID of the cmfive user
# - GID: The group ID of the cmfive group

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

# Set the default branch to clone
ARG BUILT_IN_CORE_BRANCH=main
# Invalidate the cache if the branch has changed
ADD https://api.github.com/repos/2pisoftware/cmfive-core/git/refs/heads/$BUILT_IN_CORE_BRANCH /version.json
# Clone github.com/2pisoftware/cmfive-core
RUN git clone --depth 1 https://github.com/2pisoftware/cmfive-core.git -b $BUILT_IN_CORE_BRANCH

# Get the repo metadata
RUN cd /cmfive-core && \
    git log -1 --pretty=format:"CORE_HASH=\"%H\"%nCORE_COMMIT_MSG=\"%s\"%nCORE_REF=\"%D\"" > /.core-metadata

# Compile the theme
RUN cd /cmfive-core/system/templates/base && \
    npm ci && \
    npm run production

# --------------------------------------------------------------------------
# == Cosine stage ==
# --------------------------------------------------------------------------

# This stage builds the final Cosine image

# Use the Alpine Linux base image
FROM alpine:3.21.0

# PHP version
# note: see Alpine packages for available versions
ARG PHP_VERSION=81
ENV PHP_VERSION=$PHP_VERSION
ARG UID=1000
ARG GID=1000

# Create cmfive user and group
RUN addgroup -g ${GID} cmfive && \
    adduser -u ${UID} -G cmfive -s /bin/bash -D cmfive

# Link PHP Config
RUN mkdir -p /etc/php && \
    ln -s /etc/php /etc/php$PHP_VERSION

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
RUN ln -s /usr/bin/php${PHP_VERSION} /usr/bin/php

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
COPY /.codepipeline/docker/configs/fpm/ /etc/php/
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

# Metadata for core
COPY --chown=cmfive:cmfive \
    --from=core \
    /.core-metadata \
    /.core-metadata

# Link system
RUN ln -s composer/vendor/2pisoftware/cmfive-core/system/ system

# Install core
RUN su cmfive -c 'INSTALL_ENV=docker php cmfive.php install core'

# Copy theme
COPY --chown=cmfive:cmfive \
    --from=core \
    /cmfive-core/system/templates/base/dist \
    system/templates/base/dist
    
# Copy theme node modules
COPY --chown=cmfive:cmfive \
    --from=core \
    /cmfive-core/system/templates/base/node_modules \
    system/templates/base/node_modules

# Fix permissions
RUN chmod -R ugo=rwX cache/ storage/ uploads/ && \
    chown -R cmfive:cmfive /var/lib/nginx /var/log/nginx

# Expose HTTP, HTTPS
EXPOSE 80 443

# Healthcheck to ensure nginx and php-fpm is running and cmfive is installed
HEALTHCHECK --interval=15s --timeout=5m --start-period=5s --retries=15 \
  CMD supervisorctl status nginx | grep -q "RUNNING" && \
      supervisorctl status php-fpm | grep -q "RUNNING" && \
      test -f /home/cmfive/.cmfive-installed

# Start supervisord
CMD ["supervisord", "--nodaemon", "--configuration", "/etc/supervisord.conf"]
