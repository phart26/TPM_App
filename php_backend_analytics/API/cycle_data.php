<?php
    include '../Connections/connectionTPM.php';
?>

<?php

    function processRequest($method){
            
        //$path = $_GET['path'];
        
        switch ($method) {
        case 'PUT':  
            break;
        case 'POST':
            $data = JSON_decode(file_get_contents('php://input'), TRUE);
            $response = $data['cycleData'];
            break;
        case 'GET':
            break;
        default:
            $response = notFound();  
            break;
        }

        return $response;
    }


    function notFound(){
        echo  'No data found';
    }
?>

<?php
    if(isset($_POST)){
        $result = processRequest($_SERVER['REQUEST_METHOD']);


        date_default_timezone_set("US/Central");
        $press_op = $result['press_op'];
        $timeStamp = date("Y-m-d H:i:s");
        $job = $result['job'];
        $coil = $result['coil_no'];
        $millJob = intval($result['mill_job']);
        $new_coil = $result['new_coil'];
        $cycle_id = $result['cycle_id'];
        $dimple1 = $result['dimple1'];
        $dimple2 = $result['dimple2'];
        $dimple3 = $result['dimple3'];
        $dimple4 = $result['dimple4'];
        $dimple5 = $result['dimple5'];
        $dimpleAvg = $result['dimpleAvg'];
        


        $sql = "INSERT INTO cycle_tbl(cycle_no, job, press_op, dimple_depth1, dimple_depth2, dimple_depth3, dimple_depth4, dimple_depth5, dimple_depth_avg, coil_no, end_coil, cycle_time) VALUES('$cycle_id', '$job', '$press_op', '$dimple1', '$dimple2', '$dimple3', '$dimple4', '$dimple5', '$dimpleAvg', '$coil', '$new_coil', '$timeStamp')";

        if ($resultConn= $conn -> query($sql)) {
        
        }

        $sql = "UPDATE raw_coil_tbl SET cycles = cycles + 1 WHERE coil_no = '$coil'";
        if ($resultConn= $conn -> query($sql)) {
        
        }

        if($new_coil == 1){
        
            $sql = "INSERT INTO coil_tbl (coil_no, work, weight, date_received, cycles, footage) SELECT coil_no, work, weight, date_received, cycles, footage FROM raw_coil_tbl WHERE coil_no = '$coil'";
        
            if ($resultConn= $conn -> query($sql)) {
                echo('Success');
            }
        
        
            $sql1 = "DELETE FROM raw_coil_tbl WHERE coil_no = '$coil'";
        
            if ($resultConn1= $conn -> query($sql1)) {
                echo('Success');
            }
        
            $sql1 = "UPDATE coil_tbl SET job = '$millJob', stamp_job = '$job' WHERE coil_no = '$coil'";
        
            if ($resultConn1= $conn -> query($sql1)) {
                echo('Success');
            }
        
            }


}
    
?>