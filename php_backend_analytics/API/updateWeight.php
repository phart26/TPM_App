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
            $response = $data['weightData'];
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
       
        
        if($result['weight'] != ""){
            $weight = $result['weight'];
            $coilNo = $result['coil'];
            $sql = "UPDATE coil_tbl SET weight = '$weight' WHERE coil_no = '$coilNo'";

            if ($resultConn= $conn -> query($sql)) {
                echo('Success');
            }
        }
    }
    
?>