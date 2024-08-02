#!/bin/php
<?php

if (!(isset($argc) && isset($argv))) {
    echo "No action is possible.";
    exit(1);
}

defined('DS') || define('DS', DIRECTORY_SEPARATOR);

defined('TEST_DIRECTORY') || define('TEST_DIRECTORY', 'test' . DS . 'Codeception');

defined('PROJECT_MODULE_DIRECTORY') || define('PROJECT_MODULE_DIRECTORY', 'modules');
defined('SYSTEM_MODULE_DIRECTORY') || define('SYSTEM_MODULE_DIRECTORY', 'system' . DS . 'modules');
defined('WORKFLOWS_TEST_DIRECTORY') || define('WORKFLOWS_TEST_DIRECTORY', 'system' . DS . 'tests');
defined('BOILERPLATE_TEST_DIRECTORY') || define('BOILERPLATE_TEST_DIRECTORY', TEST_DIRECTORY . DS . 'tests');

defined('UNIT_DIRECTORY') || define('UNIT_DIRECTORY', DS . 'unit');

defined('UNIT_DESTINATION') || define('UNIT_DESTINATION', 'test' . DS . 'unit');

defined('SHARED_SOURCE') || define('SHARED_SOURCE', 'boilerplate');
defined('SHARED_CORE') || define('SHARED_CORE', 'workflows');

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
        $cmdMaker['tests'][] =
            [
                'request' =>  "unit", 'message' => "Launching UnitTest", 'function' => "genericRunner", 'args' => true,
                'hint' => "moduleName or all"
            ];
        $cmdMaker['tests'][] =
            [
                'request' =>  "module", 'message' => "Launching Tests on Module", 'function' => "genericRunner", 'args' => true,
                'hint' => "moduleName"
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

    // we cared a lot about this for ordered module names on accpetance tests
    // but more generally, it seems an oblique insistence to sort only some test catagories?
    // if(!empty($found['UnitTests'])) {
    //     ksort($found["UnitTests"]);
    // }

    foreach ($found as $capabilities => $capability) {
        if ($capabilities == "UnitTests") {
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
            'option' => "Run all unit tests", 'message' => "Launching UnitTests", 'function' => "unitTestRunner", 'param' => "all"
        ];
}

function moduleRunner($runModule)
{
    unitRunner($runModule);
}


function unitRunner($run_module)
{
    purgeTestCode();
    $run_module = ltrim($run_module);
    $run_module = empty($run_module) ? "all" : $run_module;
    $found = chaseModules($run_module);

    foreach ($found as $capabilities => $capability) {
        if ($capabilities == "UnitTests") {
            foreach ($capability as $module => $resources) {
                if ($module == $run_module || $run_module == "all") {
                    foreach ($resources as $resource) {
                        $file_name = PHPUNIT_RUN . "  " . UNIT_DESTINATION . DS . $resource . " ";
                        $packBar = "\n*" . str_repeat("-", strlen($file_name) + 12) . "*\n";
                        echo $packBar . "| " . "\e[31m" . $file_name . " \e[39m| \e[31mTESTING \e[39m|" . $packBar;
                        $output = [];
                        $status_code = 0;

                        // Execute unit test, saving the output and status code.
                        executeUnitTest($file_name, $output, $status_code);

                        // If we received a non-zero status code, the test failed. Print the output to console.
                        if ($status_code !== 0) {
                            echo $packBar . "| " . "\e[31m" . $file_name . " \e[39m| \e[31mFAILED! \e[39m|" . $packBar;

                            foreach ($output as $o) {
                                echo "\e[31m$o\n\e[39m";
                            }

                            exit($status_code);
                        }
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

function unitTestRunner()
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
    $found = chaseModules("all");
    reportModules($found);

    echo "\n --- To launch: --- \ncmfiveTests module [module]\n\n";


    if ($argc > 1) {
        switch (strtolower($argv[1])) {
            case "unit":
                $unitModule = "";
                if ($argc > 2) {
                    $unitModule = "  " . $argv[2];
                }
                unitRunner($unitModule);
                break;
            case "module":
                $module = "";
                if ($argc > 2) {
                    $module = $argv[2];
                }
                moduleRunner($module);
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
        } else {
            echo "Test runner not enabled in config\n";
        }
    } else {
        echo "system/web.php not found\n";
    }
    return false;
}

function checkTestEnvironment()
{

    if (
        Config::get("database.backups.commandPath")
        && Config::get("database.backups.backupCommand")
        && Config::get("database.backups.restoreCommand")
    ) {
        echo "Found: TestDB configuration\n";
    } else {
        echo "Useful TestRunner configuration not found in config.php\n";
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



/**
 * Calls exec on the $file_name parameter, and passes the $output and $status_code
 * parameters back as references.
 *
 * @param string $file_name
 * @param array<string>|null $output
 * @param string $status_code
 * @return void
 */
function executeUnitTest(string $file_name, ?array &$output, string &$status_code): void
{
    try {
        exec("cd " . ROOT_PATH . " && phpunit " . $file_name, $output, $status_code);
    } catch (Exception $e) {
        echo $e->getMessage();
    }
}

function purgeTestCode()
{
    if (strtoupper(substr(PHP_OS, 0, 3)) === 'WIN') {
        exec('del ' . UNIT_DESTINATION . DS . '*.php');
    } else {
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

                        if (isset($file['unit'])) {
                            $moduleCapabilities['UnitTests'][$module][] =  $file['unit'];
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

    $extended_paths = [UNIT_DIRECTORY];
    $dest_paths = [
        UNIT_DIRECTORY => UNIT_DESTINATION
    ];

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

                        if ($ext == UNIT_DIRECTORY) {
                            $modFile = $module . "/" . $file;
                            $details['unit'] = $modFile;
                            //Create $module directory if it doesn't exist
                            if (!is_dir(ROOT_PATH . DS . $dest_paths[$ext] . DS . $module)) {
                                mkdir(ROOT_PATH . DS . $dest_paths[$ext] . DS . $module);
                            }
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

// // unused now, no silent option!
// function getUserInput($prompt = "Command: ")
// {
//     $command = '';
//     if (strtoupper(substr(PHP_OS, 0, 3)) === 'WIN') {
//         echo $prompt;
//         $command = stream_get_line(STDIN, 1024, PHP_EOL);
//     } else {
//         $command = readline($prompt);
//     }

//     return $command;
// }
