#!/bin/sh
# To be run on the container, see install_dev_tools.sh
set -e

echo "🏗️  Installing required system packages"
apk add --no-cache php81-dom php81-xmlwriter php81-tokenizer php81-ctype mysql-client mariadb-connector-c-dev bash

echo "🔨  Installing phpunit v${PHPUNIT}"
cd /usr/local/bin && curl -L https://phar.phpunit.de/phpunit-${PHPUNIT}.phar -o phpunit && chmod +x phpunit && chmod 777 .

echo "🔨  Installing codeception"
chown -R cmfive:cmfive /var/www/html/test
cd /var/www/html/test/ && sh ./.install/install.sh

# NOTE: Playwright is not recommended to be installed here
