<?php

echo "making testrunner dir...\n\n";
echo exec('mkdir test_runner');

echo exec('cd test_runner');
echo "Cloning testrunner...\n\n";
echo exec('git clone https://iceaxelihne@bitbucket.org/2pisoftware/selenium-testrunner.git');
echo exec('ls -l /../');
echo "Running tests...\n\n";
echo exec('sudo php slenium-testrunner/test_runner.php /.. http://localhost');


?>