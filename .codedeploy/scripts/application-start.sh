#/bin/bash

cd /var/www/cmfive-boilerplate
docker-compose up -d

docker exec -it $(docker-compose ps -q webapp) ./composer.phar self-update --2

# Temp fix, remove once Config::setFromS3Object is in master.
composer/vendor/2pisoftware/cmfive-core
git checkout feature/ConfigSetFromS3
cd ../../../..

docker exec -it $(docker-compose ps -q webapp) php cmfive.php install core
docker exec -it $(docker-compose ps -q webapp) php cmfive.php seed encryption
docker exec -it $(docker-compose ps -q webapp) php cmfive.php install migrations