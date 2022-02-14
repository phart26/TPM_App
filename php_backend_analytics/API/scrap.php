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
            $response = $data['scrapData'];
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
        print_r($result);

        date_default_timezone_set("US/Central");
        $tube_id = $result['tube_id'];
        $timeStamp = date("Y-m-d H:i:s");
        $reason = $result['reason'];
        $job = $result['job'];
        $coil = $result['coil'];
        $length = $result['tube_length'];
        $millOrInsp = $result['millOrInsp'];

        if($length == ""){
            $sql = "SELECT * FROM orders_tbl WHERE job = '$job'";

            if ($resultConn= $conn -> query($sql)) {
            }
            $order = mysqli_fetch_assoc($resultConn);
            $sql = 'SELECT * FROM part_tbl WHERE part = "'.$order['part'].'"';

            if ($resultConn= $conn -> query($sql)) {
            }
            $part = mysqli_fetch_assoc($resultConn);

            $length = $part['cutoff_length'];
        }
        
        if($millOrInsp == "M"){
            $sql = "INSERT INTO scrap_tbl(job, tube_id, coil, tube_length, reason, time_stamp, mill_scrap) VALUES('$job', '$tube_id', '$coil', '$length', '$reason', '$timeStamp', 1)";

            if ($resultConn= $conn -> query($sql)) {
        
            }
            echo 'success';
        }elseif($millOrInsp == "S"){
            $sql = "INSERT INTO scrap_tbl(job, tube_length, reason, time_stamp, setup_scrap ) VALUES('$job', '$length', '$reason', '$timeStamp', 1)";

            if ($resultConn= $conn -> query($sql)) {
            }
            echo 'success';
        }else{
            $sql = "INSERT INTO scrap_tbl(job, tube_id, coil, tube_length, reason, time_stamp, insp_scrap ) VALUES('$job', '$tube_id', '$coil', '$length', '$reason', '$timeStamp', 1)";

            if ($resultConn= $conn -> query($sql)) {
        
            }

            $sql = 'UPDATE tubes_tbl SET mill_check = 0, cutoff_check = 0 WHERE id = "'.$tube_id.'"';

            if ($resultConn= $conn -> query($sql)) {
                echo 'success';
            }
            
        }

        
    }
    
?>