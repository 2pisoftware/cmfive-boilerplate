# Change this to a PR build if you need to (eg ghcr.io/2pisoftware/cmfive:pr-117)
FROM ghcr.io/2pisoftware/cmfive:develop

# Change this to a different branch or comment out to use the one built in to the image
ENV CMFIVE_CORE_BRANCH=develop

# Install required packages for testing
USER root
RUN apk add --no-cache php81-dom php81-xmlwriter php81-tokenizer php81-ctype mysql-client mariadb-connector-c-dev bash

# Copy test dir
ADD test/ /var/www/html/test/

# Install phpunit
ENV PHPUNIT=8
RUN cd /usr/local/bin && curl -L https://phar.phpunit.de/phpunit-${PHPUNIT}.phar -o phpunit && chmod +x phpunit && chmod 777 .

# Install codeception
RUN chown -R cmfive:cmfive /var/www/html/test
USER cmfive
RUN ls -la /var/www/html/test
RUN cd /var/www/html/test/ && sh ./.install/install.sh

# Install NodeJS and Playwright
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash &&\
    nvm install 18 **\
    npx playwright install --with-deps