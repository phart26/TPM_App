<?php
    include '../Connections/connectionTPM.php';
    $sql = "SELECT * FROM orders_tbl WHERE job = $job";

    if ($result= $conn -> query($sql)) {
	
	}
	
    //fetch resulting rows as an array
    $orderACT = mysqli_fetch_assoc($result);

    $sql1 = "SELECT * FROM part_tbl WHERE part = '".$orderACT['part']."'";

    if ($result1= $conn -> query($sql1)) {
	
	}
	
    //fetch resulting rows as an array
    $partSpec = mysqli_fetch_assoc($result1);

    $sql2 = "SELECT * FROM gage_tbl WHERE gage = '".$partSpec['gage']."'";

    if ($result2= $conn -> query($sql2)) {
	
	}
	
    //fetch resulting rows as an array
    $gageSpec = mysqli_fetch_assoc($result2);

    $jsonArr = array(
            'job' => $job,
            'thickness' => $gageSpec['thickness'],
            'gage' => $partSpec['gage'],
            'dimpleDepth' => $partSpec['depth_of_dimple'],
            'dimpleDepthP' => $partSpec['depth_of_dimple_plus'],
            'dimpleDepthM' => $partSpec['depth_of_dimple_minus'],
            'blankEnd' => $partSpec['blank_end'],
            'blankEndP' => $partSpec['blank_end_plus'],
            'blankEndM' => $partSpec['blank_end_minus'],
            'idDrift' => $partSpec['drift'],
    );

    
?>