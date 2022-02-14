<?php
    
    
    include '../Connections/connectionTPM.php';


    $sql = "SELECT * FROM coil_tbl WHERE job = $job AND allocated = 1";

    //make query & get result
    if ($result= $conn -> query($sql)) {
	
    }
    $coils = array();
    $coilsJob = array();
    while($order = mysqli_fetch_array($result)){
        $coils[] = $order;
    }

    foreach($coils as $coil){
        $sql = "SELECT * FROM steel_tbl WHERE work = '".$coil['work']."'";
        if ($result= $conn -> query($sql)) {

        }
        $gage= mysqli_fetch_assoc($result);
        array_push($coilsJob,array("coil_no" => $coil['coil_no'], "gage" => ($gage['gage']." GA")));
    }

    $jsonArr = array(
            'job' => $job,
            'coils' => $coilsJob
    );


    $sql = "SELECT * FROM tubes_tbl WHERE job = $job";

    //make query & get result
    if ($result= $conn -> query($sql)) {
	
    }
    $coils = array();
    $tubes = array();
    $firstMat = array();
    while($order = mysqli_fetch_array($result)){
        $tubes[] = $order;
    }
    
    $tube = $tubes[0];
    $coil_no = $tube['coil'];

    $sql = "SELECT * FROM coil_tbl WHERE coil_no = '$coil_no'";
    if ($result= $conn -> query($sql)) {

    }
    $coil = mysqli_fetch_assoc($result);
        
    $sql1 = "SELECT * FROM steel_tbl WHERE work = '".$coil['work']."'";
    if ($result1= $conn -> query($sql1)) {

    }

    $gageFirst = mysqli_fetch_assoc($result1);

    array_push($firstMat,array("coil_no" => $coil_no, "gage" => ($gageFirst['gage']." GA")));

    $jsonArrFirst = array(
            'job' => $job,
            'firstCoils' => $firstMat
    );

    // foreach($records as $record){
    //     $jsonArr['coils'][]= array(
    //         'coilNum' => $record['coil_no'],
    //         'weight' => $record['weight'],
    //         'heat' => $record['heat']
    //     );
    // }
?>
    
