#/bin/bash

cd ../..
docker-compose up -d
docker exec -it $(docker-compose ps -q webapp) /bin/bash
./composer.phar self-update --2

# Temp fix, remove once Config::setFromS3Object is in master.
composer/vendor/2pisoftware/cmfive-core
git checkout feature/ConfigSetFromS3
cd ../../../..

php cmfive.php install core
php cmfive.php seed encryption
php cmfive.php install migrations