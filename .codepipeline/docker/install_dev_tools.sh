#!/bin/sh
# Installs the dev tools to the desired cmfive container

## USAGE:
# If you have docker compose running:
#   ./install_dev_tools.sh
# Or specify container name:
#   CONTAINER=cmfive_webapp_1 ./install_dev_tools.sh
# To skip playwright dependencies:
#   SKIP_PLAYWRIGHT=true ./install_dev_tools.sh

#Settings
PHPVERSION=81
PHPUNIT=10

# If CONTAINER is not defined, default to the container name of the webapp service in docker compose
if [ -z "$CONTAINER" ]; then
    CONTAINER=$(docker compose ps -q webapp)
    if [ -z "$CONTAINER" ]; then
        echo "❌  Error: Could not find container name. Please specify the container name with CONTAINER=container_name"
        exit 1
    fi
    echo "💭  Using container from docker compose"
fi

# Check if $CONTAINER is a valid container name or id
if ! docker inspect --type=container "$CONTAINER" >/dev/null 2>&1; then
    echo "❌  Error: Invalid container name or id: $CONTAINER"
    exit 1
fi

echo ""
echo "👷  -- Installing dev tools to container: $CONTAINER --"
echo ""

# Copy cmfive_dev_tools
SCRIPT_DIR=$(dirname "$0")
docker cp "$SCRIPT_DIR/cmfive_dev_tools.sh" "$CONTAINER:/home/cmfive"
if [ $? -ne 0 ]; then
    echo "❌  Error: Could not copy cmfive_dev_tools.sh to container"
    exit 1
fi

# Run cmfive_dev_tools
docker exec $CONTAINER sh -c "PHPUNIT=${PHPUNIT} PHPVERSION=${PHPVERSION} /home/cmfive/cmfive_dev_tools.sh"
if [ $? -ne 0 ]; then
    echo "❌  Error: cmfive_dev_tools.sh failed"
    exit 1
fi

echo ""
echo "👷  -- Installing host machine dev tools --"
echo ""

# If SKIP_PLAYWRIGHT is true skip the rest of the script
if [ "$SKIP_PLAYWRIGHT" = true ]; then
    echo "✔️  Dev tools installed successfully"
    exit 0
fi

# --- Install Playwright dependencies ---
echo "🔨  Installing Playwright dependencies"

# If not Debian or Ubuntu exit the script
if ! command -v apt-get &> /dev/null; then
    echo "⚠️  WARNING: Playwright dependencies are only supported on Debian and Ubuntu"
    echo "✔️  Dev tools installed successfully"
    exit 0
fi

# Check if npm is installed on host machine
if ! command -v npm &> /dev/null; then
    echo "⚠️  WARNING: npm is not installed on this machine. Please install npm and run 'npm install' in the test directory"
    echo "✔️  Dev tools installed successfully"
    exit 0
fi

yes | npx playwright install --with-deps
if [ $? -ne 0 ]; then
    echo "❌  Error: Failed to install Playwright dependencies"
    exit 1
fi

echo "✔️  Dev tools installed successfully"
