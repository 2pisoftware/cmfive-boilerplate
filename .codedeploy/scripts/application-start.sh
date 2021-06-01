#/bin/bash

cd /var/www/cmfive-boilerplate
docker-compose down
docker-compose up -d

# Update to Composer V2.
docker exec $(cd /var/www/cmfive-boilerplate && docker-compose ps -q webapp) ./composer.phar self-update --2
# Add the AWS SDK so the config can be loaded from S3.
docker exec $(cd /var/www/cmfive-boilerplate && docker-compose ps -q webapp) ./composer.phar require "aws/aws-sdk-php:^3.24"
docker exec $(cd /var/www/cmfive-boilerplate && docker-compose ps -q webapp) php cmfive.php install core
docker exec $(cd /var/www/cmfive-boilerplate && docker-compose ps -q webapp) ./composer.phar require "aws/aws-sdk-php:^3.24"
docker exec $(cd /var/www/cmfive-boilerplate && docker-compose ps -q webapp) ./composer.phar update
docker exec $(cd /var/www/cmfive-boilerplate && docker-compose ps -q webapp) php cmfive.php install core

docker exec $(cd /var/www/cmfive-boilerplate && docker-compose ps -q webapp) php cmfive.php seed encryption
# Run it twice for some reason?
docker exec $(cd /var/www/cmfive-boilerplate && docker-compose ps -q webapp) php cmfive.php install migrations
docker exec $(cd /var/www/cmfive-boilerplate && docker-compose ps -q webapp) php cmfive.php install migrations

chown -R ubuntu:ubuntu $(pwd)