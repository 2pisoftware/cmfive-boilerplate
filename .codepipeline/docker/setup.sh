#!/bin/bash

# ================================================================
# Prepare and install Cosine
# ================================================================

function error {
    echo "❌  $1"

    # Install error banner
    rm -f /var/www/html/banner.php
    
    cp /bootstrap/banner_error.php /var/www/html/banner_error.php

    if [ "$ENVIRONMENT" = "development" ]; then
        # Replace <!--REASON--> with error message in banner_error.php
        echo "Writing error message to banner_error.php"
        sed -i "s/<!--REASON-->/<strong>Reason: </strong>$1/g" /var/www/html/banner_error.php
    fi
    exit 1
}

cd /var/www/html

# Reset things back
cp /bootstrap/banner_starting.php /var/www/html/banner.php
rm /var/www/html/banner_error.php &>/dev/null
rm /home/cmfive/.cmfive-installed &>/dev/null

# Clear cache
rm -f cache/config.cache
if [ $? -ne 0 ]; then
    error "Failed to clear cache"
fi

# if SKIP_CMFIVE_AUTOSETUP is defined, exit
if [ "$SKIP_CMFIVE_AUTOSETUP" = true ]; then
    echo "Skipping setup"
    #Let container know that everything is finished
    touch /home/cmfive/.cmfive-installed
    exit 0
fi

# Wait for database to be ready
if [ -n "$DB_HOST" ]; then
    echo "🔍  Waiting for database to be ready"
    timestamp=$(date +%s)
    secondsToWait=30
    echo "db host = $DB_HOST"
    echo "db username = $DB_USERNAME"
    echo "db password = $DB_PASSWORD"
    mysql -h $DB_HOST -u $DB_USERNAME -p$DB_PASSWORD -e "SHOW DATABASES;"
    until mysql -h $DB_HOST -u $DB_USERNAME -p$DB_PASSWORD -e "SHOW DATABASES;" 2>/dev/null; do
        sleep 1
        echo "SHOW TABLES;" | mysql -h $DB_HOST -u $DB_USERNAME -p$DB_PASSWORD $DB_DATABASE
        current=$(date +%s)
        echo "Time left: $((timestamp + secondsToWait - current)) seconds"
        if [ $((current - timestamp)) -gt $secondsToWait ]; then
            error "Failed to connect to database"
        fi
    done
    echo "Database is ready"
fi

echo "🏗️  Setting up Cosine"

# Copy the config template if config.php doesn't exist
if [ ! -f config.php ]; then
    echo "Installing config.php"
    cp /bootstrap/config.default.php config.php
fi
if [ $? -ne 0 ]; then
    error "Failed to install config.php"
fi

# Add custom config
if [ -n "$CUSTOM_CONFIG" ]; then
    echo "➕  Adding custom config"
    # Remove existing custom config between markers
    sed -i '/# BEGIN CUSTOM CONFIG/,/# END CUSTOM CONFIG/d' config.php
    # Add new custom config
    echo -e "\n# BEGIN CUSTOM CONFIG\n${CUSTOM_CONFIG}\n# END CUSTOM CONFIG" >> config.php
fi
if [ $? -ne 0 ]; then
    error "Failed to add custom config"
fi

#Ensure necessary directories have the correct permissions
echo "Setting permissions"
chmod ugo=rwX -R cache/ storage/ uploads/
if [ $? -ne 0 ]; then
    error "Failed to set permissions"
fi

# ------------------------------------------------
# Setup Cosine
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
    echo "⚠️  CMFIVE_CORE_BRANCH is deprecated, please use INSTALL_CORE_BRANCH"
    INSTALL_CORE_BRANCH=$CMFIVE_CORE_BRANCH
fi

# If INSTALL_CORE_BRANCH is set print to logs
if [ -n "$INSTALL_CORE_BRANCH" ]; then
    echo "🌿 Overriding built in core with branch \"$INSTALL_CORE_BRANCH\""
fi

# System dir and composer packages must exist
if [ ! -f "/var/www/html/system/web.php" ] || [ ! -f "/var/www/html/composer.json" ] || [ -n "$INSTALL_CORE_BRANCH" ]; then
    INSTALL_CORE_BRANCH=${INSTALL_CORE_BRANCH:-main} # Default to main if not set
    rm -rf /var/www/html/system # Remove system dir to ensure correct core is installed
    echo "➕  Installing core from branch [ $INSTALL_CORE_BRANCH ]"
    php cmfive.php install core $INSTALL_CORE_BRANCH
    checkSymlink
    if [ $? -ne 0 ]; then
        error "Failed to install core"
    fi
    echo "✔️  New core installed"
else
    echo "Using bundled core"
    echo "✔️  Core already installed"
fi


php cmfive.php seed encryption
if [ $? -ne 0 ]; then
    error "Failed to seed encryption"
fi
php cmfive.php install migrations
if [ $? -ne 0 ]; then
    error "Failed to install migrations"
fi

# if DEVELOPMENT
if [ "$ENVIRONMENT" = "development" ]; then
    echo "🧑‍💻  Development mode"
    echo "Creating admin user"
    php cmfive.php seed admin admin admin dev@2pisoftware.com admin admin
    if [ $? -ne 0 ]; then
        error "Failed to create admin user"
    fi
fi


#Let container know that everything is finished
echo "=========================="
echo "✅  Cosine setup complete"
echo "=========================="
touch /home/cmfive/.cmfive-installed

# Remove loading banner
rm /var/www/html/banner.php &>/dev/null
