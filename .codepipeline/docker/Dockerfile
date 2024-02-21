# ==========================================================================
# ## Cmfive image ##
# ==========================================================================

# This will build a fully working cmfive from the boilerplate image.

# --------------------------------------------------------------------------
# == Core stage ==
# --------------------------------------------------------------------------

# This stage clones the cmfive-core repository and compiles the theme

FROM node:18-alpine AS core

# Install git
RUN apk --no-cache add \
    git

# Clone github.com/2pisoftware/cmfive-core
RUN git clone --depth 1 https://github.com/2pisoftware/cmfive-core

# Compile the theme
RUN cd /cmfive-core/system/templates/base && npm install && npm run production

# --------------------------------------------------------------------------
# == Final stage ==
# --------------------------------------------------------------------------

# This stage copies the core, installs cmfive packages and copies the theme. 
# It is based on the cmfive-boilerplate image from the root directory.

FROM cmfive-boilerplate:latest AS cmfive
WORKDIR /var/www/html
COPY --chown=cmfive:cmfive \
    --from=core \
    /cmfive-core/system/ \
    composer/vendor/2pisoftware/cmfive-core/system/

# Link system
RUN ln -s composer/vendor/2pisoftware/cmfive-core/system/ system

# Install core
RUN su cmfive -c 'if [ ! -f /var/www/html/config.php ]; then \
        touch /var/www/html/config.php; \
        php cmfive.php install core; \
        rm /var/www/html/config.php; \
    else \
        php cmfive.php install core; \
    fi'

# Copy theme
COPY --chown=cmfive:cmfive \
    --from=core \
    /cmfive-core/system/templates/base/dist \
    system/templates/base/dist

# Fix permissions
RUN chmod -R ugo=rwX cache/ storage/ uploads/
