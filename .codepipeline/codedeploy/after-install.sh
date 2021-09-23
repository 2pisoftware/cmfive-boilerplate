#!/bin/bash

echo "Running After Install"

# Rename directory.
mv /var/www/cmfive-boilerplate /var/www/html
cd /var/www/html

# Create symlink to system.
sudo ln -s /var/www/html/composer/vendor/2pisoftware/cmfive-core/system /var/www/html/system

# Run migrations.
php cmfive.php install migrations

# Clear the cache.
sudo rm -f cache/config.cache
sudo rm -f cache/classdirectory.cache

# Update permissions.
sudo chown -R www-data:www-data .