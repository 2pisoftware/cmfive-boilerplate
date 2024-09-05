#/bin/bash

if [ "$COSINE_DEPLOYMENT_TYPE" == "docker" ]; then
    exit 0
fi

echo "Running Before Install"

# Install updates.
sudo apt update
DEBIAN_FRONTEND=noninteractive sudo apt upgrade -y
sudo apt autoclean
sudo apt autoremove -y
