<?php
session_start();
// Define database
define('dbhost', 'localhost');
define('dbuser', 'root');
define('dbpass', '');
define('dbname', 'nimodo');
// Connecting database
try {
	$connect = new PDO("mysql:host=".dbhost."; dbname=".dbname.";charset=utf8", dbuser, dbpass);
	$connect->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
}
catch(PDOException $e) {
	echo $e->getMessage();
}
?>