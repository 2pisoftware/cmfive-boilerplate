#!/bin/bash
set -e

# Change to up two levels from current script dir
cd $(dirname $0)/../..

# Set TAG to cmfive:latest (default)
TAG=${TAG:-cmfive:latest}

# Optional flag for compiling theme as well, default to true
COMPILE_THEME=${COMPILE_THEME:-true}
if [ "$COMPILE_THEME" = "true" ]; then
    echo " === Compiling theme ==="
    $(dirname $0)/compile-theme.sh
    mkdir -p composer/vendor/2pisoftware/cmfive-core/system/templates/base/dist
    cp -R $(dirname $0)/theme/* composer/vendor/2pisoftware/cmfive-core/system/templates/base/dist
fi

# Optional flag for checking if theme exists, default to true
FAIL_ON_NOTHEME=${FAIL_ON_NOTHEME:-true}
if [ "$FAIL_ON_NOTHEME" = "true" ]; then
    # Check if theme exists (vendor/2pisoftware/cmfive-core/system/templates/base)
    if [ ! -f "composer/vendor/2pisoftware/cmfive-core/system/templates/base/dist/app.css" ]; then
        echo "Theme not found: composer/vendor/2pisoftware/cmfive-core/system/templates/base/app.css"
        exit 1
    fi
fi

# Build the Docker image
echo "=== Building Docker image ==="
docker build --no-cache -t $TAG .

echo "=== Success ==="
echo "Docker image built: $TAG"
 