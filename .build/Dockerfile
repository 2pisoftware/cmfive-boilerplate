# FROM php:7.2-apache

# COPY composer.lock composer.json /var/www/
# WORKDIR /var/www

# RUN apt-get update && apt-get install -y \
#     build-essential \
#     mariadb-client \
#     libpng-dev \
#     libjpeg62-turbo-dev \
#     libfreetype6-dev \
#     locales \
#     zip \
#     jpegoptim optipng pngquant gifsicle \
#     vim \
#     unzip \
#     git \
#     curl \
#     libcurl4-gnutls-dev \
#     libxml2-dev \
#     libc-client-dev \
#     libkrb5-dev

# RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# RUN docker-php-ext-install mbstring pdo_mysql gettext session
# # curl dom fileinfo gettext iconv imap intl json ldap mbstring pdo pdo_mysql opcache readline session simplexml standard xml zip
# RUN docker-php-ext-configure gd --with-gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ --with-png-dir=/usr/include/
# RUN docker-php-ext-install gd

# # Setup Apache2 config
# # COPY ./.build/apache/ports.conf /etc/apache2/ports.conf
# # COPY ./.build/apache/000-default.conf /etc/apache2/sites-available/000-default.conf
# # RUN mkdir -p /etc/apache2/ssl/
# # COPY ./.build/certs/cmfive-docker.local-key.pem /etc/apache2/ssl/cmfive-docker.local-key.pem
# # COPY ./.build/certs/cmfive-docker.local.pem /etc/apache2/ssl/cmfive-docker.local.pem

# # RUN a2enmod ssl
# # RUN a2enmod rewrite
# # RUN a2ensite 000-default
# # RUN service apache2 restart

# RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# # Add user for laravel application
# RUN groupadd -g 1000 www
# RUN useradd -u 1000 -ms /bin/bash -g www www

# # Copy existing application directory contents
# COPY . /var/www

# COPY --chown=www:www . /var/www

# # Change current user to www
# USER www

# # Expose port 9000 and start php-fpm server
# EXPOSE 9000
# EXPOSE 9001

# CMD ["apache2-foreground"]

FROM php:7.2-fpm

# Copy composer.lock and composer.json
COPY composer.lock composer.json /var/www/

# Set working directory
WORKDIR /var/www

# Install dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    # mysql-client \
    libpng-dev \
    libjpeg62-turbo-dev \
    libfreetype6-dev \
    locales \
    zip \
    jpegoptim optipng pngquant gifsicle \
    vim \
    unzip \
    git \
    curl \
    libcurl4-gnutls-dev \
    libxml2-dev \
    libc-client-dev \
    libkrb5-dev

# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

RUN php -i

# Install extensions
RUN docker-php-ext-install mbstring pdo_mysql gettext session
# curl dom fileinfo gettext iconv imap intl json ldap mbstring pdo pdo_mysql opcache readline session simplexml standard xml zip
RUN docker-php-ext-configure gd --with-gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ --with-png-dir=/usr/include/
RUN docker-php-ext-install gd

# Install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Add user for laravel application
RUN groupadd -g 1000 www
RUN useradd -u 1000 -ms /bin/bash -g www www

# Copy existing application directory contents
COPY . /var/www

# Copy existing application directory permissions
COPY --chown=www:www . /var/www

# Change current user to www
USER www

# Expose port 9000 and start php-fpm server
EXPOSE 9000
CMD ["php-fpm"]