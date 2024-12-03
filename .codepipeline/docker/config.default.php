<?php

//======= Override Main Module Company Parameters ============
Config::set('main.application_name', 'Cmfive');
Config::set('main.company_name', '2pi Software');
Config::set('main.company_url', 'https://2pisoftware.com');
Config::set('main.company_support_email', getenv('SMTP_SENDER') ?: '');

//=============== Timezone ===================================
date_default_timezone_set('Australia/Sydney');
Config::set("system.timezone", "Australia/Sydney");

//========== Database Configuration ==========================
Config::set("database", [
    "hostname"  => getenv('DB_HOST') ?: "mysqldb",
    "port"      => getenv('DB_PORT') ?: "3306",
    "username"  => getenv('DB_USERNAME') ?: "cmfive",
    "password"  => getenv('DB_PASSWORD') ?: "cmfive",
    "database"  => getenv('DB_DATABASE') ?: "cmfive",
    "driver"    => getenv('DB') ?: "mysql",
    "backups" =>
    [
        'outputExt' => 'sql',
        'commandPath' => [
            'unix' => '/usr/bin/',
            'windows' => '"C:\\Program Files\\MySQL\\MySQL Server 5.6\\bin\\'
        ],
        'backupCommand' => [
            'unix' => 'mysqldump -u $username -h $hostname -P $port -p\'$password\' $dbname > $filename',
            'windows' => 'mysqldump.exe" -h$hostname -P$port -u$username -p$password  $dbname > $filename'
        ],
        'restoreCommand' => [
            'unix' => 'mysql -u $username -h $hostname -P $port -p\'$password\' $dbname < $filename',
            'windows' => 'mysql.exe" -D$dbname -h$hostname -P$port -u$username -p$password < $filename'
        ],
    ]
]);

Config::set("report.database", [
    "hostname"  => getenv('DB_HOST') ?: "mysqldb",
    "username"  => getenv('DB_USERNAME') ?: "cmfive",
    "password"  => getenv('DB_PASSWORD') ?: "cmfive",
    "database"  => getenv('DB_DATABASE') ?: "cmfive",
    "driver"    => getenv('DB') ?: "mysql",
]);

//=========== Email Layer Configuration =====================
Config::append('email', [
    "layer"    => "smtp",   // smtp or sendmail or aws
    "command" => "",        // used for sendmail layer only
    "host"    => "email-smtp.ap-southeast-2.amazonaws.com",
    "port"    => 465,
    "auth"    => true,
    "username"    => getenv('SMTP_USERNAME') ?: '<email>',
    "password"    => getenv('SMTP_PASSWORD') ?: '<password>',
]);

//========== TestRunner Configuration ========================== 
Config::set("system.environment", "development");
Config::set("core_template.foundation.reveal.animation", "none");
Config::set("core_template.foundation.reveal.animation_speed", 0);

//========= Anonymous Access ================================
// bypass authentication if sent from the following IP addresses
// specify an IP address and an array of allowed actions from that IP
Config::set("system.allow_from_ip", [
    // "10.0.0.0" => array("action1", "action2"),
]);

// or bypass authentication for the following modules
Config::set("system.allow_module", [
    // "rest", // uncomment this to switch on REST access to the database objects.
]);

// or bypass authentication for the following actions
Config::set('system.allow_action', [
    "auth/login",
    "auth/forgotpassword",
    "auth/resetpassword",
    //"admin/datamigration"
]);

//========= REST Configuration ==============================
// check the following configuration carefully to secure
// access to the REST infrastructure.
//===========================================================

// use the API_KEY to authenticate with username and password
Config::set('system.rest_api_key', "abcdefghijklmnopqrstuvwxyz1234567890");

// include class of objects that you want available via REST
// be aware that only the listed objects will be available via
// the REST API
Config::set('system.rest_include', [
    // "Contact"
]);

//Config::set('tests', ['testrunner'  => 'ENABLED']);
