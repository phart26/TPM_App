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
            $response = $data['dimData'];
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
        $results = processRequest($_SERVER['REQUEST_METHOD']);

            $drift_dim = $results['dim'];
            $drift_insp = $results['dimInsp'];
            $job = $results['job'];

            if($results['dim'] != ""){

                $sql = "UPDATE orders_tbl SET drift_dim = '$drift_dim', drift_insp = '$drift_insp' WHERE job = '$job'";
                if ($resultConn= $conn -> query($sql)) {
            
                }
            }


    }

