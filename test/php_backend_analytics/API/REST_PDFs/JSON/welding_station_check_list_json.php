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

   $sql5 = "SELECT * FROM weld_spec_mill WHERE weld_spec = '".$orderACT['weld_spec_mill']."'";

   if ($result5= $conn -> query($sql5)) {
   
   }
   
   //fetch resulting rows as an array
   $weldSpec = mysqli_fetch_assoc($result5);

   //finding next tube to cutoff
   $sql6 = "SELECT * FROM tubes_tbl WHERE job = $job AND mill_check = 0";

   if ($result6= $conn -> query($sql6)) {
   
   }
   
   //fetch resulting rows as an array
   $nextTubesMill = array();
   $nextTubeMill = "";
   $nextTube = "";
   while($tubes = mysqli_fetch_array($result6)){
       $nextTubesMill[] = $tubes;
   }

   if(!empty($nextTubesMill)){
       $nextTubeMill = $nextTubesMill[0]['id'];
   }

   if($nextTubeMill == ""){

        $sql6 = "SELECT * FROM tubes_tbl WHERE job = $job AND mill_check = 1 ORDER BY id DESC";

        if ($result6= $conn -> query($sql6)) {
        
        }
        
        while($tubes = mysqli_fetch_array($result6)){
            $nextTubes[] = $tubes;
        }

        if(!empty($nextTubes) && (intval((substr($nextTubes[0]['id'], strpos($nextTubes[0]['id'],'-')+1))) != intval($orderACT['quantity']))){
            $nextTube = substr($nextTubes[0]['id'], 0, 5).str_pad(strval(intval(substr($nextTubes[0]['id'], strpos($nextTubes[0]['id'],'-') +1))+1), strlen($orderACT['quantity']),"0", STR_PAD_LEFT);
        }
    }

    $jsonArr = array(
            'job' => $job,
            'poNum' => $orderACT['po'],
            'cutoffLength' => $partSpec['cutoff_length'],
            'cutoffLengthP' => $partSpec['length_plus'],
            'cutoffLengthM' => $partSpec['length_minus'],
            'lineItem' => $orderACT['item'],
            'millSpec' => $orderACT['weld_spec_mill'],
            'quantity' => $orderACT['quantity'],
            'od' => $partSpec['dim'],
            'odPos' => $partSpec['dim_plus'],
            'odNeg' => $partSpec['dim_minus'],
            'millAmps' => $weldSpec['mil_amps'],
            'millVolts' => $weldSpec['mil_volts'],
            'millSpeed' => $weldSpec['mil_speed'],
            'millTorchHeight' => $weldSpec['torch_height'],
            'arcLength' => $weldSpec['Arc_length'],
            'torchAngle' => $weldSpec['Torch_angle'],
            'nextTubeMill' => $nextTubeMill,
            'nextTube' => $nextTube
    );

    
?>