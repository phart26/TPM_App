<?php
    include '../Connections/connectionTPM.php';
?>

<?php
    $sql = 'SELECT * FROM tubes_tbl WHERE coil_change = 1';

    if ($result= $conn -> query($sql)) {

    }

    $tubes = array();
    while($order = mysqli_fetch_array($result)){
        $tubes[] = $order;
    }

    foreach($tubes as $tube){
        $coil_no = $tube['coil'];
        $job = $tube['job'];
        $date_used = $tube['mill_time'];
        $sql = "INSERT INTO used_coil(coil_no, job, date_used) VALUES('$coil_no', '$job', '$date_used')";

        if ($result= $conn -> query($sql)) {

        }

        echo 'success';
    }
?>