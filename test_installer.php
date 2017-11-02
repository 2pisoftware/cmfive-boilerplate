<?php


echo "Cloning testrunner...\n\n";
echo exec('git clone https://iceaxelihne@bitbucket.org/2pisoftware/selenium-testrunner.git iceaxeliehne/selenium-testrunner');
echo "moving to repo directory...\n\n";
echo exec('cd iceaxeliehne/selenium-testrunner');
echo exec('ls');
echo "\n\n";
require_once("Testrunner_class.php");
Testrunner::output("testrunner found", Testrunner::SUCCESS);
echo "\n\n";
echo "Running tests...\n\n";
echo exec('sudo php test_runner.php ../cmfive-boilerplate/ http://localhost:8000');


?>