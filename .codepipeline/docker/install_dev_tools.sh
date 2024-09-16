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

# Tell user if test dir already exists in container (and has greater than 0 files)
if docker exec $CONTAINER sh -c 'test -d "/var/www/html/test" && test "$(ls -A /var/www/html/test | wc -l)" -gt 0'; then
    echo "💭  Test directory exists in the container"
else
    # Find test dir
    TEST_DIR=""
    if test -d "./test"; then
        TEST_DIR="./test"
    elif test -d "../test"; then
        TEST_DIR="../test"
    elif test -d "../../test"; then
        TEST_DIR="../../test"
    fi
    # If test dir is found and the container doesnt have an existing test dir, copy it
    if [ -n "$TEST_DIR" ] ; then
        echo "💭  Using test directory: $TEST_DIR"
        echo "📦  Copying test directory to container"
        docker cp "$TEST_DIR" "$CONTAINER:/var/www/html"
        if [ $? -ne 0 ]; then
            echo "❌  Error: Could not copy test directory to container"
            exit 1
        fi
    else
        # If test dir is not found, exit the script
        echo "❌  Error: Could not find test directory"
        exit 1
    fi
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
docker exec $CONTAINER sh -c "PHPUNIT=${PHPUNIT} /home/cmfive/cmfive_dev_tools.sh"
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
    echo
    echo "There is a containerised version you can run instead"
    echo "    test/playwright/docker_run.sh"
    echo "Or to run a fresh container"
    echo "    test/playwright/docker_run.sh --fresh"
    echo ""
    echo "Alternatively you can use the Visual Studio Code extension"
    echo ""
    echo "✔️  Dev tools installed successfully"
    exit 0
fi

# Check if npm is installed on host machine
if ! command -v npm &> /dev/null; then
    echo "⚠️  WARNING: npm is not installed on this machine."
    echo "Please install npm then install Playwright dependencies"
    echo "✔️  Dev tools installed successfully"
    exit 0
fi

yes | npx playwright install --with-deps
if [ $? -ne 0 ]; then
    echo "❌  Error: Failed to install Playwright dependencies"
    exit 1
fi

echo "✔️  Dev tools installed successfully"
