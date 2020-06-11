#!/bin/php
<?php

if (!(isset($argc) && isset($argv))) {
    echo "No action is possible.";
    exit();
}

defined('DS') || define('DS', DIRECTORY_SEPARATOR);
defined('BACKUP_DIRECTORY') || define('BACKUP_DIRECTORY', 'backups');
defined('TESTDB_DIRECTORY') || define('TESTDB_DIRECTORY', 'test' . DS . 'Databases');

ini_set('display_errors', 1);
error_reporting(E_ALL);

if (allowTestDB()) {
    // "allow" uses config, so this is already done:
    // if (!class_exists('Web')) {
    //     forceReConfig();
    //     require('system/web.php');
    // }

    if (!isset($menuMaker)) {
        genericRunnerDB($argc, $argv);
    } else {
        offerMenuDB();
        $cmdMaker['DB'] = [
            [
                'request' =>  "backup", 'message' => "Backing up database", 'function' => "genericRunnerDB", 'args' => true
            ],
            [
                'request' =>  "restore", 'message' => "Restoring latest backup", 'function' => "genericRunnerDB", 'args' => true
            ],
            [
                'request' =>  "sample", 'message' => "Backing up database as test sample", 'function' => "genericRunnerDB", 'args' => true
            ],
            [
                'request' =>  "test", 'message' => "Restoring test sample database", 'function' => "genericRunnerDB", 'args' => true
            ],
            [
                'request' =>  "check", 'message' => "Checking database availability", 'function' => "genericRunnerDB", 'args' => true
            ]
        ];
    }
}

function allowTestDB()
{
    $webFind = "system/web.php";
    if (chaseWebForDB($webFind)) {
        if (!class_exists('Web')) {
            // DB leans heavily on config, so always reset it
            forceReConfig();
            require("system/web.php");
        }
        $w = new Web();
        if ((Config::get('tests'))["testrunner"] == "ENABLED") {
            if (!checkDBEnvironment()) {
                echo "Please complete DB configuration in config.php per examples.\n";
                return false;
            }
            return true;
        };
    }
    return false;
}

function checkDBEnvironment()
{
    
    if (Config::get("database.backups.commandPath")
        && Config::get("database.backups.backupCommand")
        && Config::get("database.backups.restoreCommand")
    ) {
        echo "Found: database backup configuration\n";
    } else {
        echo "Useful database backup configuration not found in config.php\n";
        return false;
    }
    
    return true;
}

function chaseWebForDB($webFind)
{
    // so we can find modules & some CM5 functions...
    if (is_readable($webFind)  && !is_dir($webFind)) {
        return true;
    }
    return false;
}

function offerMenuDB()
{
    global $menuMaker;
    $menuMaker[] =
        [
            'option' => "Backup database", 'message' => "Backing up database", 'function' => "backup", 'param' => null
        ];
    $menuMaker[] =
        [
            'option' => "Restore database", 'message' => "Restoring database", 'function' => "restoreFromBackups", 'param' => null
        ];
    $menuMaker[] =
        [
            'option' => "Check databases", 'message' => "Checking database availability", 'function' => "checkAllBackups", 'param' => null
        ];
}

function genericRunnerDB($argc, $argv)
{

    if ($argc > 1) {
        switch (strtolower($argv[1])) {
            case "backup":
                backup();
                break;
            case "restore":
                restoreFromBackups();
                break;
            case "sample":
                backupToTest();
                break;
            case "test":
                restoreFromTest();
                break;
            case "check":
                checkAllBackups();
                break;
            case "purge":
                purgeDB();
                break;
        }
    } else {
        echo "\n\nPlease use cmfive.php to manage database functions.\n\n";
    }
}

function forceReConfig()
{
    if (strtoupper(substr(PHP_OS, 0, 3)) === 'WIN') {
        echo exec('del .\cache\config.cache');
    } else {
        echo exec('rm -f cache/config.cache');
    }
}

function findDBcommand()
{
    
    $testDBConfig = Config::get("database.backups");

    $command = null;
    if ($testDBConfig) {
        if (strtoupper(substr(PHP_OS, 0, 3)) === 'WIN') {
            $command['backup'] =  $testDBConfig['backupCommand']['windows'];
        } else {
            $command['backup'] =  $testDBConfig['backupCommand']['unix'];
        }
        if (strtoupper(substr(PHP_OS, 0, 3)) === 'WIN') {
            $command['restore'] = $testDBConfig['restoreCommand']['windows'];
        } else {
            $command['restore'] = $testDBConfig['restoreCommand']['unix'];
        }
        if (strtoupper(substr(PHP_OS, 0, 3)) === 'WIN') {
            $command['path'] =  $testDBConfig['commandPath']['windows'];
        } else {
            $command['path'] =  $testDBConfig['commandPath']['unix'];
        }
        $command['output'] = $testDBConfig['outputExt'];
    }
    
    return $command;
}

function adaptDBcommand($task, $targetDB)
{
    $command = findDBcommand()[$task];
    $path = findDBcommand()['path'];
    echo "\n" . $command . "\nfrom: " . $path . "\nfor: " . $targetDB . "\n";
    if (!empty($command)) {
        $command = $path . str_replace(
            ['$username', '$hostname', '$port', '$password', '$dbname', '$filename'],
            [
                Config::get('database.username'),
                Config::get("database.hostname", "localhost"), //$hostname,
                Config::get("database.port", "3306"), //$port,
                Config::get('database.password'),
                Config::get('database.database'),
                $targetDB
            ],
            $command
        );

        return $command;
    } else {
        return null;
    }
}

function findBestDB($filedir, $filesep)
{
    $bestDB = null;
    $bestTime = DateTime::createFromFormat("Y-m-d-H-i", "0-0-0-0-0");

    $dir = new DirectoryIterator($filedir);
    foreach ($dir as $fileinfo) {
        if (!$fileinfo->isDot()) {
            $filename = $fileinfo->getFilename();
            try {
                $datepart = substr($filename, 0, strpos($filename, "." . $filesep));
                $backuptime = DateTime::createFromFormat("Y-m-d-H-i", $datepart);
                if ($backuptime) {
                    if ($backuptime > $bestTime) {
                        $bestTime = $backuptime;
                        $bestDB = $filename;
                    }
                }
            } catch (Exception $e) {
                // Invalid timestamp
            }
        }
    }
    return $bestDB;
}

function backup()
{
    backupDB(ROOT_PATH . DS . BACKUP_DIRECTORY);
}

function backupToTest()
{
    backupDB(ROOT_PATH . DS . TESTDB_DIRECTORY);
}

function backupDB($filedir)
{
    $datestamp = date("Y-m-d-H-i");

    $backupformat = findDBcommand()['output'];
    $filename = "{$datestamp}.{$backupformat}";

    $command = adaptDBcommand("backup", $filedir . DS . $filename);

    if (!empty($command)) {
        echo (shell_exec($command) . "\n");
        echo ("Backup completed to: {$filedir} : {$filename}" . "\n");
    } else {
        echo ("Could not find backup command in DB configuration.\n");
    }
    echo ("\n");
}

function restoreFromBackups()
{
    restoreDB(ROOT_PATH . DS . BACKUP_DIRECTORY);
}

function restoreFromTest()
{
    restoreDB(ROOT_PATH . DS . TESTDB_DIRECTORY);
}

function checkABackup($path)
{
    $fileType = Config::get('admin.database.output');
    $bkpDir = $path;
    $bkpDB = findBestDB($bkpDir, $fileType);
    $bkpSize = ($bkpDB)?filesize($bkpDir . DS . $bkpDB):0;

    return $bkpSize;
}

function checkAllBackups($message = true)
{
    $fileType = Config::get('admin.database.output');
    $bkpDir = ROOT_PATH . DS . BACKUP_DIRECTORY;
    $tstDir = ROOT_PATH . DS . TESTDB_DIRECTORY;
    $bkpDB = findBestDB($bkpDir, $fileType);
    $tstDB = findBestDB($tstDir, $fileType);
    $bkpSize = ($bkpDB)?filesize($bkpDir . DS . $bkpDB):0;
    $tstSize = ($tstDB)?filesize($tstDir . DS . $tstDB):0;

    $minDB = 64000;

    $bkcmd = print_r(findDBcommand(), true);
    echo str_replace("Array", "Execution:", $bkcmd);

    if ($message) {
        echo "\nWorking backup is: ".($bkpDB ?? "NOT_FOUND")." at ".$bkpDir;
        echo "\nFilesize: ".$bkpSize."\n";
        echo "\nTest database is: ".($tstDB ?? "NOT_FOUND")." at ".$tstDir;
        echo "\nFilesize: ".$tstSize."\n";
        echo "\n\n";
    }

    if (($bkpSize > $minDB) && ($tstSize > $minDB)) {
        return true;
    } else {
        if ($message) {
            echo "WARNING: be sure to create backups!\n\n";
        }
        return false;
    }
}

function restoreDB($filedir)
{
    if (!checkAllBackups(false)) {
        echo ("\nWARNING: Reliable test and backup databases NOT FOUND!\n");
    } else {
        $targetDB = findBestDB($filedir, Config::get('admin.database.output'));

        $command = adaptDBcommand("restore", $filedir . DS . $targetDB);

        if (!empty($command)) {
            echo (shell_exec($command) . "\n");
            forceReConfig(); // in case data supporting modules has changed!
            echo ("Restored: {$filedir} : {$targetDB}" . "\n");
        } else {
            echo ("WARNING: Could not find restore command in DB configuration.\n");
        }
    }

    echo ("\n");
}

function purgeDB()
{
    $w = new Web();

    $w->initDB();

    $query = "SET FOREIGN_KEY_CHECKS = 0;";
    $result = $w->db->sql($query)->execute();

    $query = "SELECT     table_name "
        . "FROM information_schema.tables "
        . "WHERE table_schema = '" . Config::get('database')["database"] . "'";

    $result = $result = $w->db->sql($query)->fetchall();
    foreach ($result as $table) {
        $tb = $table['table_name'];
        $query = "DROP TABLE IF EXISTS " . $tb . ";";
        $result = $w->db->sql($query)->execute();
    }

    $query = "SET FOREIGN_KEY_CHECKS = 1;";
    $result = $w->db->sql($query)->execute();
}
