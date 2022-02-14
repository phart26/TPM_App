<?php

	$conn = new mysqli("localhost", "root", "anuj", "test_db_may");

	//check connection
	if($conn -> connect_errno){
		echo "Connection Error: " . $conn -> connect_error;
		exit();
    }

?>