<?php
class HelperCest
{

    public function _before()
    {
    }

    public function _after()
    {
    }

    public function ListAllHelpers($I) {
        $active = $I->getCodeceptionModuleList();
        echo "\n --- Helper Functions ---\n";
        foreach ($active as $module) {
        $class = new ReflectionClass($module);
        $methods = $class->getMethods();
        foreach($methods as $method) { 
        if(strpos($method->class, "Helper") !== false ) {  
            echo $method->class."::".$method->name."\n";
            //" --> ".$method->getDocComment()."\n";
        }
        } 
      }
      echo "\n";
    }
}
