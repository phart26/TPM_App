<?php

	$conn = new mysqli("localhost", "root", "123456", "demo_tpm");

	//check connection
	if($conn -> connect_errno){
		echo "Connection Error: " . $conn -> connect_error;
		exit();
    }

?>