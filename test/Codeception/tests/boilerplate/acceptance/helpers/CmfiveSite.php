<?php

namespace Helper;

// here you can define custom actions
// all public methods declared in helper class will be available in $I


class CmfiveSite extends \Codeception\Module
{
      // should have SHARED basics.
  
        // auth details
        protected $requiredFields =   [
            'basePath' ,
            'testAdminUsername' ,
            'testAdminPassword' ,
            'testAdminFirstname' ,
            'testAdminLastname' ,
            'setupCommand' ,
            'DBCommand' ,
            'DB_Hostname' ,
            'DB_Username' ,
            'DB_Password' ,
            'DB_Database' ,
            'DB_Driver' ];

  // HOOK: before test
  public function _before(\Codeception\TestCase $test) {
    $this->getTestDB();
    $this->runMigrations();  
    }

private function _useCmFiveSetup($param) {
  $rootDIR = substr(getcwd(), 0, strpos(getcwd(), "test"));
  $Mcommand = "cd ".$rootDIR." && php ".$rootDIR
      .$this->config['setupCommand']." ".$param;
   echo "Running: ".$param ."\n";
    echo (shell_exec($Mcommand)."\n");
}

private function _useCmFiveDB($param) {
  $rootDIR = substr(getcwd(), 0, strpos(getcwd(), "test"));
  $Mcommand = "cd ".$rootDIR." && php ".$rootDIR
     .$this->config['DBCommand']." ".$param;
   echo "DB task: ".$param ."\n";
   echo (shell_exec($Mcommand)."\n");
}

 public function runMigrations() {
  $this->_useCmFiveSetup("install migrations");
}

/** Seed database with expected admin user profile */
public function createTestAdminUser() {
  $adminAccount = 
  " ".$this->config['testAdminUsername'].
  " ".$this->config['testAdminPassword']. 
  " ".$this->config['testAdminEmail'].
  " ".$this->config['testAdminFirstname'].
  " ".$this->config['testAdminLastname'];
  $this->_useCmFiveSetup("seed admin ".$adminAccount);
}

public function _wipeTestDB() { 
  $this->_useCmFiveDB("purge");
}

public function getTestDB() { 
  $this->_useCmFiveDB("test");
 }

 public function putTestDB() { 
  $this->_useCmFiveDB("sample");
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
  
  public function getDB_Settings() {
    $DB_set=[];
    foreach($this->config as $key => $value) {
      if(substr($key,0,3)=="DB_") {$DB_set[$key]=$value;}
    }
    return $DB_set;
  }

  	public function logout($I) {
		$I->amOnPage('/auth/logout');
	}


  public function clickCmfiveNavbar($I,$category,$link) {
        $I->click($category,"section.top-bar-section ul.left");
        $I->moveMouseOver(['css' => '#topnav_'.strtolower($category)]);
        $I->waitForText($link);
        $I->click($link, '#topnav_'.strtolower($category));
        $I->wait(1);
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

   
//  public function doAdHocDebugCommand($I) {
//   $command = '';
//   if (strtoupper(substr(PHP_OS, 0, 3)) === 'WIN') {
//       $command = stream_get_line(STDIN, 1024, PHP_EOL);
//   } else {
//       $command = readline($prompt);
//   }
//   $tryToDo = explode('(' , rtrim($command, ')')); 
//   $func=array_shift($tryToDo)  ;
//   $param = explode(',' , $tryToDo[0]); 
//   // THIS ALMOST WORKS! 
//   // (need to escape from strings back to arg types...)
//   call_user_func_array(array($I, $func), $param);
// }

}

