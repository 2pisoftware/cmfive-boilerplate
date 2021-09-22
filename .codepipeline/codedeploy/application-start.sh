#/bin/bash

echo "Running Application Start"

# Restarting Nginx.
systemctl restart nginx

# Starting supervisord.
supervisord -n -c /etc/supervisord.conf
