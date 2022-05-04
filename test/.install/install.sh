#!/bin/bash

#setup for Codeception

SCRIPTPATH="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
cd "${SCRIPTPATH}/../Codeception"

export  COMPOSER_ALLOW_SUPERUSER=1 ;
curl -sS https://getcomposer.org/installer | php -- \
        --filename=composer \
        --install-dir=. ;
        
./composer config minimum-stability dev
./composer -q require codeception/codeception:4.1.31 --dev ;

./composer require --no-update codeception/module-asserts \
codeception/module-db \
codeception/module-webdriver \
codeception/module-phpbrowser

./composer update --prefer-source --no-interaction --no-progress --optimize-autoloader --ansi;

vendor/bin/codecept bootstrap ;

chmod -R 774 tests/* ;
mkdir tests/acceptance;
