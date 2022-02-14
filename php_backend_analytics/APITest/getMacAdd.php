<?php
    include '../Connections/connectionTPM.php';
    $sql = "SELECT * FROM orders_tbl WHERE job = $job";

    //make query & get result
    if ($result= $conn -> query($sql)) {
                
    }

    $mill_job = mysqli_fetch_array($result);


    //generates device name for pulling from database        
    $device = "mill_0".$mill_job['Mill'];

    $sql26 = "SELECT * FROM mac_add_tbl WHERE device = '$device'";

    //make query & get result
    if ($result26= $conn -> query($sql26)) {
                
    }

    $MAC_add_line = mysqli_fetch_array($result26);

    $MAC_add = $MAC_add_line['MAC_address'];
    $mill = $mill_job["Mill"];
?>