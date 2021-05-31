#/bin/bash

cd /var/www/cmfive-boilerplate
docker-compose up -d

docker exec -it $(docker-compose ps -q webapp) ./composer.phar self-update --2