<?php

namespace Helper;

use PDO;

// here you can define custom actions
// all public methods declared in helper class will be available in $I
class CmfiveSite extends \Codeception\Module
{
    // should have SHARED basics.

    // auth details
    protected $requiredFields =   [
        'basePath',
        'testAdminUsername',
        'testAdminPassword',
        'testAdminFirstname',
        'testAdminLastname',
        'setupCommand',
        'DBCommand',
        'boilerplatePath',
        'DB_Hostname',
        'DB_Username',
        'DB_Password',
        'DB_Database',
        'DB_Driver',
        'cmfiveModuleList'
    ];

    // HOOK: before test
    public function _before(\Codeception\TestCase $test)
    {
        $this->getTestDB();
        $this->runMigrations();
    }

    private function _useCmFiveSetup($param)
    {
        $rootDIR = $this->config['boilerplatePath'] . DIRECTORY_SEPARATOR;
        $Mcommand = "cd " . $rootDIR . " && php " . $rootDIR
            . $this->config['setupCommand'] . " " . $param;
        echo "Running: " . $param . "\n";
        echo (shell_exec($Mcommand) . "\n");
    }

    private function _useCmFiveDB($param)
    {
        $rootDIR = $this->config['boilerplatePath'] . DIRECTORY_SEPARATOR;
        $Mcommand = "cd " . $rootDIR . " && php " . $rootDIR
            . $this->config['DBCommand'] . " " . $param;
        echo "DB task: " . $param . "\n";
        echo (shell_exec($Mcommand) . "\n");
    }

    public function runMigrations()
    {
        $this->_useCmFiveSetup("install migrations");
    }

    /** Seed database with expected admin user profile */
    public function createTestAdminUser()
    {
        $adminAccount =
            " " . $this->config['testAdminUsername'] .
            " " . $this->config['testAdminPassword'] .
            " " . $this->config['testAdminEmail'] .
            " " . $this->config['testAdminFirstname'] .
            " " . $this->config['testAdminLastname'];
        $this->_useCmFiveSetup("seed admin " . $adminAccount);
    }

    public function _wipeTestDB()
    {
        $this->_useCmFiveDB("purge");
    }

    public function getTestDB()
    {
        $this->_useCmFiveDB("test");
    }

    public function putTestDB()
    {
        $this->_useCmFiveDB("sample");
    }


    public function login($I, $username, $password)
    {
        $I->amOnPage('/auth/login');
        // skip form filling if already logged in
        if (strpos('/auth/login', $I->grabFromCurrentUrl()) !== false) {
            $I->waitForElement('#login');
            $I->fillField('login', $username);
            $I->fillField('password', $password);
            $I->click('Login');
        }
    }

    public function loginAsAdmin($I)
    {
        $this->login($I, $this->config['testAdminUsername'], $this->config['testAdminPassword']);
    }


    public function getAdminUserName()
    {
        return $this->config['testAdminUsername'];
    }
    public function getAdminPassword()
    {
        return $this->config['testAdminPassword'];
    }
    public function getAdminFirstName()
    {
        return $this->config['testAdminFirstname'];
    }
    public function getAdminLastName()
    {
        return $this->config['testAdminLastname'];
    }

    public function getDB_Settings()
    {
        $DB_set = [];
        foreach ($this->config as $key => $value) {
            if (substr($key, 0, 3) == "DB_") {
                $DB_set[$key] = $value;
            }
        }
        return $DB_set;
    }

    public function getInstallPath()
    {
        return $this->config['boilerplatePath'];
    }

    public function logout($I)
    {
        $I->amOnPage('/auth/logout');
    }


    public function clickCmfiveNavbar($I, $category, $link)
    {
        $I->click($category, "section.top-bar-section ul.left");
        $I->moveMouseOver(['css' => '#topnav_' . strtolower($category)]);
        $I->waitForText($link);
        $I->click($link, '#topnav_' . strtolower($category));
        $I->wait(1);
    }

    public function waitForBackendToRefresh($I)
    {
        $I->waitForElementNotVisible('.loading_overlay', 14);
    }

    public function skipConfirmation($I)
    {
        // disable dialog
        $I->executeJS('window.confirm = function(){return true;}');
    }


    public function canUseCmfiveModule($module)
    {

        $modules = $this->config['cmfiveModuleList'];
        if (strpos($modules, ":" . $module . ":")) {
            return true;
        }
        return false;
    }

    public function getCodeceptionModuleList()
    {
        return $this->getModules();
    }

    public function getCmfiveModuleList()
    {
        return $this->config['cmfiveModuleList'];
    }

    public function getPDOforCmfive()
    {
        return $this->getPDOConnection($this->getDB_Settings());
    }

    public function getPDOConnection($dbInfo)
    {
        // this gets us raw DB from cmfive config ... but only handles MYSQL!
        $port = isset($dbInfo['DB_Port']) && !empty($dbInfo['DB_Port']) ? ";port=" . $dbInfo['DB_Port'] : "";
        $url = "{$dbInfo['DB_Driver']}:host={$dbInfo['DB_Hostname']};dbname={$dbInfo['DB_Database']}{$port}";
        return new \PDO(
            $url,
            $dbInfo['DB_Username'],
            $dbInfo['DB_Password'],
            array(PDO::MYSQL_ATTR_INIT_COMMAND => "SET NAMES 'utf8'")
        );
    }
}
