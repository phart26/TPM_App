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
            $response = $data['badStampData'];
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
        $cycle_id = $result['cycle_id'];
        $timeStamp = date("Y-m-d H:i:s");
        $reason = $result['reason'];
        $job = $result['job'];
        $coil = $result['coil'];
        $length = $result['length'];
        
        $sql = "INSERT INTO badstamp_tbl(cycle_id, job, coil, scrap_length, reason, scrap_time) VALUES('$cycle_id', '$job', '$coil', '$length', '$reason', '$timeStamp')";

        if ($resultConn= $conn -> query($sql)) {
    
        }
        echo 'success';

        
    }
    
?>