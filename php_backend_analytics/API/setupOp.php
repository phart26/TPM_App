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
            $response = $data['setupData'];
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
    
        $job = $result['job'];
        $setup_op = $result['setup_op'];
        $dimple1 = $result['dimple1'];
        $dimple2 = $result['dimple2'];
        $dimple3 = $result['dimple3'];
        $dimple4 = $result['dimple4'];
        $dimple5 = $result['dimple5'];
        

        $sql = "UPDATE stamping_orders_tbl SET setup_op = '$setup_op', dimple_depth1 = '$dimple1', dimple_depth2 = '$dimple2', dimple_depth3 = '$dimple3', dimple_depth4 = '$dimple4', dimple_depth5 = '$dimple5' WHERE job = '$job'";

        if ($resultConn= $conn -> query($sql)) {
            echo('Success');
        }
    }
    
?>