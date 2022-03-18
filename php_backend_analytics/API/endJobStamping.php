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
            $response = $data['endJobData'];
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
        $timeStamp = date("Y-m-d H:i:s");
        $job = $result['job'];
        

        $sql1 = "UPDATE stamping_orders_tbl SET has_finished = 1, finish_time = '$timeStamp'  WHERE job = '$job'";

        if ($result1= $conn -> query($sql1)) {
            
        }

        //deallocate coils
        $sql1 = "UPDATE raw_coil_tbl SET allocated = 0, job = '' WHERE job = '$job'";

        if ($result1= $conn -> query($sql1)) {
            
        }

        
    }
?>
            