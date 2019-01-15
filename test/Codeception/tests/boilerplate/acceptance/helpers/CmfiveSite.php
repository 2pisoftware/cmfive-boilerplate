<?php
namespace Helper;

// here you can define custom actions
// all public methods declared in helper class will be available in $I
 
class CmfiveSite extends \Codeception\Module
{

    // should have SHARED basics.
  
        // auth details
        protected $requiredFields = 
  [ 'basePath' ,
  'testAdminUsername' ,
	'testAdminPassword' ,
	'testAdminFirstname' ,
  'testAdminLastname' ];

  // HOOK: before test
  public function _before(\Codeception\TestCase $test) {
    $this->getTestDB();
    $this->runMigrations();
    }

 public function getTestDB() { 
  $rootDIR = substr(getcwd(), 0, strpos(getcwd(), "test"));
  $DBcommand = "cd ".$rootDIR." && php ".$rootDIR."cmfiveDB.php test";
  echo "Refreshing TestDB: "; //.$DBcommand."\n"; 
  echo (shell_exec($DBcommand)."\n");
 }

 public function runMigrations() {
  $rootDIR = substr(getcwd(), 0, strpos(getcwd(), "test"));
  $Mcommand = "cd ".$rootDIR." && php ".$rootDIR."cmfive.php install migrations";;
   echo "Applying migrations to TestDB: "; //.$Mcommand."\n";
   echo (shell_exec($Mcommand)."\n");
}

    public function login($I, $username,$password) {
        $I->amOnPage('/auth/login');
        // skip form filling if already logged in
        if (strpos('/auth/login',$I->grabFromCurrentUrl())!==false) {
      $I->waitForElement('#login');
            $I->fillField('login',$username);
            $I->fillField('password',$password);
            $I->click('Login');
    }
  }

  public function loginAsAdmin($I) {
    $this->login($I, $this->config['testAdminUsername'],$this->config['testAdminPassword']);
  }


  public function getAdminUserName(){ return $this->config['testAdminUsername']; }
  public function getAdminPassword(){ return $this->config['testAdminPassword']; }
  public function getAdminFirstName(){ return $this->config['testAdminFirstname']; }
  public function getAdminLastName(){ return $this->config['testAdminLastname']; }
  

  	public function logout($I) {
		$I->amOnPage('/auth/logout');
	}


  public function clickCmfiveNavbar($I,$category,$link) {
        $I->click($category,"section.top-bar-section ul.left");
        $I->moveMouseOver(['css' => '#topnav_'.strtolower($category)]);
        $I->waitForText($link);
        $I->click($link, '#topnav_'.strtolower($category));
    }

  public function waitForBackendToRefresh($I) {
    $I->waitForElementNotVisible('.loading_overlay',14);
  }

  public function skipConfirmation($I) {
  // disable dialog
  $I->executeJS('window.confirm = function(){return true;}');
  }


   public function getCodeceptionModuleList() {
     return $this->getModules();
   }

}

