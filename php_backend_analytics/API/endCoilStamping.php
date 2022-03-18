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
            $response = $data['endCoilData'];
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
        $press_op = $result['press_op'];
        $timeStamp = date("Y-m-d H:i:s");
        $job = $result['job'];
        $coil = $result['coil_no'];
        $millJob = intval($result['mill_job']);
        $new_coil = $result['new_coil'];
        $cycle_id = $result['cycle_id'];
        $hit_count = $result['hit_count'];
        $progression = $result['progression'];
        
    if($new_coil == 1){

        // if its a continuous job
        if($hit_count != ""){
            $sql1 = "SELECT * FROM raw_coil_tbl WHERE coil_no = '$coil'";

            if ($result1= $conn -> query($sql1)) {
                
                }
                
            //fetch resulting rows as an array
            $coilArr = mysqli_fetch_assoc($result1);

            $footage = intval(floor(((doubleval($coilArr['cycles']) * 1000 + intval($hit_count)) * doubleval($progression)) / 12));

            $sql1 = "UPDATE raw_coil_tbl SET footage = '$footage' WHERE coil_no = '$coil'";

            if ($resultConn1= $conn -> query($sql1)) {
                echo('Success');
            }
        }

        $sql = "INSERT INTO coil_tbl (coil_no, work, weight, date_received, cycles, footage) SELECT coil_no, work, weight, date_received, cycles, footage FROM raw_coil_tbl WHERE coil_no = '$coil'";

        if ($resultConn= $conn -> query($sql)) {
            echo('Success');
        }


        $sql1 = "DELETE FROM raw_coil_tbl WHERE coil_no = '$coil'";

        if ($resultConn1= $conn -> query($sql1)) {
            echo('Success');
        }

        $sql1 = "UPDATE coil_tbl SET job = '$millJob', stamp_job='$job' WHERE coil_no = '$coil'";

        if ($resultConn1= $conn -> query($sql1)) {
            echo('Success');
        }

    }

    if($result['endJob'] == '1'){
        $sql1 = "UPDATE stamping_orders_tbl SET has_finished = 1 WHERE job = '$job'";

        if ($resultConn1= $conn -> query($sql1)) {
            echo('Success');
        }
    }
}