#/bin/bash

# Install updates.
sudo apt update
sudo apt upgrade -y
sudo apt autoclean
sudo apt autoremove -y

# Reload any environment variables that have been set since the last restart.
source /etc/profile

# Create the Cmfive container.
cd /var/www/cmfive-boilerplate
docker-compose up -d

# Run migrations.
docker exec nginx-php7.4 php cmfive.php install migrations
