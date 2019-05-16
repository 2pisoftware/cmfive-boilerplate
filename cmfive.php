#!/bin/php
<?php

if(!(isset($argc)&&isset($argv))) {echo "No action is possible.";exit();}

ini_set('display_errors', 1);
error_reporting(E_ALL);

$menuMaker = [ 
    ['option' => "Install core libraries" , 'message' => "Installing core libraries"
             , 'function' => "installCoreLibraries" , 'param' => null ],
    ['option' => "Update third party core dependencies" , 'message' => "Installing 3rd party libraries"
             , 'function' => "installThirdPartyLibraries" , 'param' => null ],
    ['option' => "Install database migrations" , 'message' => "Installing migrations"
             , 'function' => "installMigrations" , 'param' => null  ],
    ['option' => "Seed admin user" , 'message' => "Setting up admin user"
             , 'function' => "seedAdminUser" , 'param' => null  ],
    ['option' => "Generate encryption keys" , 'message' => "Generating encryption keys" 
             , 'function' => "generateEncryptionKeys" , 'param' => null  ],
    ];

$cmdMaker = [ 
    'install' => [
         [ 'request' => "core" , 'message' => "Installing core libraries"
          , 'function' => "installCoreLibraries" , 'args' => false ],
        [ 'request' => "migration" , 'message' => "Installing migrations"
        , 'function' => "installMigrations" , 'args' => false  ],
        [ 'request' => "migrations" , 'message' => "Installing migrations"
        , 'function' => "installMigrations" , 'args' => false  ]  ] ,
    'seed' => [
        [ 'request' =>  "admin" , 'message' => "Setting up admin user"
              , 'function' => "cmdSeedAdminUser" , 'args' => true   ]    ] 
              // need to mimic: seedAdminUser(array_slice($argv, 3));
    
    ];
 
    
    include "cmfiveTests.php";

if ($argc >= 3) {
    
    foreach($cmdMaker as $command => $does) {
        foreach($does as $doing) {
            if(($argv[1]==$command)&&($argv[2]==$doing['request'])) {
             echo $command . " - " . $doing['message'] . "...\n\n";
             if($doing['args']) {
                 $shft = $argv; array_shift($shft);
                 $doing['function']($argc-1,$shft);
                } else  {
                    $doing['function']();
                }
             exit(0);
            }
    }
    }
    echo "\nUnknown command\n";
        exit(1);
   
}

/////////////////////////////////////////////////////////////////////

$menuMaker[] = 
['option' => "List command options" , 'message' => "Command line options" 
, 'function' => "synopsis"  , 'param' => null  ]; 
$menuMaker[] = 
['option' => "Exit (0)" , 'message' => "Exiting" 
, 'function' => "justQuit"  , 'param' => null  ]; 

while(true) {
    printMenu($menuMaker);

    $command = readConsoleLine();
    if($command=="0"){justQuit();}

    $sel=intval($command);
    
    if(($sel>0)&&($sel<=count($menuMaker))) {
        $sel--;
        echo $menuMaker[$sel]['message']."...\n\n";
        if(!$menuMaker[$sel]['param']) {
                $menuMaker[$sel]['function']();
        } else {
            $menuMaker[$sel]['function']($menuMaker[$sel]['param']);
        }
    } else {
        echo "Command not found, please try again\n";
                 echo "\n";
    } 
}

/////////////////////////////////////////////////////////////////////

function justQuit() { exit(0); }

function printMenu($menu) {

    echo   "*************************************";
    echo "\n      Cmfive Installation Tools";
    echo "\n*************************************\n";

    if (!file_exists("config.php")) {
        echo "You need to set up your config.php file first (see example)\n";
        justQuit();
    }
           
    $i=1;    
    foreach ($menu as $menuEntry) {
        //var_dump($menuEntry);
        echo $i.") ".$menuEntry['option']."\n";
        $i++;
    }
}

function synopsis() {
    
    global $cmdMaker;

    foreach($cmdMaker as $command => $does) {
        foreach($does as $doing) { 
             echo //__FILE__ 
             $_SERVER['SCRIPT_NAME']. " " . $command . " " . $doing['request'] ;
             if($doing['args']) {
                 echo " [args...]";
                } echo " - (" . $doing['message'] . ")\n";
             
    }
    }
    echo "\n";
}


function stepOneYieldsWeb() {
    // so we can find modules & some CM5 functions...
    $webFind="system/web.php";
   if (is_readable($webFind)  && !is_dir($webFind)) { 
            if (!class_exists('Web')) {
                require($webFind);
            }
            return true;
       }
       echo "\nOrder of steps is important - can't find CORE INSTALL";
       echo "\nMake sure to locate CORE and arrange SYSTEM symlink\n\n";
       
       return false;
}


function installCoreLibraries() {

    $composer_json = sketchComposerForCore();

    file_put_contents('./composer.json', json_encode($composer_json,JSON_PRETTY_PRINT));

    echo exec('php composer.phar install');

    if (strtoupper(substr(PHP_OS, 0, 3)) === 'WIN') {
        echo exec('mklink /D system composer\vendor\2pisoftware\cmfive-core\system');
        //echo exec('del .\cache\config.cache');
    } else {
        echo exec('ln -s composer/vendor/2pisoftware/cmfive-core/system system');
        //echo exec('rm -f cache/config.cache');
    }

     // if (!class_exists('Web')) {
    //     require('system/web.php');
    // }

     installThirdPartyLibraries($composer_json);

     }

     function sketchComposerForCore() {
         
        // name     : 2pisoftware/cmfive-core
        // descrip. :
        // keywords :
        // versions : * master
        // type     : library
        // source   : [git] https://github.com/2pisoftware/cmfive-core develop
        // dist     : []
        // names    : 2pisoftware/cmfive-core
    
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
                "type": "package",
                "package": {
                "name": "2pisoftware/cmfive-core",
                "version": "master",
                "source": {
                    "url": "https://github.com/2pisoftware/cmfive-core",
                    "type": "git",
                    "reference": "master"
                    }
                }
            }
        ]
    }
COMPOSER;

    return json_decode($composer_string, true);
     }

function installThirdPartyLibraries($composer_json = null) {

    if(!stepOneYieldsWeb()){return false;}

    if (strtoupper(substr(PHP_OS, 0, 3)) === 'WIN') {
        echo exec('del .\cache\config.cache');
    } else {
        echo exec('rm -f cache/config.cache');
    }

    $w = new Web();

    if(!$composer_json) {$composer_json = sketchComposerForCore();}

    $dependencies_array = array();
    foreach($w->modules() as $module) {
    	$dependencies = Config::get("{$module}.dependencies"); var_dump($dependencies);
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

     // if (!class_exists('Web')) {
    //     require('system/web.php');
    // }
    if(!stepOneYieldsWeb()){return false;}
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

function cmdSeedAdminUser($pCount,$parameters = []) { 
    $parameters=array_slice($parameters,2);
    $pCount = count($parameters); 
    seedAdminUser( $parameters);
    };

function seedAdminUser( $parameters = []) { 
    // $parameters=array_slice($parameters,2);
    //  $pCount = count($parameters); 
    if (strtoupper(substr(PHP_OS, 0, 3)) === 'WIN') {
        echo exec('del .\cache\config.cache');
    } else {
        echo exec('rm -f cache/config.cache');
    }

    // if (!class_exists('Web')) {
    //     require('system/web.php');
    // }
    if(!stepOneYieldsWeb()){return false;}

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

 