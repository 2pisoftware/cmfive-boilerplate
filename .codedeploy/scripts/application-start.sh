#/bin/bash

docker-compose up -d
docker exec -it $(docker-compose ps -q webapp) /bin/bash
./composer.phar self-update --2
php cmfive.php install core
php cmfive.php seed encryption
php cmfive.php install migrations