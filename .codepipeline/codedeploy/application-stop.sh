#/bin/bash

if [ -d "/var/www/cmfive-boilerplate" ]; then
    cd /var/www/cmfive-boilerplate
    docker-compose down
    cd
    rm -rf /var/www/cmfive-boilerplate
fi