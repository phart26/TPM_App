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
            $response = $data['testData'];
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
        $bend_result = $result['bend_result'];
        $bend_time = date("Y-m-d H:i:s");
        $drift_test = $result['drift_test'];
        $job = $result['job'];
        

        $sql = "UPDATE orders_tbl SET bend_result = '$bend_result', bend_time = '$bend_time', drift_test = '$drift_test' WHERE job = '$job'";

        if ($resultConn= $conn -> query($sql)) {
	
        }

        if($result['drift_test'] == 1){
            $drift_result = $result['drift_result'];
            $drift_time = date("Y-m-d H:i:s");
            $sql = "UPDATE orders_tbl SET drift_result = '$drift_result', drift_time = '$drift_time' WHERE job = '$job'";

            if ($resultConn= $conn -> query($sql)) {
        
            }
        }
        
        echo 'success';
    }
    
?>