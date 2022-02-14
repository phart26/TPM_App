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

     //finding next tube to cutoff
    $sql2 = "SELECT * FROM tubes_tbl WHERE cutoff_check = 1 AND job = $job AND mill_check = 1 AND insp_check = 0";

    if ($result2= $conn -> query($sql2)) {
	
	}
	
    //fetch resulting rows as an array
    $nextTubesInsp = array();
    $nextTubeInsp = "";
    while($tubes = mysqli_fetch_array($result2)){
        $nextTubesInsp[] = $tubes;
    }

    if(!empty($nextTubesInsp)){
        $nextTubeInsp = $nextTubesInsp[0]['id'];
    }
 
    $jsonArr = array(
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
            'idDrift' => $partSpec['drift'],
            'inspNotes' => $partSpec['insp_notes'],
            'nextTubeInsp' => $nextTubeInsp
    );

    
?>