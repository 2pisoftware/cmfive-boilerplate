#!/bin/bash

echo "Running After Install"

# Copy config files.
cp .codepipeline/configs/fpm/* /etc/php/7.4/fpm/
cp .codepipeline/configs/nginx/nginx.conf /etc/nginx/nginx.conf
cp .codepipeline/configs/nginx/default.conf /etc/nginx/conf.d/default.conf
cp .codepipeline/configs/supervisord.conf /etc/supervisord.conf

# Run migrations.
php cmfive.php install migrations
