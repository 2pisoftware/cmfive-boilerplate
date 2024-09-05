#/bin/bash

if [ -f /etc/cosine/deployment-type ]; then
    COSINE_DEPLOYMENT_TYPE=$(cat /etc/cosine/deployment-type)
else
    COSINE_DEPLOYMENT_TYPE="classic"
fi

if [ "$COSINE_DEPLOYMENT_TYPE" == "docker" ]; then
    exit 0
fi

echo "Running Application Start"

# Start Nginx and PHP FPM.
systemctl start nginx
systemctl start php8.1-fpm
