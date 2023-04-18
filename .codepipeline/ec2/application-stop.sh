#/bin/bash

echo "Running Application Stop"

# Stop Nginx and PHP FPM.
systemctl stop nginx
systemctl stop php8.1-fpm

# Remove the old files.
if [ -d "/var/www/html" ]; then
    rm -rf /var/www/html
fi
