<?php
class BoilerCest
{

    public function _before()
    {
    }

    public function _after()
    {
    }

	 

    function testAuthIsUp($I) {
		  $I->loginAsAdmin($I);
      }
}
