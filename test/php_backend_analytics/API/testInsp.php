<?php
    include '../Connections/connectionTPM.php';
    require './vendor/autoload.php';
    use \Firebase\JWT\JWT;
?>

<?php
    if(isset($_GET['job'])){
        $sql1 = "SELECT * FROM orders_tbl WHERE has_finished = 1 AND has_started = 1 AND job > 7800";

            //make query & get result
            if ($result1= $conn -> query($sql1)) {
                
            }

            $ordersACT = array();
            
            while($order = mysqli_fetch_array($result1)){
                $ordersACT[] = $order;
            }
            
            $finalArray = [];
            foreach($ordersACT as $jobNum){
                $sql2 = "SELECT * FROM tubes_tbl WHERE job = '".$jobNum['job']."' AND insp_check = 1";
                if ($result2= $conn -> query($sql2)) {
                
                }

                $tubes = array();
                while($order = mysqli_fetch_array($result2)){
                    $tubes[] = $order;
                }
                $sql3 = "SELECT * FROM orders_tbl WHERE job = '".$jobNum['job']."'";
                if ($result3= $conn -> query($sql3)) {
                
                }
                $order = mysqli_fetch_array($result3);

                if($order['quantity'] != sizeof($tubes)){
                    $jobWithODL = array();
                    array_push($jobWithODL, $jobNum['job']);
                    $sql = "SELECT * FROM part_tbl WHERE part = '".$jobNum['part']."'";
                    if ($result= $conn -> query($sql)) {
                    
                    }
                    $subOrder = mysqli_fetch_array($result);
                    array_push($jobWithODL, $subOrder['dim']);
                    array_push($jobWithODL, $subOrder['finished_length']);
                    array_push($finalArray, $jobWithODL);
                }
            }
            echo JSON_encode($finalArray);
    }
?>