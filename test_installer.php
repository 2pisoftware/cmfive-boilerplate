<?php


echo "Cloning testrunner...\n\n";
echo exec('git clone https://iceaxelihne@bitbucket.org/2pisoftware/selenium-testrunner.git');
echo exec('ls -l');
echo "Running tests...\n\n";
echo exec('sudo php slenium-testrunner/test_runner.php /iceaxeliehne/cmfive-boilerplate/ http://localhost');


?>