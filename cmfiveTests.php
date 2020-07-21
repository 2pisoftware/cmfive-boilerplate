#!/bin/php
<?php

use Symfony\Component\Yaml\Yaml;

if (!(isset($argc) && isset($argv))) {
    echo "No action is possible.";
    exit();
}

defined('DS') || define('DS', DIRECTORY_SEPARATOR);

defined('TEST_DIRECTORY') || define('TEST_DIRECTORY', 'test' . DS . 'Codeception');

defined('PROJECT_MODULE_DIRECTORY') || define('PROJECT_MODULE_DIRECTORY', 'modules');
defined('SYSTEM_MODULE_DIRECTORY') || define('SYSTEM_MODULE_DIRECTORY', 'system' . DS . 'modules');
defined('WORKFLOWS_TEST_DIRECTORY') || define('WORKFLOWS_TEST_DIRECTORY', 'system' . DS . 'tests');
defined('BOILERPLATE_TEST_DIRECTORY') || define('BOILERPLATE_TEST_DIRECTORY', TEST_DIRECTORY . DS . 'tests');

defined('CEST_DIRECTORY') || define('CEST_DIRECTORY', DS . 'acceptance');
defined('STEP_DIRECTORY') || define('STEP_DIRECTORY', DS . 'acceptance' . DS . 'steps');
defined('HELP_DIRECTORY') || define('HELP_DIRECTORY', DS . 'acceptance' . DS . 'helpers');
defined('UNIT_DIRECTORY') || define('UNIT_DIRECTORY', DS . 'unit');

defined('CEST_DESTINATION') || define('CEST_DESTINATION', TEST_DIRECTORY . DS . 'tests' . DS . 'acceptance');
defined('STEP_DESTINATION') || define('STEP_DESTINATION', TEST_DIRECTORY . DS . 'tests' . DS . '_support' . DS . 'step' . DS . 'acceptance');
defined('HELP_DESTINATION') || define('HELP_DESTINATION', TEST_DIRECTORY . DS . 'tests' . DS . '_support' . DS . 'Helper');
defined('UNIT_DESTINATION') || define('UNIT_DESTINATION', 'test' . DS . 'unit');

defined('SHARED_SOURCE') || define('SHARED_SOURCE', 'boilerplate');
defined('SHARED_CORE') || define('SHARED_CORE', 'workflows');

// special parameters to push into .yml, hence find in boilerplate helpers
// 'shared' are explicitly declared
$sharedParam = [
    'testAdminUsername' => 'admin',
    'testAdminPassword' => 'admin',
    'testAdminEmail' => '.@.',
    'testAdminFirstname' => 'admin',
    'testAdminLastname' => 'admin',
    'setupCommand' => 'cmfive.php',
    'DBCommand' => 'cmfiveToolsDB.php',
    'cmfiveModuleList' => ''
];

$sharedParam['boilerplatePath'] = getcwd();

// 'loaded' will come from cmfive config
$loadedParam = [
    'DB_Hostname' =>    "database.hostname",
    'DB_Port'     =>    "database.port",
    'DB_Username' =>    "database.username",
    'DB_Password' =>    "database.password",
    'DB_Database' =>    "database.database",
    'DB_Driver' =>      "database.driver",
    'UA_TestConfig' =>  "tests.config"
];

defined('DEBUG_RUN') || define('DEBUG_RUN', "run --steps --debug acceptance");
defined('PHPUNIT_RUN') || define('PHPUNIT_RUN', "");

ini_set('display_errors', 1);
error_reporting(E_ALL);

// before anything else happens, check testrunner is allowed!
if (allowRunner()) {
    include "cmfiveToolsDB.php";
    echo "\n";

    if (!isset($menuMaker)) {
        genericRunner($argc, $argv);
    } else {
        offerMenuTests();
        $cmdMaker['test'][] =
            [
                'request' =>  "run", 'message' => "Launching TestRunner", 'function' => "genericRunner", 'args' => true
            ];
        $cmdMaker['tests'][] =
            [
                'request' =>  "run", 'message' => "Launching TestRunner", 'function' => "genericRunner", 'args' => true,
                'hint' => "module_FileNameCest.php silent"
            ];
        $cmdMaker['tests'][] =
            [
                'request' =>  "unit", 'message' => "Launching UnitTest", 'function' => "genericRunner", 'args' => true,
                'hint' => "moduleName or all"
            ];
        $cmdMaker['testDB'][] =
            [
                'request' =>  "setup", 'message' => "Batched TestRunner DB setup", 'function' => "genericRunner", 'args' => true,  'implied' => true
            ];
    }
}

function offerMenuTests()
{
    global $menuMaker;
    $menuMaker[] =
        [
            'option' => "Build TestRunner (show info)", 'message' => "TestRunner info", 'function' => "infoRunner", 'param' => null
        ];
    $menuMaker[] =
        [
            'option' => "Setup empty TestRunner DB and Administrator", 'message' => "Batched TestRunner DB setup", 'function' => "DBRunner", 'param' => null
        ];
    $menuMaker[] =
        [
            'option' => "Show Composer module dependencies", 'message' => "Showing Composer module dependencies:", 'function' => "moduleDependencies", 'param' => null
        ];

    $found = chaseModules("all");
    ksort($found["Tests"]);

    foreach ($found as $capabilities => $capability) {
        if ($capabilities == "Tests") {
            foreach ($capability as $module => $resources) {
                $menuMaker[] =
                    [
                        'option' => "Run " . $module . " tests", 'message' => "Launching TestRunner: " . $module, 'function' => "moduleRunner", 'param' =>  $module
                    ];
            }
        }
    }
    $menuMaker[] =
        [
            'option' => "Run all acceptance tests", 'message' => "Launching TestRunner", 'function' => "testRunner", 'param' => null
        ];    
    $menuMaker[] =
        [
            'option' => "Run all unit tests", 'message' => "Launching UnitTests", 'function' => "unitTestRunner", 'param' => "all"
        ];
}

function moduleRunner($runModule)
{
    purgeTestCode();
    registerConfig();
    $found = chaseModules("all");
    registerHelpers($found);
    unitRunner($runModule);

    $silent = false;

    foreach ($found as $capabilities => $capability) {
        if ($capabilities == "Tests") {
            foreach ($capability as $module => $resources) {
                if ($module == $runModule) {
                    foreach ($resources as $resource) {
                        $codeCeptCommand = DEBUG_RUN . "  " . $resource;
                        $packBar = "\nO" . str_repeat("-", strlen($codeCeptCommand) + 2) . "O\n";
                        echo $packBar . "| " . $codeCeptCommand . " |" . $packBar;
                        $silent = launchCodecept($codeCeptCommand, $silent);
                    }
                }
            }
        }
    }
}


function unitRunner($runModule)
{
    purgeTestCode();
    $runModule = ltrim($runModule);
    $runModule = empty($runModule)?"all":$runModule;
    $found = chaseModules($runModule);

    foreach ($found as $capabilities => $capability) {
        if ($capabilities == "UnitTests") {
            foreach ($capability as $module => $resources) {
                if ($module == $runModule || $runModule == "all") {
                    foreach ($resources as $resource) {
                        $unitTestCommand = PHPUNIT_RUN . "  " . UNIT_DESTINATION . DS . $resource . " ";
                        $packBar = "\nO" . str_repeat("-", strlen($unitTestCommand) + 2) . "O\n";
                        echo $packBar . "| " . $unitTestCommand . " |" . $packBar;
                        launchUnitTest($unitTestCommand);
                    }
                }
            }
        }
    }
}

function infoRunner()
{
    genericRunner(null, null);
}
function testRunner()
{
    genericRunner(2, ["", "run"]);
}function unitTestRunner()
{
    genericRunner(2, ["", "unit"]);
}
function DBRunner()
{
    genericRunner(2, ["", "setup"]);
}

function genericRunner($argc, $argv)
{
    purgeTestCode();
    registerConfig();
    $found = chaseModules("all");
    registerHelpers($found);
    reportModules($found);

    echo "\n --- To launch: --- \ncmfiveTests [run] [module_testfile.php] [silent]";
    echo "\n --- Or: --- \ncmfiveTests [unit] [module]\n\n";

    $codeCeptCommand = DEBUG_RUN;

    if ($argc > 1) {
        $silent = in_array("silent", $argv);
        switch (strtolower($argv[1])) {
            case "run":
                if ($argc > 2) {
                    $codeCeptCommand .= "  " . $argv[2];
                }

                launchCodecept($codeCeptCommand, $silent);
                break;
            case "unit":
                $unitModule = "";
                if ($argc > 2) {
                    $unitModule = "  " . $argv[2];
                }
                unitRunner($unitModule);
                break;
            case "clean":
                purgeTestCode();
                break;
            case "setup":
                batchTestSetup();
                break;
        }
    }
}

function allowRunner()
{
    $webFind = "system/web.php";
    if (chaseWeb($webFind)) {
        if (!class_exists('Web')) {
            // Testrunner leans heavily on config, so always reset it
            if (strtoupper(substr(PHP_OS, 0, 3)) === 'WIN') {
                echo exec('del .\cache\config.cache');
            } else {
                echo exec('rm -f cache/config.cache');
            }
            require("system/web.php");
        }
        $w = new Web();
        if (Config::get("tests.testrunner") == "ENABLED") {
            if (!checkTestEnvironment()) {
                echo "Configure Test Runner and database backup in config.php per examples.\n";
                return false;
            }
            return true;
        }
    }
    return false;
}

function checkTestEnvironment()
{

    if (
        Config::get("tests.yaml.- WebDriver:")
        && Config::get("tests.yaml.- Db:")
        && Config::get("database.backups.commandPath")
        && Config::get("database.backups.backupCommand")
        && Config::get("database.backups.restoreCommand")
    ) {
        echo "Found: Codeception configuration\n";
    } else {
        echo "Useful Codeception configuration not found in config.php\n";
        return false;
    }

    return true;
}

function chaseWeb($webFind)
{
    // so we can find modules & some CM5 functions...
    if (is_readable($webFind)  && !is_dir($webFind)) {
        return true;
    }
    return false;
}

function batchTestSetup()
{
    global $sharedParam;

    echo "Starting with backup.\n";
    echo (shell_exec("php cmfive.php DB backup") . "\n");

    if (checkABackup(ROOT_PATH . DS . BACKUP_DIRECTORY) == 0) {
        echo "Stopping, useful backup not confirmed.\n\n";
        return;
    }

    $Mcommand = [
        //"cmfive.php DB backup",
        "cmfiveToolsDB.php purge",
        "cmfive.php install migrations",
        "cmfive.php seed admin "
            . $sharedParam['testAdminUsername'] . " "
            . $sharedParam['testAdminPassword'] . " "
            . $sharedParam['testAdminEmail'] . " "
            . $sharedParam['testAdminFirstname'] . " "
            . $sharedParam['testAdminLastname'],
        "cmfive.php DB sample"
    ];
    foreach ($Mcommand as $command) {
        echo "Batching: " . $command . "\n";
        echo (shell_exec("php " . $command) . "\n");
    }
}


function launchCodecept($param, $silent = false)
{
    $OK = "NO";

    if (!$silent) {
        echo "\nWARNING - Running tests will invalidate your current database.\n";
        echo "(You can silence this warning for subsequent tests.)\n";
        $OK = getUserInput('Enter "OK" or "SILENCE" to continue: ');
    }

    if ($OK == 'SILENCE') {
        $silent = true;
    }
    if ($silent) {
        $OK = "OK";
    }

    if ($OK == "OK") {
        try {
            $runner = "cd " . TEST_DIRECTORY . " && vendor" . DS . "bin" . DS . "codecept " . $param;
            echo shell_exec($runner);
        } catch (Exception $e) {
            echo $e->getMessage();
        }
    }

    return $silent;
}


function launchUnitTest($param)
{
    try {
        $runner = "cd " . ROOT_PATH . " && phpunit " . $param;
        echo $runner;
        echo shell_exec($runner);
    } catch (Exception $e) {
        echo $e->getMessage();
    }
}

function purgeTestCode()
{
    if (strtoupper(substr(PHP_OS, 0, 3)) === 'WIN') {
        exec('del ' . CEST_DESTINATION . DS . '*Cest.php');
        exec('del ' . STEP_DESTINATION . DS . '*.php');
        exec('del ' . HELP_DESTINATION . DS . '*.php');
        exec('del ' . HELP_DESTINATION . DS . '..' . DS . '*.php');        
        exec('del ' . UNIT_DESTINATION . DS . '*.php');
    } else {
        exec('rm -f ' . CEST_DESTINATION . DS . '*Cest.php');
        exec('rm -f ' . STEP_DESTINATION . DS . '*.php');
        exec('rm -f ' . HELP_DESTINATION . DS . '*.php');
        exec('rm -f ' . HELP_DESTINATION . DS . '..' . DS . '*.php');
        exec('rm -f ' . UNIT_DESTINATION . DS . '*.php');
    }
}

function moduleDependencies()
{
    $w = new Web();
    $w->initDB();

    foreach ($w->modules() as $module) {
        $dependencies = Config::get("{$module}.dependencies");
        if (!empty($dependencies)) {
            echo "Module: " . $module;
            foreach ($dependencies as $req => $ver) {
                echo " / " . $req . "->" . $ver;
            }
            echo "\n";
        }
    }
    echo "\n";
}

function reportModules($moduleCapabilities)
{
    echo "\nRefreshed:";
    foreach ($moduleCapabilities as $capabilities => $capability) {
        if ($capabilities != "Paths") {
            echo "\n --- " . $capabilities . " ---";

            foreach ($capability as $module => $resources) {
                echo "\n" . $module . ":";
                foreach ($resources as $resource) {
                    echo " " . $resource;
                }
            }
        }
    }
    echo "\n";
}


function registerConfig()
{
    $destPath = BOILERPLATE_TEST_DIRECTORY . DS . "acceptance.suite.dist.yml";
    $ConfigYML = fopen($destPath, "w");

    if (!$ConfigYML) {
        return;
    }

    $codeceptionConfig = ["modules" => ["enabled" => Config::get("tests.yaml")]];
    if (!$codeceptionConfig) {
        return;
    }
    $hdr = "# Codeception Test Suite Configuration\n#\n" .
        "# Suite for acceptance tests.\n" .
        "# Perform tests in browser using the WebDriver or PhpBrowser.\n" .
        "# If you need both WebDriver and PHPBrowser tests - create a separate suite.\n\n" .
        "class_name: CmfiveUI\n\n";

    fwrite($ConfigYML, $hdr);

    $setup = Yaml::dump($codeceptionConfig, 99);
    $setup = str_replace("'-", "-", $setup);
    $setup = str_replace(":':", ":", $setup);
    fwrite($ConfigYML, $setup);
    fclose($ConfigYML);
}


function registerHelpers($moduleCapabilities)
{
    // Helpers can know where module path is,
    // hence could feed test data (CSV,SQL etc)
    // $sharedParam & registerBoilerplateParametersmake it work

    $destPath = BOILERPLATE_TEST_DIRECTORY . DS . "acceptance.suite.yml";
    $HelperYML = fopen($destPath, "w");

    if (!$HelperYML) {
        return;
    }

    $hdr = "modules:\n            enabled:\n";
    fwrite($HelperYML, $hdr);

    foreach ($moduleCapabilities as $capabilities => $capability) {
        if ($capabilities == "Helpers") {
            foreach ($capability as $handler => $resources) {
                foreach ($resources as $resource) {
                    fwrite($HelperYML, "                        -  Helper\\" . $resource . ":\n");
                    // per notes above, can insert required values here...
                    $from = $moduleCapabilities['Paths'][$handler][0];
                    $from = substr($from, 0, strpos($from, "acceptance")) . "acceptance" . DS;
                    fwrite($HelperYML, "                                    "
                        . "basePath: {$from}\n");
                    if ($handler == SHARED_SOURCE) {
                        registerBoilerplateParameters($HelperYML);
                    }
                    fwrite($HelperYML, "\n");
                }
            }
        }
    };

    fclose($HelperYML);
}


function registerBoilerplateParameters($spoolTo)
{
    global $sharedParam;
    global $loadedParam;

    foreach ($sharedParam as $key => $value) {
        fwrite($spoolTo, "                                    "
            . "{$key}: '{$value}'\n");
    }
    foreach ($loadedParam as $key => $conf) {
        //should be isarray vs string on 'config' then encode as req'd
        $configTyped = Config::get($conf);
        if (is_array($configTyped)) {
            $configTyped = json_encode($configTyped);
        }
        if (is_string($configTyped)) {
            fwrite($spoolTo, "                                    "
                . "{$key}: '" . $configTyped . "'\n");
        }
        if (!isset($configTyped)) {
            fwrite($spoolTo, "                                    "
                . "{$key}: ''\n");
        }
    }
}


function chaseModules($module_name)
{
    global $sharedParam;

    $moduleCapabilities = [];
    $w = new Web();
    $w->initDB();

    // Read all modules directories for any tests that need to be copied over
    if ($module_name === 'all') {
        foreach ($w->modules() as $module) {
            $availableTests[] =  getTestsForModule($module);
            $sharedParam['cmfiveModuleList'] .= ":" . $module;
        }
    } else {
        $availableTests[] =  getTestsForModule($module_name);
    }

    $sharedParam['cmfiveModuleList'] .= ":";
    $availableTests[] =  getTestsForModule(SHARED_SOURCE);
    $availableTests[] =  getTestsForModule(SHARED_CORE);

    foreach ($availableTests as $moduleTest) {
        foreach ($moduleTest as $module => $fileShift) {
            foreach ($fileShift as $from => $file) {
                if (!empty($fileShift)) {
                    try {
                        copy($file['source'], $file['dest']);

                        if (isset($file['helper'])) {
                            $moduleCapabilities['Helpers'][$module][] =  $file['helper'];
                        }

                        // these should be individually runnable (returned as list from here!)
                        if (isset($file['cest'])) {
                            $moduleCapabilities['Tests'][$module][] =  $file['cest'];
                        }
                        if (isset($file['unit'])) {
                            $moduleCapabilities['UnitTests'][$module][] =  $file['unit'];
                        }

                        if (isset($file['actor'])) {
                            $moduleCapabilities['Actors'][$module][] =  $file['actor'];
                        }
                        $moduleCapabilities['Paths'][$module][] = $from;
                    } catch (Exception $e) {
                        echo $e->getMessage();
                    }
                }
            }
        }
    }

    return $moduleCapabilities;
}

function getTestsForModule($module)
{
    $availableTests = [];

    // Check modules folder
    $module_path =   PROJECT_MODULE_DIRECTORY . DS . $module . DS . "tests";
    $system_module_path =  SYSTEM_MODULE_DIRECTORY . DS . $module . DS . "tests";
    $boiler_path = BOILERPLATE_TEST_DIRECTORY . DS . $module;
    $workflow_path = WORKFLOWS_TEST_DIRECTORY . DS . $module;
    $test_paths = [$module_path, $system_module_path, $boiler_path, $workflow_path];

    $extended_paths = [CEST_DIRECTORY, STEP_DIRECTORY, HELP_DIRECTORY, UNIT_DIRECTORY];
    $dest_paths = [
        CEST_DIRECTORY => CEST_DESTINATION,
        STEP_DIRECTORY => STEP_DESTINATION,
        HELP_DIRECTORY => HELP_DESTINATION,
        UNIT_DIRECTORY => UNIT_DESTINATION
    ];

    $findActor = "";
    if ($module == SHARED_SOURCE) {
        $findActor = CEST_DIRECTORY . DS . "..";
        $extended_paths[] = $findActor;
        $dest_paths[$findActor] =  HELP_DESTINATION . DS . "..";
    }

    if (empty($availableTests[$module])) {
        $availableTests[$module] = [];
    }

    foreach ($test_paths as $base_path) {
        foreach ($extended_paths as $ext) {
            $test_path = $base_path . $ext;
            $full_path = ROOT_PATH . DS . $test_path;

            if (is_dir($full_path)) {
                foreach (scandir($full_path) as $file) {
                    if ((!is_dir($full_path . DS . $file))
                        && (strtolower(pathinfo($file, PATHINFO_EXTENSION) == "php"))
                    ) {
                        $modFile = $file;
                        $details = [];

                        if ($ext == HELP_DIRECTORY) {
                            $details['helper'] = rtrim($file, ".php");
                        }
                        if ($ext == CEST_DIRECTORY) {
                            $modFile = $module . "_" . $file;
                            $details['cest'] = $modFile;
                        }
                        if ($ext == STEP_DIRECTORY) {
                            $modFile = $module . "_" . $file;
                            $details['actor'] = rtrim($file, ".php");
                        }
                        if ($ext == UNIT_DIRECTORY) {
                            $modFile = $module . "_" . $file;
                            $details['unit'] = $modFile;
                        }
                        if ($ext == $findActor) {
                            $details['actor'] = rtrim($file, ".php");
                        }
                        $details['source'] = $full_path . DS . $file;
                        $details['dest'] = ROOT_PATH . DS . $dest_paths[$ext] . DS . $modFile;

                        $availableTests[$module][$test_path . "::" . $file] =  $details;
                    }
                }
            }
        }
    }
    return $availableTests;
}

function getUserInput($prompt = "Command: ")
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
