#!/bin/bash
git clone https://iceaxelihne@bitbucket.org/2pisoftware/selenium-testrunner.git selenium-testrunner
cd selenium-testrunner
wget https://ftp.mozilla.org/pub/mozilla.org/firefox/releases/47.0.1/linux-x86_64/en-US/firefox-47.0.1.tar.bz2
tar -xjvf firefox-47.0.1.tar.bz2
wget http://selenium-release.storage.googleapis.com/2.53/selenium-server-standalone-2.53.1.jar -P ./
apt-get install xvfb
xvfb-run -a $current_path/firefox/firefox -CreateProfile 'test_runner $current_path/firefox-profile'
sudo php test_runner.php ~/build/iceaxeliehne/cmfive-boilerplate/ http://cmfive.dev false isaac@2pisoftware.com




