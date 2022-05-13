<?php
	require_once('db.php');

	$dbhost = 'localhost';
	$dbuser = 'root';
	$dbpass = '123456';
	$dbname = 'demo_tpm';

	$conn = new mysqli($dbhost, $dbuser, $dbpass, $dbname);

	//check connection
	if($conn -> connect_errno){
		echo "Connection Error: " . $conn -> connect_error;
		exit();
    }

	
	//DB quering with class way ###########################
	$db = new db($dbhost, $dbuser, $dbpass, $dbname);	
	//#####################################################
	

?>