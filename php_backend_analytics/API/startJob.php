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
            $response = $data['startData'];
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
        
        // stamping job
        if($result['type'] == "S"){

            $sql = "UPDATE stamping_orders_tbl SET has_started = 1, start_time = '$timeStamp' WHERE job = '$job'";

            if ($resultConn= $conn -> query($sql)) {
                echo('Success');
            }
        // mill job
        } else{
            $sql = "UPDATE orders_tbl SET has_started = 1, began = '$timeStamp' WHERE job = '$job'";

            if ($resultConn= $conn -> query($sql)) {
                echo('Success');
            }
        }
    }
    
?>