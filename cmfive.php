#!/bin/php
<?php

if (!(isset($argc) && isset($argv))) {
    echo "No action is possible.";
    exit();
}

ini_set('display_errors', 1);
error_reporting(E_ALL);

/*
To add options:

--> * Adding to menu * -->
    $menuMaker[] =
            [
                'option' => "Text will appear in menu",
                'message' => "Text will display when launched",
                'function' => "This function will be called as function() or function(param)",
                'param' => null OR 'param' => "value" OR 'param' => [key array]
                --> * NOTE * --> ONLY ONE PARAMETER IS PASSED
                    you need to provision your function vs param's deliberately!
            ]

--> * Adding to CLI * -->
    $cmdMaker['aSingleWordNameForTheClassOfCommands'][] =
            [
            'request' => "commandToExecute",
            'message' => "Text will display when launched and as CLI help",
            'function' => "This function will be called as function() or function(argc, argv)",
            'args' => true, OR 'args' => false,
            'hint' => "Text will appear as CLI help if args=true",
            "default" => [] OR ['aParameterName' => "aDefaultValue"] OR ['aParameterName' => null]
                --> * NOTE * --> PARAMETERS ARE PASSED AS argc,argv IN CLI STYLE
                    defaults will read off in array order:
                     - hence will begin substituting when 'argv' runs out of entries
                     - a 'null' default value will halt as error error if 'argv' cannot fill
                    you need to provision your function vs param's deliberately!
            ]
        ]

*/

$menuMaker = [
    [
        'option' => "Install core libraries", 'message' => "Installing core libraries", 'function' => "installCoreLibraries", 'param' => "master"
    ],
    [
        'option' => "Install database migrations", 'message' => "Installing migrations", 'function' => "installMigrations", 'param' => null
    ],
    [
        'option' => "Seed admin user", 'message' => "Setting up admin user", 'function' => "seedAdminUser", 'param' => null
    ],
    [
        'option' => "Generate encryption keys", 'message' => "Generating encryption keys", 'function' => "generateEncryptionKeys", 'param' => null
    ],
];

$cmdMaker = [
    'install' => [
        [
            'request' => "core", 'message' => "Installing core libraries", 'function' => "cmdinstallCoreLibraries", 'args' => true,
            'hint' => "cmfive-core reference (default is 'master')", "default" => ['branch' => "master"]
        ],
        [
            'request' => "migration", 'message' => "Installing migrations", 'function' => "installMigrations", 'args' => false
        ],
        [
            'request' => "migrations", 'message' => "Installing migrations", 'function' => "installMigrations", 'args' => false
        ]
    ],
    'seed' => [
        [
            'request' =>  "admin", 'message' => "Setting up admin user", 'function' => "cmdSeedAdminUser", 'args' => true,
            'hint' => "F_name L_name email user password"
        ],
        [
            'request' =>  "encryption", 'message' => "Creating encryption keys", 'function' => "generateEncryptionKeys", 'args' => false
        ]
    ],
    'cmfive' => [
        [
            'request' => "help", 'message' => "Command line options", 'function' => "synopsis", 'args' => false
        ],
        [
            "request" => "export_audit", "message" => "Export audit logs from database according to config", "function" => "exportAuditLog", "args" => false
        ]
    ]

];

include "cmfiveTests.php";

if ($argc >= 3) {
    foreach ($cmdMaker as $command => $does) {
        foreach ($does as $doing) {
            if (($argv[1] == $command) && ($argv[2] == $doing['request'])) {
                echo $command . " - " . $doing['message'] . "...\n\n";
                if ($doing['args']) {
                    $shft = $argv;
                    array_shift($shft);

                    $defaults = $doing['default'] ?? [];
                    $substituted = process_default_arguments($shft, $defaults);

                    $doing['function'](count($substituted ?? []), $substituted);
                } else {
                    $doing['function']();
                }
                exit(0);
            }
        }
    }
    echo "\nUnknown command\n";
    exit(1);
}

function process_default_arguments($parameters, $defaults)
{
    // this lacks smarts & works like a 'stack'
    // because parameters do not come is as keyed values:
    // they are  'argc' count and 'argv[]' array.
    // so, nice key names on defaults are not used for matching
    // but do allow exception message on missing req'd params

    $request = array_slice($parameters, 0, 2);
    $specs = array_slice($parameters, 2);
    $seq = 0;

    foreach ($defaults as $key => $value) {
        if (empty($specs[$seq])) {
            if (is_null($value)) {
                echo "\nParameter: [" . $key . "] must be supplied!\n";
                exit(1);
            } else {
                $specs[$seq] = $value;
            }
        }
        $seq++;
    }

    return array_merge($request, $specs);
}

/////////////////////////////////////////////////////////////////////

$menuMaker[] =
    [
        'option' => "List command options", 'message' => "Command line options", 'function' => "synopsis", 'param' => null
    ];
$menuMaker[] =
    [
        'option' => "Exit (0)", 'message' => "Exiting", 'function' => "justQuit", 'param' => null
    ];

while (true) {
    printMenu($menuMaker);

    $command = readConsoleLine();
    if ($command == "0") {
        justQuit();
    }

    $sel = intval($command);

    if (($sel > 0) && ($sel <= count($menuMaker))) {
        $sel--;
        echo $menuMaker[$sel]['message'] . "...\n\n";
        if (!$menuMaker[$sel]['param']) {
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

function justQuit()
{
    exit(0);
}

function printMenu($menu)
{
    echo   "*************************************";
    echo "\n      Cmfive Installation Tools";
    echo "\n*************************************\n";

    if (!file_exists("config.php")) {
        echo "You need to set up your config.php file first (see example)\n";
        justQuit();
    }

    $i = 1;
    foreach ($menu as $menuEntry) {
        echo $i . ") " . $menuEntry['option'] . "\n";
        $i++;
    }
}

function synopsis()
{
    global $cmdMaker;

    foreach ($cmdMaker as $command => $does) {
        foreach ($does as $doing) {
            echo //__FILE__
                $_SERVER['SCRIPT_NAME'] . " " . $command . " " . $doing['request'];
            if ($doing['args'] && !isset($doing['implied'])) {
                echo " ["
                    . (isset($doing['hint']) ? $doing['hint'] : "args...")
                    . "]";
            }
            echo " - (" . $doing['message'] . ")\n";
        }
    }
    echo "\n";
}

function stepOneYieldsWeb()
{
    // so we can find modules & some CM5 functions...
    $webFind = "system/web.php";
    if (is_readable($webFind)  && !is_dir($webFind)) {
        if (!class_exists('Web')) {
            require($webFind);
        }
        refreshComposerAvailability();
        return true;
    }
    echo "\nOrder of steps is important - can't find CORE INSTALL";
    echo "\nMake sure to locate CORE and arrange SYSTEM symlink\n\n";

    return false;
}

function refreshComposerAvailability()
{
    // in case Composer has pulled new packages
    // after the autoloader already went up from Web
    // (when core is installed, web is used for module configs dependencies)
    // (so autoloader needs flushing when the modules have finally come in)
    $allIncluded = get_declared_classes();
    foreach ($allIncluded as $key => $class) {
        //because our ComposerAutoloader class has a suffixed long-hash:
        if (strpos($class, "ComposerAutoloaderInit") !== false) {
            $composerLoader = $class;
            // OK we found it, so apply this stolen code from:
            // composer\vendor\composer\autoload_real.php
            $map = require 'composer/vendor/composer/autoload_psr4.php';
            foreach ($map as $namespace => $path) {
                // a minimal response, as Psr4 gets us
                // at least the db classes needed for web
                $composerLoader::getLoader()->setPsr4($namespace, $path);
            }
            echo "\nFlicked Composer switch: " . $class . "\n";
        }
    }
}

function cmdinstallCoreLibraries($pCount, $parameters = [])
{
    installCoreLibraries(($pCount > 2) ? $parameters[2] : null, ($pCount > 3) ? $parameters[3] : null);
};

function installCoreLibraries($branch = null, $phpVersion = null)
{
    // name     : 2pisoftware/cmfive-core
    // descrip. :
    // keywords :
    // versions : * master
    // type     : library
    // source   : [git] https://github.com/2pisoftware/cmfive-core develop
    // dist     : []
    // names    : 2pisoftware/cmfive-core

    if (is_null($branch)) {
        echo ("No branch from core repository was specified.\n");
    } else {
        echo ("Installing {$branch} from core repository.\n");
    }

    if (is_null($phpVersion)) {
        echo ("No PHP version for Composer was specified.\n");
    } else {
        echo ("Asserting PHP version ({$phpVersion}) for Composer.\n");
    }

    $composer_json = sketchComposerForCore($branch, $phpVersion);

    file_put_contents('./composer.json', json_encode($composer_json, JSON_PRETTY_PRINT));

    echo exec('php composer.phar install');

    $msg = "";
    $out = 0;
    try {
        if (strtoupper(substr(PHP_OS, 0, 3)) === 'WIN') {
            echo exec('mklink /J system composer\vendor\2pisoftware\cmfive-core\system', $msg, $out);
        } else {
            echo exec('ln -s composer/vendor/2pisoftware/cmfive-core/system system', $msg, $out);
        }
    } catch (Exception $e) {
        echo $e->getMessage();
        $out = 1;
    }
    if ($out !== 0) {
        echo "\nFailed Linking for : \nsystem <---> composer/vendor/2pisoftware/cmfive-core/system";
        echo "\nComposer dependencies will not install for a missing system path";
        echo "\n(Check any permissions, fs mounts, host_vs_container links etc)";
        echo "\nYou may need to rerun this step!\n\n";
    }

    installThirdPartyLibraries($composer_json);
}

function sketchComposerForCore($reference, $phpVersion)
{
    // name     : 2pisoftware/cmfive-core
    // descrip. :
    // keywords :
    // versions : * master
    // type     : library
    // source   : [git] https://github.com/2pisoftware/cmfive-core develop
    // dist     : []
    // names    : 2pisoftware/cmfive-core

    if (is_null($reference) || is_null($phpVersion)) {
        if (PHP_MAJOR_VERSION === 7 && PHP_MINOR_VERSION === 0) {
            $reference = "legacy/PHP7.0";
            $phpVersion = "7.0";
        }
        if (PHP_MAJOR_VERSION === 7 && PHP_MINOR_VERSION === 4) {
            $reference = "legacy/PHP7.4";
            $phpVersion = "7.4";
        }
        if (is_null($reference) || is_null($phpVersion)) {
            $reference = is_null($reference) ? "master" : $reference;
            $phpVersion = is_null($phpVersion) ? (PHP_MAJOR_VERSION .".". PHP_MINOR_VERSION) : $phpVersion;
        }
    }

    echo ("Composer has ref's as " . $reference . " & " . $phpVersion . ".\n");

    $composer_string = <<<COMPOSER
    {
        "name": "2pisoftware/cmfive-boilerplate",
        "version": "1.0",
        "description": "A boilerplate project layout for Cmfive",
        "require": {
            "2pisoftware/cmfive-core": "dev-$reference",
            "aws/aws-sdk-php": "^3.24"
        },
        "config": {
            "vendor-dir": "composer/vendor",
            "cache-dir": "composer/cache",
            "bin-dir": "composer/bin",
            "platform": {
                "php": "$phpVersion"
            }
        },
        "repositories": [
            {

                "type": "package",
                "package": {
                "name": "2pisoftware/cmfive-core",
                "version": "dev-$reference",
                "source": {
                    "url": "https://github.com/2pisoftware/cmfive-core",
                    "type": "git",
                    "reference": "$reference"
                    }
                }
            }
        ]
    }
COMPOSER;
    return json_decode($composer_string, true);
}

function installThirdPartyLibraries(array $composer_json)
{
    if (!stepOneYieldsWeb()) {
        return false;
    }

    if (strtoupper(substr(PHP_OS, 0, 3)) === 'WIN') {
        echo exec('del .\cache\config.cache');
    } else {
        echo exec('rm -f cache/config.cache');
    }

    $w = new Web();

    $dependencies_array = [];
    foreach ($w->modules() as $module) {
        $dependencies = Config::get("{$module}.dependencies");
        if (!empty($dependencies)) {
            $dependencies_array = array_merge($dependencies, $dependencies_array);
        }
    }

    $composer_json['require'] = array_merge($composer_json['require'], $dependencies_array);
    file_put_contents('./composer.json', json_encode($composer_json, JSON_PRETTY_PRINT));

    echo exec('php composer.phar update');
}

function installMigrations()
{
    if (strtoupper(substr(PHP_OS, 0, 3)) === 'WIN') {
        echo exec('del .\cache\config.cache');
    } else {
        echo exec('rm -f cache/config.cache');
    }

    if (!stepOneYieldsWeb()) {
        return false;
    }
    $w = new Web();
    $w->initDB();
    $_SESSION = [];

    try {
        MigrationService::getInstance($w)->installInitialMigration();
        MigrationService::getInstance($w)->runMigrations("all");
        echo "Migrations have run\n";
    } catch (Exception $e) {
        echo $e->getMessage();
    }
}

function cmdSeedAdminUser($pCount, $parameters = [])
{
    $parameters = array_slice($parameters, 2);
    seedAdminUser($parameters);
};

function seedAdminUser($parameters = [])
{
    if (strtoupper(substr(PHP_OS, 0, 3)) === 'WIN') {
        echo exec('del .\cache\config.cache');
    } else {
        echo exec('rm -f cache/config.cache');
    }

    if (!stepOneYieldsWeb()) {
        return false;
    }

    $w = new Web();
    $w->initDB();

    // Set up fake session to stop warnings
    $_SESSION = [];

    $findAdmin = AuthService::getInstance($w)->getObject("User", ["is_admin" => true]);
    if (isset($findAdmin->id)) {
        echo "\nOrder of steps is important - ADMIN USER EXISTS";
        echo "\nSetup will not create multiple admin users\n\n";

        return false;
    }

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
    return true;
}

function generateEncryptionKeys()
{
    if (!stepOneYieldsWeb()) {
        return false;
    }

    if (!empty(Config::get("system.encryption"))) {
        echo "\nOrder of steps is important - KEY ALREADY EXISTS";
        echo "\nSetup will not create multiple encryption keys\n\n";

        return false;
    }
    $key_token = '';
    //$key_iv = '';

    if (PHP_VERSION_ID >= 70000) {
        $key_token = random_bytes(32);
        //$key_iv = random_bytes(8);
    } else {
        $key_token = openssl_random_pseudo_bytes(32);
        //$key_iv = openssl_random_pseudo_bytes(8);
    }

    $key_token = bin2hex($key_token);


    echo "Encryption key generated\n";
    file_put_contents('config.php', "\nConfig::set('system.encryption', [\n\t'key' => '{$key_token}'\n]);", FILE_APPEND);
    echo "Key written to project config\n\n";
    return true;
}

function exportAuditLog()
{
    $w = new Web();
    $w->initDB();

    // Set up fake session to stop warnings
    $_SESSION = [];

    // Get audit logs in chunks, to prevent OOM
    $page = 0;
    $perPage = 100;

    $export_file = "audit" . date('m-d-Y') . ".log";

    $config = Config::get("audit.export_length_seconds", 30 * 24 * 60 * 60); // default 30 days
    $older_than = date("Y-m-d H:i:s", time() - $config);

    do {
        $logs = AuditService::getInstance($w)->getObjects(
            "Audit",
            [ "dt_created <= ?" => $older_than],
            false,
            false,
            "dt_created DESC",
            $page * $perPage,
            $perPage
        );

        $page++;

        $out = array_map(fn (Audit $val) => auditToJson($val), $logs);
        $out = join("\n", $out);

        if (empty($out)) {
            continue;
        }

        file_put_contents($export_file, $out, FILE_APPEND);
    } while (!empty($logs));

    AuditService::getInstance($w)->_db
        ->delete("audit")
        ->where("dt_created <= ?", $older_than)
        ->execute();

    echo "done exporting to " . $export_file;
}

function auditToJson(Audit $val) {
    $ret = [
        "dt_created" => $val->dt_created,
        "created_id" => $val->created_id,
        "module" => $val->module,
        "submodule" => $val->submodule,
        "action" => $val->action,
        "path" => $val->path,
        "ip" => $val->ip,
        "db_action" => $val->db_action,
        "db_class" => $val->db_class,
        "db_id" => $val->db_id,
        "message" => $val->message,
    ];

    return json_encode($ret);
}

function readConsoleLine($prompt = "Command: ")
{
    $command = '';
    if (strtoupper(substr(PHP_OS, 0, 3)) === 'WIN') {
        echo $prompt;
        $command = stream_get_line(STDIN, 1024, PHP_EOL);
    } else {
        $command = readline($prompt);
    }

    return $command;
}
