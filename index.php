<?php
ini_set("display_errors", 1);
error_reporting(E_ALL);

require_once 'system/web.php';
$web = new Web();
$web->start();
