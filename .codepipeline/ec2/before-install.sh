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
