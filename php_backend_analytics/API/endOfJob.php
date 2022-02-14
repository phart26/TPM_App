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
       
        
        if($result['endJob'] != ""){
            date_default_timezone_set("US/Central");
            $timeStamp = date("Y-m-d H:i:s");
            $sql = "UPDATE orders_tbl SET has_finished = 1, finished = '$timeStamp' WHERE job = '".$result['job']."'";

            if ($resultConn= $conn -> query($sql)) {
                echo('Success');
            }


            $sql1 = "UPDATE coil_tbl SET allocated = 0, job = 0 WHERE job = '".$result['job']."'";

            if ($resultConn1= $conn -> query($sql1)) {
                echo('Success');
            }

            $sql2 = "UPDATE mesh_tbl SET allocated = 0, job = 0, tpm_po = 0, TPM_JOB = 0 WHERE job = '".$result['job']."'";

            if ($resultConn2= $conn -> query($sql2)) {
                echo('Success');
            }
        }
    }
    
?>