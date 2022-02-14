<?php
    include '../Connections/connectionTPM.php';
    $sql = "SELECT * FROM orders_tbl WHERE job = $job";

    if ($result= $conn -> query($sql)) {
	
    }

    $orderACT = mysqli_fetch_assoc($result);
    
    $sql1 = "SELECT * FROM part_tbl WHERE part = '".$orderACT['part']."'";

    if ($result1= $conn -> query($sql1)) {
	
	}
	
    //fetch resulting rows as an array
    $partSpec = mysqli_fetch_assoc($result1);
	
    //fetch resulting rows as an array
    

    $jsonArr = array(
            'job' => $job,
            'idDrift' => $partSpec['drift']
    );

?>
