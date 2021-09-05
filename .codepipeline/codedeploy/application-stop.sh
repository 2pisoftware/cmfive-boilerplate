#/bin/bash

# Remove the old Cmfive container and files.
if [ -d "/var/www/cmfive-boilerplate" ]; then
    cd /var/www/cmfive-boilerplate
    docker-compose down
    cd
    rm -rf /var/www/cmfive-boilerplate
fi