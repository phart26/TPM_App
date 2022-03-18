<?php
    include '../Connections/connectionTPM.php';
    $millOpArr = array();
    $cutOpArr = array();
    $inspArr = array();

    $millOpTubArr = array();
    $cutOpTubArr = array();
    $inspTubArr = array();

    array_push($millOpArr, $tubes[0]['mill_operator']);
    array_push($cutOpArr, $tubes[0]['cutoff_operator']);
    array_push($inspArr, $tubes[0]['inspector']);

    $tubeCount = 1;

    foreach($tubes as $tube){
        if(!in_array($tube['mill_operator'], $millOpArr)){
            array_push($millOpArr, $tube['mill_operator']);
            $millOpTubArr[array_search($tube['mill_operator'], $millOpArr) -1] = $tubeCount;

        }
        if(!in_array($tube['cutoff_operator'], $cutOpArr)){
            array_push($cutOpArr, $tube['cutoff_operator']);
            $cutOpTubArr[array_search($tube['cutoff_operator'], $cutOpArr) -1] = $tubeCount;
            
        }
        if(!in_array($tube['inspector'], $inspArr)){
            array_push($inspArr, $tube['inspector']);
            $inspTubArr[array_search($tube['inspector'], $inspArr) -1] = $tubeCount;
            
        }

        $tubeCount++;
    }


?>

<?php

    $coilArr = array();
    $drainArr = array();
    $filterArr = array();

    $coilTube = array();
    $drainTube = array();
    $filterTube = array();

    $sql11 = "SELECT * FROM tubes_tbl WHERE job = $job AND coil_change = 1";

    if ($result11= $conn -> query($sql11)) {

    }
    $coils = array();
    while($order = mysqli_fetch_array($result11)){
        $coils[] = $order;
    }

    foreach($coils as $coil){
        array_push($coilArr, $coil['coil']);
        array_push($coilTube, substr($coil['id'],5));
    }




    $sql11 = "SELECT * FROM tubes_tbl WHERE job = $job AND drain_change_top = 1";

    if ($result11= $conn -> query($sql11)) {

    }
    $drains = array();
    while($order = mysqli_fetch_array($result11)){
        $drains[] = $order;
    }

    foreach($drains as $drain){
        array_push($drainArr, $drain['coil']);
        array_push($drainTube, substr($drain['id'],5));
    }



    $sql11 = "SELECT * FROM tubes_tbl WHERE job = $job AND mesh_change_top = 1";

    if ($result11= $conn -> query($sql11)) {

    }
    $filters = array();
    while($order = mysqli_fetch_array($result11)){
        $filters[] = $order;
    }

    foreach($filters as $filter){
        array_push($filterArr, $filter['coil']);
        array_push($filterTube, substr($filter['id'],5));
    }

?>

<?php

    function getEmployee($emp_id){
        include '../Connections/connectionTPM.php';
        $sql = "SELECT * FROM employee WHERE ID = '".$emp_id."'";
        //make query & get result
        if ($result= $conn -> query($sql)) {
                            
        }
                            
        //fetch resulting rows as an array
        $employee = mysqli_fetch_assoc($result);

        return $employee['name'];
    }
?>
<div id="pagebreak" class="pagebreak">
        
        <div class="titleImg">
                <h2 class="title" style="font-size: 28px;">
                    <strong>TPM Overview Sheet</strong>
                </h2>
                <div class="image"> <img src="logo_tpm.jpeg"></div>
        </div>

        <table>
            <tr>
                <td style="width : 30%;"><h3>Job#: <?= $job ?></h3></td>
                <td style="width : 30%;"><h3>PO#: <?= $orderACT['po'] ?></h3></td>
                <td style="width : 30%;"><h3>Mill: <?= $orderACT['past_mill'] ?></h3></td>
            </tr>

            <tr>
                <td style="width : 45%;"><h3>Quantity: <?= $orderACT['quantity'] ?></h3></td>
                <td style="width : 45%;"><h3>Company: <?= getCustomer($orderACT['cust_id']) ?></h3></td>
            </tr>
            
            <tr>
                <td>
                    <h3 class="margin-b-15">
                    Dates of Operation:  <?= date('Y-m-d', strtotime($orderACT['start_time']))?> to <?= date('Y-m-d', strtotime($orderACT['shipped']))?><h3>
                </td>
            </tr>
            
            <tr>
                <td><h2>Operators/Inspectors</h2></td>
                <td></td>
                <td><h2>Tubes</h2></td>
            </tr>

            <tr>
                <td><h3>Mill Operator(s)</h3></td>
            </tr>

            <?php $tubeStart = 1; foreach($millOpArr as $operator): ?>
                <tr>
                    <td><?php echo getEmployee($operator);?></td>
                    <td></td>
                    <td><?php 
                                if(!empty($millOpTubArr[array_search($operator, $millOpArr)])){
                                    echo str_pad($tubeStart, 3, '0', STR_PAD_LEFT) ." - ".str_pad(($tubeStart + $millOpTubArr[array_search($operator, $millOpArr)] - 1), 3, '0', STR_PAD_LEFT); 
                                    
                                    $tubeStart = $tubeStart + $millOpTubArr[array_search($operator, $millOpArr)]; 
                                }else{
                                    echo str_pad($tubeStart, 3, '0', STR_PAD_LEFT) ." - ".str_pad($orderACT['quantity'], 3, '0', STR_PAD_LEFT); 
                                }?></td>
                </tr>
            <?php endforeach;?>

            <tr>
                <td><h3>Cutoff Operator(s)</h3></td>
            </tr>

            <?php $tubeStart = 1; foreach($cutOpArr as $operator): ?>
                <tr>
                    <td><?php echo getEmployee($operator);?></td>
                    <td></td>
                    <td><?php 
                                if(!empty($cutOpTubArr[array_search($operator, $cutOpArr)])){
                                    echo str_pad($tubeStart, 3, '0', STR_PAD_LEFT) ." - ".str_pad(($tubeStart + $cutOpTubArr[array_search($operator, $cutOpArr)] - 1), 3, '0', STR_PAD_LEFT); 
                                    
                                    $tubeStart = $tubeStart + $cutOpTubArr[array_search($operator, $cutOpArr)]; 
                                }else{
                                    echo str_pad($tubeStart, 3, '0', STR_PAD_LEFT) ." - ".str_pad($orderACT['quantity'], 3, '0', STR_PAD_LEFT); 
                                }?></td>
                </tr>
            <?php endforeach;?>

            <tr>
                <td><h3>Inspector(s)</h3></td>
            </tr>

            <?php $tubeStart = 1; foreach($inspArr as $operator): ?>
                <tr>
                    <td><?php echo getEmployee($operator);?></td>
                    <td></td>
                    <td><?php 
                                if(!empty($inspTubArr[array_search($operator, $inspArr)])){
                                    echo str_pad($tubeStart, 3, '0', STR_PAD_LEFT) ." - ".str_pad(($tubeStart + $inspTubArr[array_search($operator, $inspArr)] - 1), 3, '0', STR_PAD_LEFT); 
                                    
                                    $tubeStart = $tubeStart + $inspTubArr[array_search($operator, $inspArr)]; 
                                }else{
                                    echo str_pad($tubeStart, 3, '0', STR_PAD_LEFT) ." - ".str_pad($orderACT['quantity'], 3, '0', STR_PAD_LEFT); 
                                }?></td>
                </tr>
            <?php endforeach;?>
        </table>
        <table>
            <tr>
                <td><h2>Material</h2></td>
            </tr>
        

            <tr>
                <td style="text-align:left; width:15%;"><b>Coils</b></td>
                <td style="text-align:left; width:15%;"><b>Tube Number</b></td>
                <td style="text-align:left; width:15%;"><b>Drainage</b></td>
                <td style="text-align:left; width:15%;"><b>Tube Number</b></td>
                <td style="text-align:left; width:15%;"><b>Filter</b></td>
                <td style="text-align:left; width:15%;"><b>Tube Number</b></td>
            </tr>
            <tr>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
            </tr>

            <tr>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
            </tr>

            <?php for($i = 0; $i < sizeof($coilArr); $i++): ?>
                <tr>
                    <td style="text-align:left;"><?php 
                            if(!empty($coilArr[$i])){
                                echo $coilArr[$i];
                            }else{
                            }?></td>
                    <td style="text-align:left;"><?php 
                            if(!empty($coilArr[$i])){
                                echo $coilTube[$i];
                            }else{
                            }?></td>
                    <td style="text-align:left;"><?php 
                            if(!empty($drainArr[$i])){
                                echo $drainArr[$i];
                            }else{
                            }?></td>
                    <td style="text-align:left;"><?php 
                            if(!empty($drainArr[$i])){
                                echo $drainTube[$i];
                            }else{
                            }?></td>
                    <td style="text-align:left;"><?php 
                            if(!empty($filterArr[$i])){
                                echo $filterArr[$i];
                            }else{
                            }?></td>
                    <td style="text-align:left;"><?php 
                            if(!empty($filterArr[$i])){
                                echo $filterTube[$i];
                            }else{
                            }?></td>
                </tr>
            <?php endfor;?>
            
        
        </table>
        
             
</div>
