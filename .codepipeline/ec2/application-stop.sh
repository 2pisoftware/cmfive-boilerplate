#/bin/bash

if [ -f /etc/cosine/deployment-type ]; then
    COSINE_DEPLOYMENT_TYPE=$(cat /etc/cosine/deployment-type)
else
    COSINE_DEPLOYMENT_TYPE="classic"
fi

if [ "$COSINE_DEPLOYMENT_TYPE" == "docker" ]; then
    exit 0
fi

echo "Running Application Stop"

# Stop Nginx and PHP FPM.
systemctl stop nginx
systemctl stop php8.1-fpm

# Remove the old files.
if [ -d "/var/www/html" ]; then
    rm -rf /var/www/html
fi
