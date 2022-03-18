
<?php
     include '../Connections/connectionTPM.php';
     $sql = "SELECT * FROM orders_tbl WHERE job = $job";
 
     if ($result= $conn -> query($sql)) {
         
         }
         
     //fetch resulting rows as an array
     $orderACT = mysqli_fetch_assoc($result);
    //  $orderACT = $result->fetch_array($result);
 
     $sql1 = "SELECT * FROM part_tbl WHERE part = '".$orderACT['part']."'";
 
     if ($result1= $conn -> query($sql1)) {
         
        }
         
     //fetch resulting rows as an array
     $partSpec = mysqli_fetch_assoc($result1);

     $sql2 = "SELECT * FROM gage_tbl WHERE gage = '".$partSpec['gage']."'";

    if ($result2= $conn -> query($sql2)) {
	
	}
	
    //fetch resulting rows as an array
    $gageSpec = mysqli_fetch_assoc($result2);

    $sql3 = "SELECT * FROM steel_tbl WHERE gage = '".$partSpec['gage']."'";

    if ($result3= $conn -> query($sql3)) {
	
	}
	
    //fetch resulting rows as an array
    $steelSpec = mysqli_fetch_assoc($result3);

    $sql4 = "SELECT * FROM die_tbl WHERE die = '".$partSpec['die']."'";

    if ($result4= $conn -> query($sql4)) {
	
	}
	
    //fetch resulting rows as an array
    $dieSpec = mysqli_fetch_assoc($result4);

    $sql5 = "SELECT * FROM weld_spec_mill WHERE weld_spec = '".$orderACT['weld_spec_mill']."'";

    if ($result5= $conn -> query($sql5)) {
	
	}
	
    //fetch resulting rows as an array
    $weldSpec = mysqli_fetch_assoc($result5);

    $sql6 = "SELECT * FROM weld_spec_repair WHERE weld_spec = '".$orderACT['weld_spec_repair']."'";

    if ($result6= $conn -> query($sql6)) {
	
	}
	
    //fetch resulting rows as an array
    $weldSpecRep = mysqli_fetch_assoc($result6);

    $jsonArr = array(
            'poNum' => $orderACT['po'],
            'mill' => $orderACT['device'],
            'material' => $partSpec['type'],
            'actMillAngle' => $partSpec['act_mill_angle'],
            'lineItem' => $orderACT['item'],
            'job' => $job,
            'partNum' => $orderACT['part'],
            'dieID' => $dieSpec['die_id'],
            'stripWidth' => $partSpec['strip'],
            'gage' => $partSpec['gage'],
            'thickness' => $gageSpec['thickness'],
            'pattern' => $partSpec['pattern'],
            'millSpec' => $orderACT['weld_spec_mill'],
            'fractionsHole' => $steelSpec['holes'],
            'fractionsCenter' => $steelSpec['centers'],
            'millAmps' => $weldSpec['mil_amps'],
            'millVolts' => $weldSpec['mil_volts'],
            'millSpeed' => $weldSpec['mil_speed'],
            'milltorchHeight' => $weldSpec['torch_height'],
            'archLength' => $weldSpec['Arc_length'],
            'torchAngle' => $weldSpec['Torch_angle'],
            'od' => $partSpec['dim'],
            'odPos' => $partSpec['dim_plus'],
            'odNeg' => $partSpec['dim_minus'],
            'repairSpec' => $orderACT['weld_spec_repair'],
            'idDrift' => $partSpec['drift'],
            'repairAmps' => $weldSpecRep['repair_amps'],
            'repairVolts' => $weldSpecRep['repair_volts'],
            'repairSpeed' => $weldSpecRep['repair_speed'],
            'fillerRod' => $weldSpecRep['filler_rod'],
            'repairTorchHeight' => $weldSpecRep['torch_height'],
            'electroLength' => $weldSpecRep['electro_length'],
            'gasRepair' => $weldSpecRep['gas_repair'],
            'dimpleDepth' => $partSpec['depth_of_dimple'],
            'dimpleDepthM' => $partSpec['depth_of_dimple_minus'],
            'notes' => $partSpec['notes']
            
    );

    
?>