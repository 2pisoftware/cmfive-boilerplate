<?php
ini_set("display_errors", 0); //Avoids 200 OK being sent when there are errors
error_reporting(E_ALL);

require_once 'system/web.php';
$web = new Web();
$web->start();
