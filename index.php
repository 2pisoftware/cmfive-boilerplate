<?php
ini_set("display_errors", 0); //Avoids 200 OK being sent when there are errors
error_reporting(E_ALL);

// Display banners if they exist
if (file_exists('banner_error.php')) {
    require_once 'banner_error.php';
    exit;
}
if (file_exists('banner.php')) {
    require_once 'banner.php';
    exit;
}

require_once 'system/web.php';
$web = new Web();
$web->start();
