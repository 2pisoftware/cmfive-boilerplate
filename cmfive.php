#!/bin/php
<?php

if ($argc < 2) {
	die('Missing command');
}

require('system/web.php');
$w = new Web();

$composer_json = json_decode(file_get_contents('./composer.json'), true);
$dependencies_array = array();
foreach($w->modules() as $module) {
	$dependencies = Config::get("{$module}.dependencies");
	if (!empty($dependencies)) {
		$dependencies_array = array_merge($dependencies, $dependencies_array);
	}
}

$composer_json['require'] = array_merge($composer_json['require'], $dependencies_array);

file_put_contents('./composer.json', json_encode($composer_json));

echo "composer.json updated";

exit(0);