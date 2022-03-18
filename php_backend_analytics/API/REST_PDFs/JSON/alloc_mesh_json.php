<?php
    include '../Connections/connectionTPM.php';

    $sql = "SELECT * FROM mesh_tbl WHERE job = $job AND allocated = 1";

    //make query & get result
    if ($result= $conn -> query($sql)) {
	
    }
    $mesh = array();
    $meshJob = array();
    $firstMesh = array();
    while($order = mysqli_fetch_array($result)){
        $mesh[] = $order;
    }

    foreach($mesh as $m){
        array_push($meshJob,array("mesh_no" => $m['mesh_no'],"mesh_type" => $m['mesh']));
    }
    $jsonArr = array(
            'job' => $job,
            'mesh'  => $meshJob
    );

    $sql = "SELECT * FROM tubes_tbl WHERE job = $job";

    //make query & get result
    if ($result= $conn -> query($sql)) {
	
    }
    $mesh = array();
    $tubes = array();
    
    while($order = mysqli_fetch_array($result)){
        $tubes[] = $order;
    }
    
    if(!empty($tubes)){

        $tube = $tubes[0];
        $fil_mesh_top   = $tube['filter_mesh_top'];
        $fil_mesh_bot   = $tube['filter_mesh_bot'];
        $drain_mesh_top = $tube['drain_mesh_top'];
        $drain_mesh_bot = $tube['drain_mesh_bot'];

        //filter mesh top
        $sql = "SELECT * FROM mesh_tbl WHERE mesh_no = '$fil_mesh_top'";
        if ($result= $conn -> query($sql)) {

        }
        $mesh = mysqli_fetch_assoc($result);


        array_push($firstMesh,array("mesh_no" => $fil_mesh_top, "mesh_type" => !empty($mesh['mesh']) ? $mesh['mesh'] : ""));



        //filter mesh bottom
        $sql = "SELECT * FROM mesh_tbl WHERE mesh_no = '$fil_mesh_bot'";
        if ($result= $conn -> query($sql)) {

        }
        $mesh = mysqli_fetch_assoc($result);

        array_push($firstMesh,array("mesh_no" => $fil_mesh_bot, "mesh_type" => !empty($mesh['mesh']) ? $mesh['mesh'] : ""));


        //drainage mesh top
        $sql = "SELECT * FROM mesh_tbl WHERE mesh_no = '$drain_mesh_top'";
        if ($result= $conn -> query($sql)) {

        }
        $mesh = mysqli_fetch_assoc($result);

        array_push($firstMesh,array("mesh_no" => $drain_mesh_top, "mesh_type" => !empty($mesh['mesh']) ? $mesh['mesh'] : ""));


        //drainage mesh bottom
        $sql = "SELECT * FROM mesh_tbl WHERE mesh_no = '$drain_mesh_bot'";
        if ($result= $conn -> query($sql)) {

        }
        $mesh = mysqli_fetch_assoc($result);

        
        array_push($firstMesh,array("mesh_no" => $drain_mesh_bot, "mesh_type" => !empty($mesh['mesh']) ? $mesh['mesh'] : ""));
    }   

    
    $jsonArrFirst = array(
            'job' => $job,
            'firstMesh' => $firstMesh
    );

    //getting top filter mesh of last tube
    $sql6 = "SELECT * FROM tubes_tbl WHERE job = $job ORDER BY id DESC";

    if ($result6= $conn -> query($sql6)) {
        
    }

    $currentMesh = array();
    while($tubes = mysqli_fetch_array($result6)){
        $nextTubes[] = $tubes;
    }

    if(!empty($nextTubes)){

        $filMeshTopLastTube = $nextTubes[0]['filter_mesh_top'];
        $sql = "SELECT * FROM mesh_tbl WHERE mesh_no = '$filMeshTopLastTube'";
        if ($result= $conn -> query($sql)) {

        }
        $mesh = mysqli_fetch_assoc($result);

        array_push($currentMesh,array("mesh_no" => $filMeshTopLastTube, "mesh_type" => !empty($mesh['mesh']) ? $mesh['mesh'] : ""));


        $filMeshBotLastTube = $nextTubes[0]['filter_mesh_bot'];
        $sql = "SELECT * FROM mesh_tbl WHERE mesh_no = '$filMeshBotLastTube'";
        if ($result= $conn -> query($sql)) {

        }
        $mesh = mysqli_fetch_assoc($result);

        array_push($currentMesh,array("mesh_no" => $filMeshBotLastTube, "mesh_type" => !empty($mesh['mesh']) ? $mesh['mesh'] : ""));


        $drainMeshTopLastTube = $nextTubes[0]['drain_mesh_top'];
        $sql = "SELECT * FROM mesh_tbl WHERE mesh_no = '$drainMeshTopLastTube'";
        if ($result= $conn -> query($sql)) {

        }
        $mesh = mysqli_fetch_assoc($result);

        array_push($currentMesh,array("mesh_no" => $drainMeshTopLastTube, "mesh_type" => !empty($mesh['mesh']) ? $mesh['mesh'] : ""));


        $drainMeshBotLastTube = $nextTubes[0]['drain_mesh_bot'];
        $sql = "SELECT * FROM mesh_tbl WHERE mesh_no = '$drainMeshBotLastTube'";
        if ($result= $conn -> query($sql)) {

        }
        $mesh = mysqli_fetch_assoc($result);

        
        array_push($currentMesh,array("mesh_no" => $drainMeshBotLastTube, "mesh_type" => !empty($mesh['mesh']) ? $mesh['mesh'] : ""));


        
    
    }
    $currentMesh = array(
        'job' => $job,
        'currentMesh' => $currentMesh
    );


    
?>