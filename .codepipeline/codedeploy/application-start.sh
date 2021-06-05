#/bin/bash

sudo apt update
sudo apt upgrade -y

cd /var/www/cmfive-boilerplate
docker-compose up -d
docker exec $(cd /var/www/cmfive-boilerplate && docker-compose ps -q webapp) mkdir /var/www/html/storage/log
docker exec $(cd /var/www/cmfive-boilerplate && docker-compose ps -q webapp) mkdir /var/www/html/storage/session
docker exec $(cd /var/www/cmfive-boilerplate && docker-compose ps -q webapp) php cmfive.php install core
docker exec $(cd /var/www/cmfive-boilerplate && docker-compose ps -q webapp) chown -R www-data:www-data /var/www/html
docker exec $(cd /var/www/cmfive-boilerplate && docker-compose ps -q webapp) php cmfive.php install migrations

if [ -f "cache/classdirectory.cache" ]; then
    sudo rm cache/classdirectory.cache
fi
if [ -f "cache/config.cache" ]; then
    sudo rm cache/config.cache
fi
if [ -d "storage/log" ]; then
    sudo rm storage/log/*
fi
if [ -d "storage/session" ]; then
    sudo rm storage/session/*
fi