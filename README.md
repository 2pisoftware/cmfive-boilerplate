# cmfive-boilerplate ![Build Status](https://travis-ci.org/adam-buckley/cmfive-boilerplate.svg?branch=master)
A boilerplate project layout for Cmfive
Main documentation is at:
[cmfive.com](https://cmfive.com)

## Installation
This guide assumes a working knowledge on how to set up nginx to serve a PHP application as well as having an empty MySQL database (with user and password) ready to go.

To install Cmfive, clone or download the Boilerplate repository and unpack (if necessary) into a directory of your choosing.

Copy the config.php.example file to config.php and update (at least) the database section to contain the credentials of your Cmfive database, e.g.:

Config::set("database", [
    "hostname"  => "localhost",
    "username"  => "cmfive",
    "password"  => "cmfive",
    "database"  => "cmfive",
    "driver"    => "mysql"
]);

Change any other configuration items as you see fit.

## Detailed Setup
Boilerplate and core have many dependencies, including PHP, MYSQL and NodeJS.
For a manageable approach, containerisation is a good option.
To consciously customise a development or production deployment, become familiar with the resources and deployment strategies shown in:
```
.codepipeline/README.md
```

## Complete setup by running "php cmfive.php"
Running through commands will get you set up and ready to go.  
Here is an explanation of each command:

## Install Core Libraries
Will install any third party libraries Cmfive requires via Composer (the composer executable is bundled with the Boilerplate repo)
## Install Database Migrations
Will install all Cmfive migrations
## Seed Admin User
Will set up an administrator user, needed to log in to a new Cmfive install
## Generate Encryption Keys
Will generate encryption keys used by Cmfive, for secure Database fields

## Build core templates
With core installed, use npm to formalise available template components and styling: 
```
cd system/templates/base
npm ci
npm run prod
```