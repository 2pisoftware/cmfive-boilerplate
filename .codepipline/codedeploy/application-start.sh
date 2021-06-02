#/bin/bash

cd /var/www/cmfive-boilerplate
docker-compose up -d
docker exec $(cd /var/www/cmfive-boilerplate && docker-compose ps -q webapp) php cmfive.php install migrations