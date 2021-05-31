#/bin/bash

cd /var/www/cmfive-boilerplate
docker-compose up -d

# Update to Composer V2.
docker exec -it $(cd /var/www/cmfive-boilerplate && docker-compose ps -q webapp) ./composer.phar self-update --2
# Update Boilerplate dependencies. This needs to run first to install the AWS SDK so the config can be loaded from S3.
docker exec -it $(cd /var/www/cmfive-boilerplate && docker-compose ps -q webapp) ./composer.phar update

# Temp fix, remove once Config::setFromS3Object is in master.
cd composer/vendor/2pisoftware/cmfive-core
sudo git checkout feature/ConfigSetFromS3
cd ../../../..

docker exec -it $(cd /var/www/cmfive-boilerplate && docker-compose ps -q webapp) php cmfive.php install core
docker exec -it $(cd /var/www/cmfive-boilerplate && docker-compose ps -q webapp) php cmfive.php seed encryption
docker exec -it $(cd /var/www/cmfive-boilerplate && docker-compose ps -q webapp) php cmfive.php install migrations