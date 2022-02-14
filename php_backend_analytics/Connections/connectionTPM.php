<?php

	$conn = new mysqli("localhost", "root", "anuj", "demo_tpm");

	//check connection
	if($conn -> connect_errno){
		echo "Connection Error: " . $conn -> connect_error;
		exit();
    }

?>