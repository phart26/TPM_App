<?php

	$conn = new mysqli("localhost", "root", "123456", "test_db_may");

	//check connection
	if($conn -> connect_errno){
		echo "Connection Error: " . $conn -> connect_error;
		exit();
    }

?>