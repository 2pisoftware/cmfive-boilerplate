#!/bin/bash

#setup for Codeception

SCRIPTPATH="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
cd "${SCRIPTPATH}/../Codeception"

export  COMPOSER_ALLOW_SUPERUSER=1 ;
curl -sS https://getcomposer.org/installer | php -- \
        --filename=composer \
        --install-dir=. ;

./composer -q require codeception/codeception --dev ;

./composer require --no-update codeception/module-asserts \
codeception/module-db \
codeception/module-webdriver \
codeception/module-phpbrowser

./composer update --prefer-dist --no-interaction --optimize-autoloader --apcu-autoloader;

vendor/bin/codecept bootstrap ;

chmod -R 775 tests/* ;
