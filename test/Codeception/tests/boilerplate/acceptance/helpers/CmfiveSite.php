<?php
namespace Helper;

// here you can define custom actions
// all public methods declared in helper class will be available in $I

class CmfiveSite extends \Codeception\Module
{

    // should have things like 'login'/auth ... create&delete user REAL basics.

  // HOOK: before test
  public function _before(\Codeception\TestCase $test) {
      echo "\n\nRIGHT NOW I SHOULD RESET ALL MYSQL TABLES\n\n";
    }

    public function login($I,$username,$password) {
        $I->amOnPage('/auth/login');
        // skip form filling if already logged in
        if (strpos('/auth/login',$I->grabFromCurrentUrl())!==false) {
      $I->waitForElement('#login');
            $I->fillField('login',$username);
            $I->fillField('password',$password);
            $I->click('Login');
    }
  }


  public function clickCmfiveNavbar($I,$category,$link) {
        $I->click($category,"section.top-bar-section ul.left");
        $I->moveMouseOver(['css' => '#topnav_'.strtolower($category)]);
        $I->waitForText($link);
    $I->wait(.5);
        $I->click($link);
    }
	
  public function waitForBackendToRefresh($I) {
    $I->waitForElementNotVisible('.loading_overlay',14);
  }

   public function getCodeceptionModuleList() {
     return $this->getModules();
   }

}

