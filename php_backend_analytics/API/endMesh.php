<?php
// file used to move used material into archive materail DB
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
            $response = $data['endData'];
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
       
        
        if($result['endPo'] != ""){
            date_default_timezone_set("US/Central");
            $timeStamp = date("Y-m-d H:i:s");
            $sql = "UPDATE mesh_jobs SET finished = 1, end_time = '$timeStamp' WHERE po = '".$result['endPo']."'";

            if ($resultConn= $conn -> query($sql)) {
                echo('Success');
            }
        }
    }
    
?>