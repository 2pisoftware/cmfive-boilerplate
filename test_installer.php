<?php

echo exec('mkdir test_runner');
echo exec('cd test_runner');
echo exec('git clone https://iceaxelihne@bitbucket.org/2pisoftware/selenium-testrunner.git');
echo exec('sudo php test_runner.php /.. http://localhost');


?>