#!/bin/php
<?php


if(!(isset($argc)&&isset($argv))) {echo "No action is possible.";exit();}

defined('DS') || define('DS', DIRECTORY_SEPARATOR);
defined('BACKUP_DIRECTORY') || define('BACKUP_DIRECTORY',  'backups' );  
defined('TESTDB_DIRECTORY') || define('TESTDB_DIRECTORY', 'test'. DS . 'Databases');


ini_set('display_errors', 1);
error_reporting(E_ALL);

// so we can find modules & some CM5 functions...
if (!class_exists('Web')) {
    require('system/web.php');
}  
 
if(!isset($menuMaker)) { genericRunnerDB($argc,$argv); }
else { 
    offerMenuDB(); 
    $cmdMaker['DB'] = [  
    [ 'request' =>  "backup" , 'message' => "Backing up database"
          , 'function' => "genericRunnerDB" , 'args' => true   ] ,
          [ 'request' =>  "restore" , 'message' => "Restoring latest backup"
          , 'function' => "genericRunnerDB" , 'args' => true   ] ,
          [ 'request' =>  "sample" , 'message' => "Backing up database as test sample"
          , 'function' => "genericRunnerDB" , 'args' => true   ] ,
          [ 'request' =>  "test" , 'message' => "Restoring test sample database"
          , 'function' => "genericRunnerDB" , 'args' => true   ] ,
    ];  
     }
 

function offerMenuDB() {
    global $menuMaker;
    // $menuMaker[] = 
    // ['option' => "Install database migrations" , 'message' => "Installing migrations"
    // , 'function' => "installMigrations" , 'param' => null  ];
    $menuMaker[] = 
    ['option' => "Backup database" , 'message' => "Backing up database"
    , 'function' => "backup" , 'param' => null  ];
    $menuMaker[] = 
    ['option' => "Restore database" , 'message' => "Restoring database"
    , 'function' => "restoreFromBackups" , 'param' => null  ];

    }
 
 
function genericRunnerDB($argc,$argv) {
    
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
            }
        }  else
        { echo "\n\nPlease use cmfive.php to manage database functions.\n\n"; }

}
 
function forceReConfig() {
    if (strtoupper(substr(PHP_OS, 0, 3)) === 'WIN') { 
        echo exec('del .\cache\config.cache');
    } else { 
        echo exec('rm -f cache/config.cache');
    }
}


function findDBcommand() {
   
    forceReConfig();
    $w = new Web();
    $w->initDB();
    $command = NULL;
    if (strtoupper(substr(PHP_OS, 0, 3)) === 'WIN') {
        $command =  Config::get('admin.database.command.windows');
    } else {
        $command =  Config::get('admin.database.command.unix');
    }
    
    return $command;
}

function adaptDBcommand($targetDB) {
   
    $command = findDBcommand(); 
    if (!empty($command)) {
        $command = str_replace(
                array('$username', '$password', '$dbname', '$filename'), 
                array( 
                       Config::get('database.username'),
                       Config::get('database.password'), 
                       Config::get('database.database'), 
                       $targetDB), 
                      $command); 
        //$command = str_replace(">","<",$command); // can be read or write!
                       //echo($command)."\n";
        return $command; }
        else { return null; }
}

function findBestDB($filedir,$filesep) {
     //echo $filedir."\n";
    $bestDB = ""; $bestTime = DateTime::createFromFormat("Y-m-d-H-i", "0-0-0-0-0");

    $dir = new DirectoryIterator($filedir);
    foreach ($dir as $fileinfo) {
        if (!$fileinfo->isDot()) {
            $filename = $fileinfo->getFilename();
            try {
                $datepart = substr($filename, 0, strpos($filename, ".".$filesep));
                $backuptime = DateTime::createFromFormat("Y-m-d-H-i", $datepart);
                if ($backuptime) { 
                    if($backuptime>$bestTime) {
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

function backup() { 
    backupDB(ROOT_PATH . DS . BACKUP_DIRECTORY);
}

function backupToTest() {
    backupDB(ROOT_PATH . DS . TESTDB_DIRECTORY);
}

function backupDB($filedir) {
    
    $w = new Web();
    $w->initDB();

    $datestamp = date("Y-m-d-H-i");
    //$filedir = ROOT_PATH . DS . BACKUP_DIRECTORY;
         
    $backupformat =  Config::get('admin.database.output');
    echo $backupformat."\n";
    $filename = "{$datestamp}.{$backupformat}";

    $command = adaptDBcommand($filedir . DS . $filename);

    if (!empty($command)) { 
        echo $command . "\n";
        echo (shell_exec($command)."\n");
        echo ("Backup completed to: {$filedir} : {$filename}"."\n");
       
    } else {
        echo("Could not find backup command in ADMIN module configuration.\n");
    }
    echo("\n");
}

function restoreFromBackups() {
    restoreDB(ROOT_PATH . DS . BACKUP_DIRECTORY );
}

function restoreFromTest() {
        restoreDB(ROOT_PATH . DS . TESTDB_DIRECTORY );
}

function restoreDB($filedir) { 

    // toDo? : User CONFIRM - CheckFileExists - forceBackupBeforeRestore
    $w = new Web();
    $w->initDB();
    
    $targetDB = findBestDB($filedir,Config::get('admin.database.output'));
   
    $command = adaptDBcommand($filedir . DS . $targetDB);

    if (!empty($command)) {
        $command = str_replace(["dump",">"],["","<"],$command); 
             echo (shell_exec($command)."\n");
    forceReConfig();
    
        echo ("Restored: {$filedir} : {$targetDB}"."\n");
       
    } else {
        echo("Could not find backup command in ADMIN module configuration.\n");
    }

  
  echo("\n");
}


// function installMigrations() {
//     if (strtoupper(substr(PHP_OS, 0, 3)) === 'WIN') {
//         echo exec('del .\cache\config.cache');
//     } else {
//         echo exec('rm -f cache/config.cache');
//     }

//     if (!class_exists('Web')) {
//         require('system/web.php');
//     }
//     $w = new Web();
//     $w->initDB();
//     // $w->startSession();
//     $_SESSION = [];

//     try {
//         $w->Migration->installInitialMigration();
//         $w->Migration->runMigrations("all");
//         echo "Migrations have run\n";
//     } catch (Exception $e) {
//         echo $e->getMessage();
//     }
// }