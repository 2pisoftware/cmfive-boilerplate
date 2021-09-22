#/bin/bash

echo "Running Application Stop"

# Remove the old files.
if [ -d "/var/www/cmfive-boilerplate" ]; then
    rm -rf /var/www/cmfive-boilerplate
fi
