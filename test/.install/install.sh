#!/bin/bash

#setup for Codeception

cd ../Codeception/ ;

export  COMPOSER_ALLOW_SUPERUSER=1 ;
curl -sS https://getcomposer.org/installer | php -- \
        --filename=composer \
        --install-dir=. ;

./composer -q require codeception/codeception --dev ;

./composer require --no-update \
#codeception/module-apc \
codeception/module-asserts \
#codeception/module-cli \
codeception/module-db \
#codeception/module-filesystem \
#codeception/module-ftp \
#codeception/module-memcache \
#codeception/module-mongodb \
#codeception/module-phpbrowser \
#codeception/module-redis \
#codeception/module-rest \
#codeception/module-sequence \
#codeception/module-soap \
codeception/module-webdriver && \
./composer update --no-dev --prefer-dist --no-interaction --optimize-autoloader --apcu-autoloader;

vendor/bin/codecept bootstrap ;

chmod -R 775 tests/* ;


