<?php


echo "Cloning testrunner...\n\n";
echo exec('git clone https://iceaxelihne@bitbucket.org/2pisoftware/selenium-testrunner.git selenium-testrunner');
echo "moving to repo directory...\n\n";
chdir('selenium-testrunner');
echo exec('ls ~/build/iceaxeliehne/');
echo "\n\n";
require_once("Testrunner_class.php");
Testrunner::output("testrunner found", Testrunner::SUCCESS);
echo "\n\n";
echo "Running tests...\n\n";
echo exec('sudo php test_runner.php ~/build/iceaxeliehne/cmfive-boilerplate/ http://localhost:8000');


?>