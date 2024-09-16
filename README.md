# Cmfive Boilerplate
[![Docker Image](https://github.com/2pisoftware/cmfive-boilerplate/actions/workflows/docker-image.yml/badge.svg)](https://github.com/2pisoftware/cmfive-boilerplate/actions/workflows/docker-image.yml)
[![CI](https://github.com/2pisoftware/cmfive-boilerplate/actions/workflows/ci.yml/badge.svg)](https://github.com/2pisoftware/cmfive-boilerplate/actions/workflows/ci.yml)
[![CodeQL](https://github.com/2pisoftware/cmfive-boilerplate/actions/workflows/github-code-scanning/codeql/badge.svg)](https://github.com/2pisoftware/cmfive-boilerplate/actions/workflows/github-code-scanning/codeql)

Welcome! Cmfive is a framework designed for fast ERP and CRM business software solutions. This project is a modular platform that consists of the boilerplate, a core and optionally additional modules. This is the boilerplate repository which contains everything you need to develop and run Cmfive.

The full documentation is located at [cmfive.com](https://cmfive.com).

## Installing

See [Deploying](#deploying).

## Development

### Quick Start

Follow these steps to get up and running with Cmfive development.

Cmfive development requires Docker and Docker Compose. If you don't have these installed you can download them or follow the instructions from the [Docker website](https://docs.docker.com/get-docker/).

First clone this repository and navigate to the directory:

```sh
git clone https://github.com/2pisoftware/cmfive-boilerplate.git
cd cmfive-boilerplate
```

Next, pull the latest docker images for cmfive:

```sh
docker compose pull
```

Then run the following command to start the development environment:

```sh
docker compose up -d --wait
```

This will start the development environment and run it in the background. Once it's running, you can access the Cmfive installation at [http://localhost:3000](http://localhost:3000). 

The development username is `admin` and the password is `admin`.

The files in the boilerplate repository will now be mounted to **/var/www/html** in the container. You can make changes to the files in the repository and they will be reflected in the container.

To stop the development environment, run:

```sh
# to stop the containers
docker compose down

# or to stop and remove all volumes
docker compose down -v
```

### Contributing

For further information on developing and contributing to cmfive please refer to [CONTRIBUTING.md](CONTRIBUTING.md). 

### Accessing the cmfive installation tools menu

The installation tools menu contains maintenance, setup and testing tools for cmfive. You can access it with the following command:

```sh
docker compose exec -it -u cmfive webapp php cmfive.php
```

Here is some detail on the menu options provided:

- **Install Core Libraries**: This will install any third party libraries Cmfive requires via Composer
- **Install Database Migrations**: This will install all Cmfive database migrations
- **Seed Admin User**: Sets up an administrator user which is needed to log in to a production Cmfive install
- **Generate Encryption Keys**: Generate new encryption keys used by Cmfive for secure Database fields
- **Tests**: Runs a chosen test in the Cmfive test suite

### Development on the cmfive-core repository

When the development environment has started the cmfive-core git repository is cloned on to the boilerplate. If you want to make changes to the core repository you can do so by navigating to the core directory:

```sh
cd composer/vendor/2pisoftware/cmfive-core
```

If you're using Visual Studio Code you can open a terminal then use this command to open the core in a new window:

```sh
code composer/vendor/2pisoftware/cmfive-core
```

For more information about developing on the core repository please refer to the [cmfive-core repository](https://github.com/2pisoftware/cmfive-core).

### Theme development

The theme is located in the core and you can find it in this directory:

```sh
cd composer/vendor/2pisoftware/cmfive-core/system/templates/base
```

As part of the development environment there is a container which compiles the theme as you change it. To view the output of the theme development container run the following command:

```sh
docker compose logs -f compiler
```

### Accessing the cmfive container shell

You can access the cmfive container shell with the following command:

```sh
# for cmfive user access
docker compose exec -it -u cmfive webapp sh
# or for root access
docker compose exec -it -u root webapp sh
```

### Debugging and testing

Ensure you have installed the dev tools first. You can do this by running the following command:

```sh
./.codepipeline/docker/install_dev_tools.sh
```

#### Xdebug

Once you have the dev tools installed you can start debugging in VS Code by running the `Listen for Xdebug` configuration. This will start the debugger and you can set breakpoints in your code.

#### Playwright

To set up and test with playwright, follow the instructions in the [Playwright README](test/playwright/README.md).

#### PHPUnit

To run the PHPUnit tests, you can run the following command:

```sh
docker compose exec -u cmfive webapp php cmfive.php tests unit all
```

## Deploying

### Docker

A docker image for cmfive is available on [GitHub Container Registry](https://github.com/2pisoftware/cmfive-boilerplate/pkgs/container/cmfive). 

You will need to run a mysql or compatible container and link it to the cmfive container. See more information about the mysql container on the [Docker Hub page](https://hub.docker.com/_/mysql).

Here is an example of how to run a cmfive container with docker:

```sh
# Define the configuration details
export DB_DATABASE=cmfive
export DB_USERNAME=cmfive
export DB_PASSWORD=cmfive
export DB_ROOT_PW=root
export CMFIVE_IMAGE=ghcr.io/2pisoftware/cmfive:latest

# Create a network
docker network create cmfive

# Run the mysql container
docker run --name mysql-8 -d -p 3306:3306 \
    -e MYSQL_ROOT_PASSWORD=$DB_ROOT_PW \
    -e MYSQL_DATABASE=$DB_DATABASE \
    -e MYSQL_USER=$DB_USERNAME \
    -e MYSQL_PASSWORD=$DB_PASSWORD \
    --network=cmfive \
    mysql:8

# Run the cmfive container
docker run --name cmfive -d -p 3000:80 \
    -v ./storage:/var/www/html/storage \
    -v ./uploads:/var/www/html/uploads \
    -v ./backups:/var/www/html/backups \
    -e DB_HOST=mysql-8 \
    -e DB_USERNAME=$DB_USERNAME \
    -e DB_PASSWORD=$DB_PASSWORD \
    -e DB_DATABASE=$DB_DATABASE \
    -e ENVIRONMENT=production \
    --network=cmfive \
    $CMFIVE_IMAGE
```

You can then proceed to set up an admin user with:

```sh
docker exec -it -u cmfive cmfive php cmfive.php
```

The following options can be used with the Docker image. You may choose to use for example vanilla docker, docker-compose or Kubernetes. Please consult the documentation for these tools for more information on how to use the options below.

#### Environment variables

- **DB_HOST:** The hostname of the MySQL database server
- **DB_DATABASE:** The name of the database
- **DB_USERNAME:** The username to connect to the database
- **DB_PASSWORD:** The password to connect to the database
- **ENVIRONMENT:** (optional) The environment to run in (development, production). Defaults to production.
- **INSTALL_CORE_BRANCH:** (optional) The branch of the cmfive-core repository to switch to while the container is starting. If not specified it will use the built-in core. Note: If this method is used, the theme will not be compiled automatically for the specified branch.

#### Build args

The following build args are optional and can be used to customise the Docker image if you are building a custom one:

- **BUILT_IN_CORE_BRANCH:** The branch of the cmfive-core repository to bake in at build-time. The theme will also be compiled for this branch. Defaults to `main`.
- **PHP_VERSION:** The version of PHP to use. See alpine linux packages for available versions. Defaults to the version in the Dockerfile (eg 81).
- **UID:** The user ID to use for the cmfive user. Defaults to 1000.
- **GID:** The group ID to use for the cmfive user. Defaults to 1000.

#### Volumes

**Data persistence**:

Here are the directories of the container that should be mounted to volumes if you want to persist data:

- **/var/www/html/storage**: Sessions and logs
- **/var/www/html/uploads**: Uploaded files
- **/var/www/html/backups**: Database backups

**HTTPS**:

A self-signed SSL/TLS certificate is included in the image. If you require a certificate for your domain you can mount your key and certificate files to the following paths:

- **/etc/nginx/nginx.key** - The SSL/TLS key
- **/etc/nginx/nginx.crt** - The SSL/TLS certificate

**Modules**

If you have custom modules you can mount them to the following directory:

- **/var/www/html/modules/name-of-module**

**PHP Configuration**

If you need to customise the PHP configuration you can mount a file to the path `/etc/php/conf.d/` for example:

- **/etc/php/conf.d/99-custom.ini**

If you want to configure PHP-FPM entirely, you can override:

- **/etc/php/php-fpm.conf**, and/or
- **/etc/php/php-fpm.d/www.conf**

**Nginx Configuration**

If you need to customise the Nginx configuration you can mount a file to the path `/etc/nginx/conf.d/` for example:

- **/etc/nginx/conf.d/99-custom.conf**

If you want to customise Nginx entirely, you can override:

- **/etc/nginx/nginx.conf**, and/or
- **/etc/nginx/conf.f/default.conf**

#### Ports

The following ports are exposed by the container, you can map them to different ports on the host:

- **80** - HTTP
- **443** - HTTPS

### Manual setup

Here are the steps to set up cmfive without Docker. Please note that your environment may differ and you may need to adjust these steps accordingly.

Install the following software

- PHP
- MySQL
- Nginx
- NodeJS

Clone the repository

```sh
git clone http://github.com/2pisoftware/cmfive-boilerplate.git
```

Set up a cmfive database and user on MySQL. Consult the MySQL documentation for more information.

Copy config.php.example to config.php and update the database details.

Run `php cmfive.php` and:

- Install Core Libraries
- Install Database Migrations
- Seed Admin User
- Generate Encryption Keys

Navigate to the theme directory (composer/vendor/2pisoftware/cmfive-core/system/templates/base) and run `npm install`.

After that, you can build the production theme with `npm run production`.
