#!/bin/bash

echo "Running After Install"

# Run migrations.
cd /var/www/cmfive-boilerplate
php cmfive.php install migrations
