#/bin/bash

echo "Running Application Start"

# Start Nginx and PHP FPM.
systemctl start nginx
systemctl start php7.4-fpm
