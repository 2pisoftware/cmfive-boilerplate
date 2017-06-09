#!/bin/php
<?php

ini_set('display_errors', 1);
error_reporting(E_ALL);

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
//,
//    "scripts": {
//        
//    }
//"post-install-cmd": [
//            "php -r \"copy('composer/vendor/2pisoftware/cmfive-core/system/', 'system/');\"",
//            "php cmfive.php install",
//            "composer update"
//        ]
$composer_json = json_decode($composer_string, true);

file_put_contents('./composer.json', json_encode($composer_json,JSON_PRETTY_PRINT));

echo exec('php composer.phar install');

echo exec('cp -r composer/vendor/2pisoftware/cmfive-core/system system');

echo exec('rm cache/config.cache');

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
exit(0);