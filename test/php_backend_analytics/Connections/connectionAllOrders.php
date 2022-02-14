<?php

	//connect to database
	$connOUT = new mysqli("localhost", "Preston", "Hartpre13", "u886168621_hart");

	//check connection
	if($connOUT -> connect_errno){
		echo "Connection Error: " . $connOUT -> connect_error;
		exit();
    }

    /*$conn = new mysqli("10.4.1.142", "u886168621_hart", "Reset123!", "u886168621_hart");

	//check connection
	if($conn -> connect_errno){
		echo "Connection Error: " . $conn -> connect_error;
		exit();
    }*/

?>