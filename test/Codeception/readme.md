 
* Check 'acceptance.suite.dist.yml' following content is right for your servers:
```
class_name: CmfiveUI

modules:
  enabled:
    - WebDriver:
        url: http://cmfive.local
        browser: chrome
        wait: 60
        port: 4444 

```
1) replace 'http://cmfive.local' with the url of your site to be tested (including protocol)
2) replace the port with appropriate Webdriver, see 'tests\services':
      ---------------------------------------------------
          Follow Installation Instructions 
          --> https://codeception.com/docs/modules/WebDriver#Selenium
          --> https://codeception.com/docs/modules/WebDriver#ChromeDriver
          Enable RunProcess extension to start/stop Selenium automatically (optional).

Check versions in tests/services:
Launch ChromeDriver = defaults to 9515
Launch Selenium JAR = defaults to 4444 (Selenium can find/launch ChromeDriver automatically if they are in same folder)
      ---------------------------------------------------
 
# Writing Tests
Tests go in:
 /system/modules/[module] (to test core modules&models) 
 /system/tests/workflows (to test highly compound workflows from actions, eg:Selenium tests)
 /modules/[module] (to test eg:CRM modules&models) 
 boilerplate/test/Codeception/tests/boilerplate (to test "bare metal" cm5)

# Running Tests
see --> https://codeception.com/docs/reference/Commands

Running is generally automated by cmfive-boilerplate\cmfiveTests.php
See: cmfive-boilerplate\test\Guide.txt

# Configuration

Config is generally automated by cmfive-boilerplate\cmfiveTests.php

codeception has a hierarcial configuration system.

  suite.yml -> suite.dist.yml -> codeception.yml -> codeception.dist.yml
dist configuration files are commitited  to git and contain generic common configuration. non dist configuration files are not commited to git and contain configuration specific to a developer's setup

 
