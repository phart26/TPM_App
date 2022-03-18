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
            $response = $data['checkInCoilData'];
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

    function calcTotalCycle($job){

        include '../Connections/connectionTPM.php';
        
        $sql = "SELECT * FROM stamping_orders_tbl WHERE job = '$job'";

        if ($result= $conn -> query($sql)) {
            
            }
            
        //fetch resulting rows as an array
        $orderAct = mysqli_fetch_assoc($result);
 
        $sql = "SELECT * FROM coil_tbl WHERE stamp_job = '$job' AND allocated = 1";

        if ($result= $conn -> query($sql)) {
            
            }
        
        $coils = array();
        //fetch resulting rows as an array
        while($order = mysqli_fetch_assoc($result)){
            $coils[] = $order;
        }

        
        $totalCycleCount = 0;
        $totalCycleJob = intval($orderAct['millCycles']);

        foreach($coils as $coilNum){
            $totalCycleCount += intval($coilNum['cycles']);

        }

        echo $totalCycleJob;

        if($totalCycleCount >= $totalCycleJob){
            return False;
        }else{
            return True;
        }


    }
?>

<?php
    if(isset($_POST)){
        $result = processRequest($_SERVER['REQUEST_METHOD']);

        date_default_timezone_set("US/Central");
        $timeStamp = date("Y-m-d H:i:s");
        $job = $result['job'];
        $coil = $result['coil_no'];

        
        
        $sql = "SELECT * FROM coil_tbl WHERE coil_no = '$coil'";

        if ($result= $conn -> query($sql)) {
                
            }
            
        //fetch resulting rows as an array
        $coilOld = mysqli_fetch_assoc($result);


        if(intval($coilOld['job']) != 0){
            
            if(calcTotalCycle(strval($job))){
                $sql1 = "UPDATE coil_tbl SET in_shop = 1, allocated = 1, date_received = '$timeStamp' WHERE coil_no = '$coil'";

                if ($result1= $conn -> query($sql1)) {
                   echo "success"; 
                }
            }else{
                $sql1 = "UPDATE coil_tbl SET in_shop = 1, date_received = '$timeStamp' WHERE coil_no = '$coil'";

                if ($result1= $conn -> query($sql1)) {
                    echo "success";
                }
            }

        }else{
            $sql1 = "UPDATE coil_tbl SET in_shop = 1, date_received = '$timeStamp' WHERE coil_no = '$coil'";

            if ($result1= $conn -> query($sql1)) {
                echo "success";
            }
        }

        
    }
          