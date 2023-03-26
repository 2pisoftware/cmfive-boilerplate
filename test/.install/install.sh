#!/bin/bash

#setup for Codeception

SCRIPTPATH="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
cd "${SCRIPTPATH}/../Codeception"

export  COMPOSER_ALLOW_SUPERUSER=1 ;
curl -sS https://getcomposer.org/installer | php -- \
        --filename=composer \
        --install-dir=. ;
        
./composer -q require codeception/codeception:5.0.10 --dev ;
./composer config minimum-stability dev

./composer require -W --no-update codeception/module-asserts:3.0.0 \
codeception/module-db:3.1.0 \
codeception/module-webdriver:4.0.0 \
codeception/module-phpbrowser:3.0.0

./composer update --prefer-source --no-interaction --no-progress --optimize-autoloader --ansi;

php vendor/bin/codecept bootstrap;

chmod -R 777 tests/* ;
# mkdir tests/acceptance;
