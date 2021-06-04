#/bin/bash

sudo apt update
sudo apt upgrade -y

cd /var/www/cmfive-boilerplate
docker-compose up -d
docker exec $(cd /var/www/cmfive-boilerplate && docker-compose ps -q webapp) php cmfive.php install core
docker exec $(cd /var/www/cmfive-boilerplate && docker-compose ps -q webapp) chown -R www-data:www-data /var/www/html
docker exec $(cd /var/www/cmfive-boilerplate && docker-compose ps -q webapp) php cmfive.php install migrations