#/bin/bash

if [ "$COSINE_DEPLOYMENT_TYPE" == "docker" ]; then
    exit 0
fi

echo "Running Application Start"

# Start Nginx and PHP FPM.
systemctl start nginx
systemctl start php8.1-fpm
