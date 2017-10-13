#!/bin/php
<?php

ini_set('display_errors', 1);
error_reporting(E_ALL);

if ($argc == 3) {
    switch($argv[1]) {
        case "install":
            switch($argv[2]) {
                case "core":
                    echo "Installing core libraries...\n\n";
                    installCoreLibraries();
                    exit(0);
                case "migration":
                case "migrations":
                    echo "Installing migrations...\n\n";
                    installMigrations();
                    exit(0);
                default:
                    echo "\nUnknown command\n";
            }
            break;
        default:
            echo "\nUnknown command\n";
    }
}

function printMenu() {
    echo "****************************";
    echo "\n      Cmfive Installer";
    echo "\n****************************\n";

    if (!file_exists("config.php")) {
        echo "You need to set up your config.php file first (see example)\n";
        exit(0);
    }

    echo " 1) Install core libraries\n";
    echo " 2) Install database migrations\n";
    echo " 3) Seed admin user\n";
    echo " 0) Exit\n";
}

function installCoreLibraries() {
    $composer_string = <<<COMPOSER
    {
        "name": "cmfive-boilerplate",
        "version": "1.0",
        "description": "A boilerplate project layout for Cmfive",
        "require": {
            "2pisoftware/cmfive-core": "dev-master"
        },
    	"config": {
            "vendor-dir": "composer/vendor",
            "cache-dir": "composer/cache",
            "bin-dir": "composer/bin"
        },
        "repositories": [
            {
                "type":"package",
                "package": {
                "name": "2pisoftware/cmfive-core",
                "version":"master",
                "source": {
                    "url": "https://github.com/2pisoftware/cmfive-core",
                    "type": "git",
                    "reference":"develop"
                    }
                }
            }
        ]
    }
COMPOSER;

    $composer_json = json_decode($composer_string, true);

    file_put_contents('./composer.json', json_encode($composer_json,JSON_PRETTY_PRINT));

    echo exec('php composer.phar install');

    echo exec('ln -s composer/vendor/2pisoftware/cmfive-core/system system');

    echo exec('rm -f cache/config.cache');

    require('system/web.php');
    $w = new Web();

    $dependencies_array = array();
    foreach($w->modules() as $module) {
    	$dependencies = Config::get("{$module}.dependencies");
    	if (!empty($dependencies)) {
    		$dependencies_array = array_merge($dependencies, $dependencies_array);
    	}
    }

    $composer_json['require'] = array_merge($composer_json['require'], $dependencies_array);
    file_put_contents('./composer.json', json_encode($composer_json,JSON_PRETTY_PRINT));

    echo exec('php composer.phar update');
}

function installMigrations() {
    echo exec('rm -f cache/config.cache');

    require('system/web.php');
    $w = new Web();
    $w->initDB();

    try {
        $w->Migration->installInitialMigration();
        $w->Migration->runMigrations("all");
        echo "Migrations have run\n";
    } catch (Exception $e) {
        echo $e->getMessage();
    }
}

function seedAdminUser() {

}

while(true) {
    printMenu();

    $command = '';
    if (PHP_OS == 'WINNT') {
        echo 'Command: ';
        $command = stream_get_line(STDIN, 1024, PHP_EOL);
    } else {
        $command = readline('Command: ');
    }

    switch(intval($command)) {
        case 1:
            echo "Installing core libraries...\n";
            echo "\n";
            installCoreLibraries();
            break;
        case 2:
            echo "Installing migrations...\n";
            echo "\n";
            installMigrations();
            break;
        case 3:
            echo "Setting up admin user...\n";
            echo "\n";
            seedAdminUser();
            break;
        case 0:
            echo "Exiting...";
            exit(0);
            break;
        default:
            echo "Command not found, please try again\n";
            echo "\n";
    }
}