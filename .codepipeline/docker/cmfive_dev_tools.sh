#!/bin/sh
# To be run on the container, see install_dev_tools.sh
set -e

echo "🏗️  Installing required system packages"
apk add --no-cache \
    php$PHP_VERSION-dom \
    php$PHP_VERSION-xmlwriter \
    php$PHP_VERSION-tokenizer \
    php$PHP_VERSION-ctype \
    php$PHP_VERSION-xdebug \
    mysql-client \
    mariadb-connector-c-dev \
    bash

echo "🔨  Installing phpunit v${PHPUNIT}"
cd /usr/local/bin && curl -L https://phar.phpunit.de/phpunit-${PHPUNIT}.phar -o phpunit && chmod +x phpunit && chmod 777 .

# Install xdebug config
echo "🔨  Configuring xdebug"
cat <<EOF > /etc/php$PHP_VERSION/conf.d/50_xdebug.ini
zend_extension=xdebug.so
xdebug.mode=debug
xdebug.start_with_request=yes
xdebug.client_host=host.docker.internal
EOF

# Tell supervisord to restart php-fpm
echo "🔄  Restarting php-fpm"
supervisorctl restart php-fpm

# NOTE: Playwright is not recommended to be installed here
