#!/bin/php
<?php

if(!(isset($argc)&&isset($argv))) {echo "No action is possible.";exit();}

defined('DS') || define('DS', DIRECTORY_SEPARATOR);

defined('TEST_DIRECTORY') || define('TEST_DIRECTORY',  'test'. DS . 'Codeception' );

defined('PROJECT_MODULE_DIRECTORY') || define('PROJECT_MODULE_DIRECTORY', 'modules');
defined('SYSTEM_MODULE_DIRECTORY') || define('SYSTEM_MODULE_DIRECTORY', 'system' . DS . 'modules');
defined('WORKFLOWS_TEST_DIRECTORY') || define('WORKFLOWS_TEST_DIRECTORY', 'system' . DS . 'tests');
defined('BOILERPLATE_TEST_DIRECTORY') || define('BOILERPLATE_TEST_DIRECTORY', TEST_DIRECTORY . DS . 'tests');



defined('CEST_DIRECTORY') || define('CEST_DIRECTORY', DS .'acceptance');
defined('STEP_DIRECTORY') || define('STEP_DIRECTORY', DS .'acceptance'. DS .'steps');
defined('HELP_DIRECTORY') || define('HELP_DIRECTORY', DS .'acceptance'. DS .'helpers');

defined('CEST_DESTINATION') || define('CEST_DESTINATION',   TEST_DIRECTORY . DS . 'tests' . DS .'acceptance');
defined('STEP_DESTINATION') || define('STEP_DESTINATION',   TEST_DIRECTORY . DS . 'tests' . DS .'_support'. DS .'step'. DS .'acceptance');
defined('HELP_DESTINATION') || define('HELP_DESTINATION',   TEST_DIRECTORY . DS . 'tests' . DS .'_support'. DS .'Helper');
 
defined('SHARED_SOURCE') || define('SHARED_SOURCE', 'boilerplate');
defined('SHARED_CORE') || define('SHARED_CORE', 'workflows');

defined('DEBUG_RUN') || define('DEBUG_RUN', "run --steps --debug acceptance --no-colors");

ini_set('display_errors', 1);
error_reporting(E_ALL);

// so we can find modules & some CM5 functions...
if (!class_exists('Web')) {
    require('system/web.php');
}

// before anything else happens, check testrunner is allowed!
allowRunner();
if(!isset($menuMaker)) { genericRunner($argc,$argv); }
else { 
    offerMenuTests();
    $cmdMaker['test'][] =  
            [ 'request' =>  "run" , 'message' => "Launching TestRunner"
                  , 'function' => "genericRunner" , 'args' => true   ];
    $cmdMaker['tests'][] =  
                  [ 'request' =>  "run" , 'message' => "Launching TestRunner"
                        , 'function' => "genericRunner" , 'args' => true   ];
     }

 

function offerMenuTests() {
    global $menuMaker;
    $menuMaker[] = 
    ['option' => "Build TestRunner (show info)" , 'message' => "TestRunner info" 
    , 'function' => "infoRunner" , 'param' => null  ]; 

    $found=chaseModules("all"); 
    foreach($found as $capabilities => $capability) {
        if($capabilities=="Tests") { 
     
        foreach($capability  as $module => $resources) {
            $menuMaker[] = 
            ['option' => "Run ".$module." tests" , 'message' => "Launching TestRunner: ".$module 
            , 'function' => "moduleRunner" , 'param' =>  $module   ];  
        }  
        } 
    } 
    $menuMaker[] = 
    ['option' => "Run all tests" , 'message' => "Launching TestRunner" 
    , 'function' => "testRunner" , 'param' => null  ];  
    }

function moduleRunner($runModule) {
    purgeTestCode();
        $found=chaseModules("all");
        registerHelpers($found);

    foreach($found as $capabilities => $capability) {
        if($capabilities=="Tests") { 
     
        foreach($capability  as $module => $resources) {
            if($module==$runModule) {
            foreach ($resources as $resource){
                $codeCeptCommand= DEBUG_RUN . "  " . $resource;
                echo $codeCeptCommand."\n";
                launchCodecept($codeCeptCommand);
            }
        }
        }  
        } 
    }   
}

function infoRunner() { genericRunner(null,null); }
function testRunner() { genericRunner(2,["","run"]); }

function genericRunner($argc,$argv) {
        
    purgeTestCode();
    $found=chaseModules("all");
    registerHelpers($found);
    reportModules($found); 
   
    echo "\n --- To launch: --- \ncmfiveTests [run] [module_testfile.php]\n\n";
    $codeCeptCommand= DEBUG_RUN ;

    if ($argc > 1) { 
        $silent = in_array("silent", $argv);
        switch (strtolower($argv[1])) {
            case "run":
                if($argc > 2) { $codeCeptCommand .= "  " . $argv[2]; } 
                //else {   }
                launchCodecept($codeCeptCommand,$silent);
                break; 
            case "clean":
                purgeTestCode();
                break;
            }
        }     
}

function allowRunner()  {
    $w = new Web();
    if((Config::get('tests'))["testrunner" ]=="ENABLED"){return;}; 
    echo "\nTESTRUNNER IS NOT ENABLED\n";
    die();
}

function launchCodecept($param,$silent=false) { 

    if(!$silent) {
        echo "\nWARNING - Running tests will invalidate your current database.\n";
        $OK = getUserInput('Enter "OK" to continue: ' );
    } else $OK = "OK";

    if($OK=="OK") {
         try {
        $runner = "cd " . TEST_DIRECTORY . " && vendor". DS ."bin". DS ."codecept ".$param;
         
        //echo "\n\n" . $runner."\n"; 
        echo shell_exec($runner);
         
        } catch (Exception $e) {
        echo $e->getMessage();
                }
            }
}

function purgeTestCode() {

    if (strtoupper(substr(PHP_OS, 0, 3)) === 'WIN') {
          exec('del ' . CEST_DESTINATION . DS . '*Cest.php');        
          exec('del ' . STEP_DESTINATION . DS . '*.php');
          exec('del ' . HELP_DESTINATION . DS . '*.php');
          exec('del ' . HELP_DESTINATION . DS . '..' . DS . '*.php');
    } else {
          exec('rm -f ' . CEST_DESTINATION . DS . '*Cest.php');
          exec('rm -f ' . STEP_DESTINATION . DS . '*.php');
          exec('rm -f ' . HELP_DESTINATION . DS . '*.php');
          exec('rm -f ' . HELP_DESTINATION . DS . '..' . DS . '*.php');
    }

}            


function reportModules($moduleCapabilities) {

    echo "\nRefreshed:";
    foreach($moduleCapabilities as $capabilities => $capability) {
        echo "\n --- ".$capabilities." ---";
     
    foreach($capability  as $module => $resources) {
        echo "\n".$module.":";
        foreach ($resources as $resource){
            echo " ".$resource;
        }  
        } 
    } echo "\n";
}

function registerHelpers($moduleCapabilities) {
    // nb: extend this? So helpers know where module path is, hence could feed test data (CSV,SQL etc)
    // https://codeception.com/docs/06-ModulesAndHelpers#Dynamic-Configuration-With-Params

    $destPath = BOILERPLATE_TEST_DIRECTORY . DS . "acceptance.suite.yml";
    $HelperYML = fopen($destPath, "w");
     
    if(!$HelperYML) {return;}

        $hdr = "modules:\n            enabled:\n";
        fwrite($HelperYML, $hdr);

    foreach($moduleCapabilities as $capabilities => $capability) { 
        if($capabilities=="Helpers"){
            foreach($capability  as $resources) {
        foreach ($resources as $resource){ 
            fwrite($HelperYML, "                        -  Helper\\".$resource."\n");
            // per notes above, can insert required values here...
                            }  
                            } 
                        }
    };

    fclose($HelperYML);
}




function chaseModules($module_name) {
    
    $moduleCapabilities = [];  
    $w = new Web();
    $w->initDB();
    // $w->startSession();
    // $_SESSION = [];
    	// Read all modules directories for any tests that need to be copied over
		if ($module_name === 'all') {
			foreach($w->modules() as $module) {
				$availableTests[] =  getTestsForModule($module);
			}
		} else {
			$availableTests[] =  getTestsForModule($module_name);
        }
        
        $availableTests[] =  getTestsForModule(SHARED_SOURCE);
        $availableTests[] =  getTestsForModule(SHARED_CORE);
           // var_dump($availableTests);  die();

        foreach($availableTests as $moduleTest) {
         foreach($moduleTest as $module => $fileShift) {
             foreach($fileShift as $file) {
             if (!empty($fileShift)) {
                    
                  try {
                    //echo  "\nCopying " . $file['source'] . " : ";
                      copy($file['source'], $file['dest']);
                    //echo " " . $file['dest'] . "\n";
                    // these need adding to acceptance.suite.yml
                     if(isset($file['helper'])){
                         //echo  $module . " registers ".$file['helper'] . "\n";
                         $moduleCapabilities['Helpers'][$module][] =  $file['helper'];}
                     // these should be individually runnable (returned as list from here!)
                     if(isset($file['cest'])){
                         //echo  $module . " can run ".$file['cest'] . "\n";
                         $moduleCapabilities['Tests'][$module][] =  $file['cest'];}
                     if(isset($file['actor'])){
                            //echo  $module . " extends ".$file['actor'] . "\n";
                            $moduleCapabilities['Actors'][$module][] =  $file['actor'];}
                  } catch (Exception $e) {
                    echo $e->getMessage();
                  }
             }
            }
            }
         }
    return $moduleCapabilities;
    }
     
    
 
  

function getTestsForModule($module) {

    	$availableTests = [];
		
		// Check modules folder
		$module_path =   PROJECT_MODULE_DIRECTORY . DS . $module . DS . "tests"  ;
        $system_module_path =  SYSTEM_MODULE_DIRECTORY . DS . $module . DS . "tests";
        $boiler_path = BOILERPLATE_TEST_DIRECTORY . DS . $module;
        $workflow_path = WORKFLOWS_TEST_DIRECTORY . DS . $module;
        $test_paths = [$module_path, $system_module_path,$boiler_path,$workflow_path];
        
        $extended_paths = array( CEST_DIRECTORY, STEP_DIRECTORY, HELP_DIRECTORY );
        $dest_paths = array ( 
            CEST_DIRECTORY => CEST_DESTINATION , 
            STEP_DIRECTORY => STEP_DESTINATION , 
            HELP_DIRECTORY => HELP_DESTINATION 
                        );

        $findActor="";
        if($module==SHARED_SOURCE) {
        $findActor = CEST_DIRECTORY . DS . "..";
        $extended_paths[] = $findActor;
        $dest_paths[$findActor] =  HELP_DESTINATION . DS . "..";
        }
 
		if (empty($availableTests[$module])) {
			$availableTests[$module] = [];
		}

		foreach($test_paths as $base_path) {
            foreach($extended_paths as $ext) {
                $test_path = $base_path . $ext;
                $full_path = ROOT_PATH . DS . $test_path;
                 //echo $full_path."\n";
			if (is_dir($full_path)) { 
				foreach(scandir($full_path) as $file) {
                    if ( (!is_dir($full_path . DS . $file))
                        && (strtolower(pathinfo($file,PATHINFO_EXTENSION)=="php")) ) { 
                        $modFile = $file;
                         $details = [];
                        
                     if($ext==HELP_DIRECTORY) {  $details['helper']=rtrim($file,".php"); }
                     if($ext==CEST_DIRECTORY) {  
                        $modFile = $module . "_" . $file;
                        $details['cest']= $modFile; }
                     if($ext==STEP_DIRECTORY) { 
                        $modFile = $module . "_" . $file;  
                            $details['actor'] = rtrim($file,".php"); }
                     if($ext==$findActor) {  $details['actor'] = rtrim($file,".php"); }
                        $details['source'] = $full_path . DS . $file; 
                        $details['dest'] = ROOT_PATH . DS . $dest_paths[$ext] . DS . $modFile;
                     
					 $availableTests[$module][$test_path ."::". $file] =  $details;
						 					}
                                }
                            }  
                    }
                } 
		return $availableTests;
    }
   
    function getUserInput($prompt = "Command: ") {
        $command = '';
        if (strtoupper(substr(PHP_OS, 0, 3)) === 'WIN') {
            echo $prompt;
            $command = stream_get_line(STDIN, 1024, PHP_EOL);
        } else {
            $command = readline($prompt);
        }
    
        return $command;
    }
 
  