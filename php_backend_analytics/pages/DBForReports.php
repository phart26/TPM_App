<?php
    
    //Get evrything from order table
    $sql = "SELECT * FROM orders_tbl WHERE job = $job";

    if ($result= $conn -> query($sql)) {

    }

    $orderACT = mysqli_fetch_assoc($result);




    //Get all the part specific info
    $sql1 = "SELECT * FROM part_tbl WHERE part = '".$orderACT['part']."'";

    if ($result1= $conn -> query($sql1)) {

    }
    $partSpec = mysqli_fetch_assoc($result1);




    //Get Weld repair stuff
    $sql2 = "SELECT * FROM weld_spec_repair WHERE weld_spec = '".$orderACT['weld_spec_repair']."'";
    if ($result2= $conn -> query($sql2)) {

    }
    $weldSpecRep = mysqli_fetch_assoc($result2);





    //Get all the Tubes
    $sql4 = "SELECT * FROM tubes_tbl WHERE job = $job ORDER BY id";

    if ($result4= $conn -> query($sql4)) {

    }
    $tubes = array();
    while($order = mysqli_fetch_array($result4)){
        $tubes[] = $order;
    }



    //Get inspector for job
    $sql3 = "SELECT * FROM employee WHERE ID = '".$tubes[0]['inspector']."'";

    if ($result3= $conn -> query($sql3)) {

    }
    $insp = mysqli_fetch_assoc($result3);



    //Get cutoff operator
    $sql6 = "SELECT * FROM employee WHERE ID = '".$tubes[0]['cutoff_operator']."'";

    if ($result6= $conn -> query($sql6)) {

    }
    $cutOp = mysqli_fetch_assoc($result6);




    //Get ring inspector
    $sql7 = "SELECT * FROM employee WHERE ID = '".$tubes[0]['ring_end_insp']."'";

    if ($result7= $conn -> query($sql7)) {

    }
    $ringInsp = mysqli_fetch_assoc($result7);





    //Get drift Inspector
    $sql5 = "SELECT * FROM employee WHERE ID = '".$orderACT['drift_insp']."'";

    if ($result5= $conn -> query($sql5)) {

    }
    $drift = mysqli_fetch_assoc($result5);




    //Get thickness of material for tubes
    $sql8 = "SELECT * FROM gage_tbl WHERE gage = '".$partSpec['gage']."'";

    if ($result8= $conn -> query($sql8)) {

    }

    $thick = mysqli_fetch_assoc($result8);




    //Get mill operator
    $sql9 = "SELECT * FROM employee WHERE ID = '".$orderACT['mill_operator']."'";

    if ($result9= $conn -> query($sql9)) {

    }

    $millOp = mysqli_fetch_assoc($result9);




    //Get rings for job
    $sql11 = "SELECT * FROM ring_tbl WHERE job = $job";

    if ($result11= $conn -> query($sql11)) {

    }
    $rings = array();
    while($order = mysqli_fetch_array($result11)){
        $rings[] = $order;
    }



    //Get heat number on coils
    $sql12 = "SELECT * FROM new_materials WHERE coil_no = '".$tubes[0]['coil']."'";

    if ($result12= $conn -> query($sql12)) {

    }
    $heatNum = mysqli_fetch_assoc($result12);




    //Get container type for shipping
    $sql13 = "SELECT * FROM cont WHERE ID = '".$orderACT['cont_type']."'";

    if ($result13= $conn -> query($sql13)) {

    }
    $contType = mysqli_fetch_assoc($result13);




    //Get shipping Method
    $sql14 = "SELECT * FROM ship_method WHERE ID = '".$orderACT['ship_method']."'";

    if ($result14= $conn -> query($sql14)) {

    }
    $shipMeth = mysqli_fetch_assoc($result14);
?>