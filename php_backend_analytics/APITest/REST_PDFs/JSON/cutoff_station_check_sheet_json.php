<?php
    if(isset($_GET['from']) && !empty($_GET['from']))
        $from = $_GET['from'];
    else
        $from = 1;
    if(isset($_GET['to']))
        $too = $_GET['to'];
    else
        $too = 20;
    $alldigit = range($from, $too);
    $allLoop = array_chunk($alldigit, 25); 
    $pages_count = $allLoop;
    
?>
<?php
    include '../Connections/connectionTPM.php';
    $sql = "SELECT * FROM orders_tbl WHERE job = $job";

    if ($result= $conn -> query($sql)) {
	
	}
	
    //fetch resulting rows as an array
    $orderACT = mysqli_fetch_assoc($result);

    $sql1 = "SELECT * FROM part_tbl WHERE part = '".$orderACT['part']."'";

    if ($result1= $conn -> query($sql1)) {
	
	}
	
    //fetch resulting rows as an array
    $partSpec = mysqli_fetch_assoc($result1);

    $sql2 = "SELECT * FROM weld_spec_repair WHERE weld_spec = '".$orderACT['weld_spec_repair']."'";

    if ($result2= $conn -> query($sql2)) {
	
	}
	
    //fetch resulting rows as an array
    $weldSpecRep = mysqli_fetch_assoc($result2);

    //finding next tube to cutoff
    $sql3 = "SELECT * FROM tubes_tbl WHERE cutoff_check = 0 AND job = $job AND mill_check = 1";

    if ($result3= $conn -> query($sql3)) {
	
	}
	
    //fetch resulting rows as an array
    $nextTubesCut = array();
    $nextTubeCut = "";
    while($tubes = mysqli_fetch_array($result3)){
        $nextTubesCut[] = $tubes;
    }

    if(!empty($nextTubesCut)){
        $nextTubeCut = $nextTubesCut[0]['id'];
    }
    



    $jsonArr = array(
            // 'from' => $from,
            // 'too' => $too,
            // 'pageCount' => $pages_count,
                'job' => $job,
                'poNum' => $orderACT['po'],
                'length' => $partSpec['finished_length'],
                'lineItem' => $orderACT['item'],
                'finLenPos' => $partSpec['length_plus'],
                'finLenNeg' => $partSpec['length_minus'],
                'quantity' => $orderACT['quantity'],
                'od' => $partSpec['dim'],
                'odPos' => $partSpec['dim_plus'],
                'odNeg' => $partSpec['dim_minus'],
                'repairSpec' => $orderACT['weld_spec_repair'],
                'amps' => $weldSpecRep['repair_amps'],
                'volts' => $weldSpecRep['repair_volts'],
                'speed' => $weldSpecRep['repair_speed'],
                'fillerRod' => $weldSpecRep['filler_rod'],
                'nextTubeCut' => $nextTubeCut
    );
?>

