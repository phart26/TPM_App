
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
            $response = $data['materialData'];
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
       
        
        if(!empty($result['coil_no'])){
            date_default_timezone_set("US/Central");
            $timeStamp = date("Y-m-d H:i:s");
            $sql = "INSERT INTO used_coil (coil_no, work, weight, job, date_received) SELECT coil_no, work, weight, job, date_received FROM coil_tbl WHERE coil_no = '".$result['coil_no']."'";

            if ($resultConn= $conn -> query($sql)) {
                echo('Success');
            }


            $sql1 = "DELETE FROM coil_tbl WHERE coil_no = '".$result['coil_no']."'";

            if ($resultConn1= $conn -> query($sql1)) {
                echo('Success');
            }

            $sql2 = "UPDATE used_coil SET date_used = '$timeStamp' WHERE coil_no = '".$result['coil_no']."'";

            if ($resultConn2= $conn -> query($sql2)) {
                echo('Success');
            }
        }


        if(!empty($result['filter_no'])){
            date_default_timezone_set("US/Central");
            $timeStamp = date("Y-m-d H:i:s");
            $sql = "INSERT INTO used_mesh (mesh_no, supplier, job, tpm_po, date_received, width, length, heat, mesh, type)  SELECT mesh_no, supplier, job, tpm_po, date_received, width, length, heat, mesh, type FROM mesh_tbl WHERE mesh_no = '".$result['filter_no']."'";

            if ($resultConn= $conn -> query($sql)) {
                echo('Success');
            }

            $sql1 = "DELETE FROM mesh_tbl WHERE mesh_no = '".$result['filter_no']."'";

            if ($resultConn1= $conn -> query($sql1)) {
                echo('Success');
            }

            $sql2 = "UPDATE used_mesh SET date_used = '$timeStamp' WHERE mesh_no = '".$result['filter_no']."'";

            if ($resultConn2= $conn -> query($sql2)) {
                echo('Success');
            }
        }

        if(!empty($result['drain_no'])){
            date_default_timezone_set("US/Central");
            $timeStamp = date("Y-m-d H:i:s");
            $sql = "INSERT INTO used_mesh (mesh_no, supplier, job, tpm_po, date_received, width, length, heat, mesh, type)  SELECT mesh_no, supplier, job, tpm_po, date_received, width, length, heat, mesh, type FROM mesh_tbl WHERE mesh_no = '".$result['drain_no']."'";

            if ($resultConn= $conn -> query($sql)) {
                echo('Success');
            }

            $sql1 = "DELETE FROM mesh_tbl WHERE mesh_no = '".$result['drain_no']."'";

            if ($resultConn1= $conn -> query($sql1)) {
                echo('Success');
            }

            $sql2 = "UPDATE used_mesh SET date_used = '$timeStamp' WHERE mesh_no = '".$result['drain_no']."'";

            if ($resultConn2= $conn -> query($sql2)) {
                echo('Success');
            }
        }
        

    }
    
?>