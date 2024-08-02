#!/bin/bash

# ================================================================
# Prepare and install Cmfive
# ================================================================

set -e

cd /var/www/html

#Clear cache
rm -f cache/config.cache

#if SKIP_CMFIVE_AUTOSETUP is defined, exit
if [ "$SKIP_CMFIVE_AUTOSETUP" = true ]; then
    echo "Skipping setup"
    #Let container know that everything is finished
    touch /home/cmfive/.cmfive-installed
    exit 0
fi

echo "🏗️  Setting up Cmfive"

#Copy the config template if config.php doens't exist
if [ ! -f config.php ]; then
    echo "Installing config.php"
    cp /bootstrap/config.default.php config.php
fi

#Ensure necessary directories have the correct permissions
echo "Setting permissions"
chmod ugo=rwX -R cache/ storage/ uploads/

# ------------------------------------------------
# Setup Cmfive
# ------------------------------------------------

echo "Running cmfive.php actions"
echo

# Ensure system files are installed to /system
function checkSymlink() {
    pushd /var/www/html
    from_dir="composer/vendor/2pisoftware/cmfive-core/system"
    link_name="system"
    if [ -L "$link_name" ]; then
        echo "✅  System dir is a symlink"
    else
        # Remove if it's a file or dir
        if [ -f "$link_name" ] || [ -d "$link_name" ]; then
            echo "❌  Removing existing system dir"
            rm -rf "$link_name"
        fi
        echo "➕  Creating system dir"
        ln -s "$from_dir" "$link_name"
        if [ $? -eq 0 ]; then
            echo "✅  Symlink created from $from_dir to $link_name"
        else
            echo "❌  Failed to create symlink from $from_dir to $link_name"
        fi
    fi
    popd
}

# If system dir exists but composer doesnt print a warning
if [ -f "/var/www/html/system/web.php" ] && [ ! -f "/var/www/html/composer.json" ]; then
    echo "⚠️  Warning: System dir exists but composer packages are missing"
fi

# If CMFIVE_CORE_BRANCH is set print to logs
if [ -n "$CMFIVE_CORE_BRANCH" ]; then
    echo "Using CMFIVE_CORE_BRANCH [ $CMFIVE_CORE_BRANCH ]"
fi

# System dir and composer packages must exist
if [ ! -f "/var/www/html/system/web.php" ] || [ ! -f "/var/www/html/composer.json" ] || [ -n "$CMFIVE_CORE_BRANCH" ]; then
    CMFIVE_CORE_BRANCH=${CMFIVE_CORE_BRANCH:-master} # Default to master if not set
    rm -rf /var/www/html/system # Remove system dir to ensure correct core is installed
    echo "➕  Installing core from branch [ $CMFIVE_CORE_BRANCH ]"
    php cmfive.php install core $CMFIVE_CORE_BRANCH
    checkSymlink
    echo "✔️  New core installed"
else
    echo "Using bundled core"
    echo "✔️  Core already installed"
fi

php cmfive.php seed encryption
php cmfive.php install migrations

# if DEVELOPMENT
if [ "$ENVIRONMENT" = "development" ]; then
    echo "🧑‍💻  Development mode"
    echo "Creating admin user"
    php cmfive.php seed admin Admin Admin dev@2pisoftware.com admin admin
fi

#Let container know that everything is finished
echo "=========================="
echo "✅  Cmfive setup complete"
echo "=========================="
touch /home/cmfive/.cmfive-installed
