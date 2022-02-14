<?php

	//connect to database
	$conn = new mysqli("localhost", "Preston", "Hartpre13", "tpm_forms");

	//check connection
	if($conn -> connect_errno){
		echo "Connection Error: " . $conn -> connect_error;
		exit();
    }

?>