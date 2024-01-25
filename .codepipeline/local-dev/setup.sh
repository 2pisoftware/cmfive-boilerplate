#!/bin/bash
set -e

#if SKIP_CMFIVE_AUTOSETUP is defined, exit
if [ "$SKIP_CMFIVE_AUTOSETUP" = true ]; then
    echo "Skipping setup"
    #Let container know that everything is finished
    touch ~/.cmfive-installed
    exit 0
fi

#If ~/.cmfive-installed exists close the script
if [ -f ~/.cmfive-installed ]; then
    echo "Cmfive already installed"
    exit 0
fi
echo "Setting up cmfive"

cd /var/www/html

#Wait 15 seconds for things to start
sleep 15

#Copy the config template if config.php doens't exist
if [ ! -f config.php ]; then
    echo "Installing config.php"
    cp config.php.example config.php
fi

#Allow all permissions to the folders
echo "Setting permissions"
chmod 777 -R cache/ storage/ uploads/

#Setup Cmfive
echo "Running cmfive.php actions"
echo
php cmfive.php install core
php cmfive.php seed encryption
php cmfive.php install migrations
php cmfive.php seed admin Admin Admin dev@2pisoftware.com admin admin

#Let container know that everything is finished
echo "Cmfive setup complete"
touch ~/.cmfive-installed
