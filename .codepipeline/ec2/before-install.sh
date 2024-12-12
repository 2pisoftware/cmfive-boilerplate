#/bin/bash

if [ -f /etc/cosine/deployment-type ]; then
    COSINE_DEPLOYMENT_TYPE=$(cat /etc/cosine/deployment-type)
else
    COSINE_DEPLOYMENT_TYPE="classic"
fi

echo "Running Before Install"

# Install updates.
sudo apt update
DEBIAN_FRONTEND=noninteractive sudo apt upgrade -y
sudo apt autoclean
sudo apt autoremove -y
# A 'blank' host, will make an empty /var/www/html if apt update patched nginx!
# So, we will remove it before deploying any new code.
# (This won't delete the incoming code, because DownloadBundle holds it in /opt/codedeploy-agent/, waiting for Install to fire)
if [ -d "/var/www/html" ]; then
    rm -rf /var/www/html
fi

