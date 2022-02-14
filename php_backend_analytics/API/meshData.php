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
            $response = $data['meshData'];
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
        $coil_no = $results['coil_no'];
        $user = $results['user'];
        $length = $results['length'];

        // had to scrap part of the tube so the length needs to be updated
        if($length != ""){
            //get inital length of combined coil
            $sql = "SELECT * FROM mesh_tbl WHERE mesh_no = '$coil_no'";

            if ($resultConn= $conn -> query($sql)) {
                
            }

            $coil = mysqli_fetch_assoc($resultConn);
            $initalLen = intval($coil['length']);

            //updated length
            $length = strval($initalLen - intval($results['length']));


            $sql = "UPDATE mesh_tbl SET length = '$length', operator = '$user', splice_chk = 1 WHERE mesh_no = '$coil_no'";

            if ($resultConn= $conn -> query($sql)) {
            
            }

        }else{
            $sql = "UPDATE mesh_tbl SET operator = '$user', splice_chk = 1 WHERE mesh_no = '$coil_no'";

            if ($resultConn= $conn -> query($sql)) {
            
            }
        }

        $sql = "UPDATE mesh_combos SET splice_chk = 1 WHERE coil_no = '$coil_no'";

            if ($resultConn= $conn -> query($sql)) {
            
            }
    }
    
?>