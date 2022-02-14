<?php
    // if(isset($_GET['from']) && !empty($_GET['from']))
    //     $from = $_GET['from'];
    // else
    //     $from = 1;
    // if(isset($_GET['to']))
    //     $too = $_GET['to'];
    // else
    //     $too = 20;
    // $alldigit = range($from, $too);
    // $allLoop = array_chunk($alldigit, 25); 
    // $pages_count = $allLoop;
    
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

     //finding next tube to send to Excluder
     $sql3 = "SELECT * FROM tubes_tbl WHERE (end1_read1 = 0 AND end2_read1 = 0) AND job = $job AND insp_check = 1";

     if ($result3= $conn -> query($sql3)) {
     
     }
     
     //fetch resulting rows as an array
     $nextTubesExcl = array();
     $nextTubeExcl = "";
     while($tubes = mysqli_fetch_array($result3)){
         $nextTubesExcl[] = $tubes;
     }
 
     if(!empty($nextTubesExcl)){
         $nextTubeExcl = $nextTubesExcl[0]['id'];
     }
    
    $jsonArr = array(
            'job' => $job,
            'poNum' => $orderACT['po'],
            'ringMin1' => $partSpec['ring1_min_input'],
            'ringMax1' => $partSpec['ring1_max_input'],
            'ringMin2' => $partSpec['ring2_min_input'],
            'ringMax2' => $partSpec['ring2_max_input'],
            'lineItem' => $orderACT['item'],
            'quantity' => $orderACT['quantity'],
            'partDesc' => $partSpec['description'],
            'nextTubeExcl' => $nextTubeExcl,
            // 'from' => $from,
            // 'too' => $too,
            // 'pageCount' => $pages_count
    );

    
?>