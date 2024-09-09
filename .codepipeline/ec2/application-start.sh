#/bin/bash

if [ -f /etc/cosine/deployment-type ]; then
    COSINE_DEPLOYMENT_TYPE=$(cat /etc/cosine/deployment-type)
else
    COSINE_DEPLOYMENT_TYPE="classic"
fi

if [ "$COSINE_DEPLOYMENT_TYPE" == "docker" ]; then
    systemctl start cosine

    # Read cosine config
    source /etc/cosine/cosine.conf

    if [ "$CORE_BRANCH" != "main" ]; then
        # Theme will need compiling
        
        # # Copy theme from container to host
        # echo "Copying theme from container to host"
        # docker cp cosine:/var/www/html/system/templates/base /tmp/cmfive-theme
        # cd /tmp/cmfive-theme
        # echo "Compiling theme"
        # docker run --rm \
        #     -v $(pwd):/app \
        #     -w /app \
        #     node:20-alpine sh -c "npm ci && npm run production"
        # # Copy the compiled theme back to the docker container
        # echo "Copying compiled theme back to container"
        # docker cp /tmp/cmfive-theme/. cosine:/var/www/html/system/templates/base

        # NOTE: Commented out the above due to high system requirements
        echo "Theme compilation needed but skipped"
    fi

    exit 0
fi

echo "Running Application Start"

# Start Nginx and PHP FPM.
systemctl start nginx
systemctl start php8.1-fpm
