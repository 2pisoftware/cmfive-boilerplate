<?php


echo "Cloning testrunner...\n\n";
echo exec('git clone https://iceaxelihne@bitbucket.org/2pisoftware/selenium-testrunner.git selenium-testrunner');
echo "moving to repo directory...\n\n";
chdir('selenium-testrunner');
$current_path = exec('pwd');
echo exec('ls');
echo "\n\n";
require_once("Testrunner_class.php");
Testrunner::output("testrunner found", Testrunner::SUCCESS);
echo "installing firefox...\n\n";
exec("wget https://ftp.mozilla.org/pub/mozilla.org/firefox/releases/47.0.1/linux-x86_64/en-US/firefox-47.0.1.tar.bz2");
exec("tar -xjvf firefox-47.0.1.tar.bz2");
echo "installing selenium server...\n\n";
exec("wget http://selenium-release.storage.googleapis.com/2.53/selenium-server-standalone-2.53.1.jar -P ./");
exec("apt-get install xvfb");
exec("xvfb-run -a $current_path/firefox/firefox -CreateProfile 'test_runner $current_path/firefox-profile'");
echo "\n\n";
echo "Running tests...\n\n";
echo exec('$(which php) test_runner.php ~/build/iceaxeliehne/cmfive-boilerplate/ http://cmfive.dev false isaac@2pisoftware.com');
echo "finshed...\n\n";


?>