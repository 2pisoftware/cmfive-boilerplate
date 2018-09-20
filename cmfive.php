#!/bin/php
<?php

ini_set('display_errors', 1);
error_reporting(E_ALL);

if ($argc >= 3) {
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
                    exit(0);
            }
            break;
        case "seed":
            switch($argv[2]) {
                case "admin":
                    if ($argc < 8) {
                        echo "Error: missing required number of parameters to seed user\nUsage: php cmfive.php seed admin '<firstname>' '<surname>' '<email>' '<username>' '<password>'";
                        exit(1);
                    }

                    echo "Seeding admin user...\n\n";
                    seedAdminUser(array_slice($argv, 3));
                    exit(0);
                default:
                    echo "Unknown seed command\n";
                    exit(1);
            }
        default:
            echo "\nUnknown command\n";
            exit(1);
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
    echo " 4) Generate encryption keys\n";
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

    if (strtoupper(substr(PHP_OS, 0, 3)) === 'WIN') {
        echo exec('mklink /D system composer\vendor\2pisoftware\cmfive-core\system');
        echo exec('del .\cache\config.cache');
    } else {
        echo exec('ln -s composer/vendor/2pisoftware/cmfive-core/system system');
        echo exec('rm -f cache/config.cache');
    }

    if (!class_exists('Web')) {
        require('system/web.php');
    }
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
    if (strtoupper(substr(PHP_OS, 0, 3)) === 'WIN') {
        echo exec('del .\cache\config.cache');
    } else {
        echo exec('rm -f cache/config.cache');
    }

    if (!class_exists('Web')) {
        require('system/web.php');
    }
    $w = new Web();
    $w->initDB();
    // $w->startSession();
    $_SESSION = [];

    try {
        $w->Migration->installInitialMigration();
        $w->Migration->runMigrations("all");
        echo "Migrations have run\n";
    } catch (Exception $e) {
        echo $e->getMessage();
    }
}

function seedAdminUser($parameters = []) {

    if (strtoupper(substr(PHP_OS, 0, 3)) === 'WIN') {
        echo exec('del .\cache\config.cache');
    } else {
        echo exec('rm -f cache/config.cache');
    }

    if (!class_exists('Web')) {
        require('system/web.php');
    }
    $w = new Web();
    $w->initDB();

    // Set up fake session to stop warnings
    $_SESSION = [];

    $admin_contact = new Contact($w);
    $admin_contact->firstname = !empty($parameters[0]) ? $parameters[0] : readConsoleLine("Enter first name: ");
    $admin_contact->lastname = !empty($parameters[1]) ? $parameters[1] : readConsoleLine("Enter last name: ");
    $admin_contact->email = !empty($parameters[2]) ? $parameters[2] : readConsoleLine("Enter email address: ");
    $admin_contact->insert();

    $admin_user = new User($w);
    $admin_user->contact_id = $admin_contact->id;
    $admin_user->login = !empty($parameters[3]) ? $parameters[3] : readConsoleLine("Enter admin login: ");
    $admin_user->is_admin = 1;
    $admin_user->is_active = 1;
    $admin_user->insert();

    $admin_user->setPassword(!empty($parameters[4]) ? $parameters[4] : readConsoleLine("Enter admin password: "));
    $admin_user->update();

    $user_role = new UserRole($w);
    $user_role->user_id = $admin_user->id;
    $user_role->role = "user";
    $user_role->insert();

    echo "Admin user setup successful\n";
}

function generateEncryptionKeys() {
    $key_token = '';
    $key_iv = '';

    if (PHP_VERSION_ID >= 70000) {
        $key_token = random_bytes(32);
        $key_iv = random_bytes(8);
    } else {
        $key_token = openssl_random_pseudo_bytes(32);
        $key_iv = openssl_random_pseudo_bytes(8);
    }

    $key_token = bin2hex($key_token);
    $key_iv = bin2hex($key_iv);

    echo "Encryption keys generated\n";
    file_put_contents('config.php', "\nConfig::set('system.encryption', [\n\t'key' => '{$key_token}',\n\t'iv' => '{$key_iv}'\n]);", FILE_APPEND);
    echo "Keys written to project config\n\n";
}

function readConsoleLine($prompt = "Command: ") {
    $command = '';
    if (strtoupper(substr(PHP_OS, 0, 3)) === 'WIN') {
        echo $prompt;
        $command = stream_get_line(STDIN, 1024, PHP_EOL);
    } else {
        $command = readline($prompt);
    }

    return $command;
}

while(true) {
    printMenu();

    $command = readConsoleLine();

    switch(intval($command)) {
        case 1:
            echo "Installing core libraries...\n\n";
            installCoreLibraries();
            break;
        case 2:
            echo "Installing migrations...\n\n";
            installMigrations();
            break;
        case 3:
            echo "Setting up admin user...\n\n";
            seedAdminUser();
            break;
        case 4:
            echo "Generating encryption keys...\n\n";
            generateEncryptionKeys();
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