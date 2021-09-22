#!/bin/bash

echo "Running After Install"

# Rename directory.
mv /var/www/cmfive-boilerplate /var/www/html
cd /var/www/html

# Update permissions.
sudo chown -R www-data:www-data .

# Run migrations.
php cmfive.php install migrations
