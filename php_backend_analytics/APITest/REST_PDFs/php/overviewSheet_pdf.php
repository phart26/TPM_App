<?php
    // include '../Connections/connectionTPM.php';
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
    $TubeCoil = array();
    $mesh = array();

    $coilArr = array();
    $drainTopArr = array();
    $filterTopArr = array();
    $drainBotArr = array();
    $filterBotArr = array();

    $coilTube = array();
    $drainTopTube = array();
    $filterTopTube = array();
    $drainBotTube = array();
    $filterBotTube = array();

    $sql11 = "SELECT * FROM tubes_tbl WHERE job = $job AND coil_change = 1";

    if ($result11= $conn -> query($sql11)) {

    }
    $coils = array();
    while($order = mysqli_fetch_array($result11)){
        $coils[] = $order;
    }

    foreach($coils as $coil){
        //getting work number from coil
        $sql12 = "SELECT * FROM used_coil WHERE coil_no = '".$coil['coil']."'";

            if ($result12= $conn -> query($sql12)) {

            }
            $TubeCoil = mysqli_fetch_array($result12);

            if(empty($TubeCoil)){
                $sql12 = "SELECT * FROM coil_tbl WHERE coil_no = '".$coil['coil']."'";

                if ($result12= $conn -> query($sql12)) {

                }
                $TubeCoil = mysqli_fetch_array($result12);
            }

            //getting heat and type of coil
            $sql13 = "SELECT * FROM steel_tbl WHERE work = '".$TubeCoil['work']."'";

            if ($result13= $conn -> query($sql13)) {

            }
            $steel = mysqli_fetch_array($result13);

            $coilComboArr = array($coil['coil'], $steel['heat'], $steel['material']);

            array_push($coilArr, $coilComboArr);
            array_push($coilTube, substr($coil['id'],strpos($coil['id'], '-')+1));
    }




    $sql11 = "SELECT * FROM tubes_tbl WHERE job = $job AND drain_change_top = 1";

    if ($result11= $conn -> query($sql11)) {

    }
    $drains = array();
    while($order = mysqli_fetch_array($result11)){
        $drains[] = $order;
    }

    if(sizeOf($drains) > 1){
        foreach($drains as $drain){
            $sql11 = "SELECT * FROM used_mesh WHERE mesh_no = '".$drain['drain_mesh_top']."'";

            if ($result11= $conn -> query($sql11)) {

            }
            $mesh = mysqli_fetch_array($result11);

            if(empty($mesh)){
                $sql11 = "SELECT * FROM mesh_tbl WHERE mesh_no = '".$drain['drain_mesh_top']."'";

                if ($result11= $conn -> query($sql11)) {

                }
                $mesh = mysqli_fetch_array($result11);
            }

            $meshArr = array($drain['drain_mesh_top'], $mesh['heat'], $mesh['type']);

            array_push($drainTopArr, $meshArr);
            array_push($drainTopTube, substr($drain['id'],strpos($drain['id'], '-')+1));
        }
    }





    $sql11 = "SELECT * FROM tubes_tbl WHERE job = $job AND fil_mesh_change_top = 1";

    if ($result11= $conn -> query($sql11)) {

    }
    $filters = array();
    while($order = mysqli_fetch_array($result11)){
        $filters[] = $order;
    }

    if(sizeOf($filters) > 1){
        foreach($filters as $filter){
            $sql11 = "SELECT * FROM used_mesh WHERE mesh_no = '".$filter['filter_mesh_top']."'";

            if ($result11= $conn -> query($sql11)) {

            }
            $mesh = mysqli_fetch_array($result11);

            if(empty($mesh)){
                $sql11 = "SELECT * FROM mesh_tbl WHERE mesh_no = '".$filter['filter_mesh_top']."'";

                if ($result11= $conn -> query($sql11)) {

                }
                $mesh = mysqli_fetch_array($result11);
            }
            
            $meshArr = array($filter['filter_mesh_top'], $mesh['heat'], $mesh['type']);

            array_push($filterTopArr, $meshArr);
            array_push($filterTopTube, substr($filter['id'],strpos($filter['id'], '-')+1));
        }
    }



    $sql11 = "SELECT * FROM tubes_tbl WHERE job = $job AND fil_mesh_change_bot = 1";

    if ($result11= $conn -> query($sql11)) {

    }
    $filters = array();
    while($order = mysqli_fetch_array($result11)){
        $filters[] = $order;
    }

    foreach($filters as $filter){
        $sql11 = "SELECT * FROM used_mesh WHERE mesh_no = '".$filter['filter_mesh_bot']."'";

            if ($result11= $conn -> query($sql11)) {

            }
            $mesh = mysqli_fetch_array($result11);

            if(empty($mesh)){
                $sql11 = "SELECT * FROM mesh_tbl WHERE mesh_no = '".$filter['filter_mesh_bot']."'";

                if ($result11= $conn -> query($sql11)) {

                }
                $mesh = mysqli_fetch_array($result11);
            }
            $meshArr = array($filter['filter_mesh_bot'], $mesh['heat'], $mesh['type']);

            array_push($filterBotArr, $meshArr);
            array_push($filterBotTube, substr($filter['id'],strpos($filter['id'], '-')+1));
    }


    $sql11 = "SELECT * FROM tubes_tbl WHERE job = $job AND drain_change_bot = 1";

    if ($result11= $conn -> query($sql11)) {

    }
    $drains = array();
    while($order = mysqli_fetch_array($result11)){
        $drains[] = $order;
    }

    if(sizeOf($drains) > 1){
        foreach($drains as $drain){
            $sql11 = "SELECT * FROM used_mesh WHERE mesh_no = '".$drain['drain_mesh_bot']."'";

            if ($result11= $conn -> query($sql11)) {

            }
            $mesh = mysqli_fetch_array($result11);

            if(empty($mesh)){
                $sql11 = "SELECT * FROM mesh_tbl WHERE mesh_no = '".$drain  ['drain_mesh_bot']."'";

                if ($result11= $conn -> query($sql11)) {

                }
                $mesh = mysqli_fetch_array($result11);
            }
            $meshArr = array($drain['drain_mesh_bot'], $mesh['heat'], $mesh['type']);

            array_push($drainBotArr, $meshArr);
            array_push($drainBotTube, substr($drain['id'],strpos($drain['id'], '-')+1));
        }
    }

    $maxMat = max(sizeOf($drainTopArr), sizeOf($filterTopArr), sizeOf($drainBotArr), sizeOf($filterBotArr), sizeOf($coilArr));

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
                <td style="width : 30%;"><h3>Mill: <?= $orderACT['device'] ?></h3></td>
            </tr>

            <tr>
                <td style="width : 45%;"><h3>Quantity: <?= $orderACT['quantity'] ?></h3></td>
                <td style="width : 45%;"><h3>Company: <?= getCustomer($orderACT['cust_id']) ?></h3></td>
            </tr>
            
            <tr>
                <td>
                    <h3 class="margin-b-15">
                    Dates of Operation:  <?= date('Y-m-d', strtotime($orderACT['began']))?> to <?= date('Y-m-d', strtotime($orderACT['shipped']))?><h3>
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
            <tr><td>&nbsp</td></tr>
            <tr><td>&nbsp</td></tr>
            <tr><td>&nbsp</td></tr>
            <tr><td>&nbsp</td></tr>
            <tr><td>&nbsp</td></tr>
        </table>
        <?php 
            $from = 0;
            $to;
            if($maxMat < 15){
                $to = $maxMat;
            }else{
                $to = 15;
            }
            $numPages = ceil($maxMat/$to);
            
        
            while($numPages > 0){
        ?>
        <table>
            <tr>
                <td style="font-size: 20px;"><b>Used Material</b></td>
            </tr>
            <tr><td>&nbsp</td></tr>
            <tr><td>&nbsp</td></tr>
        </table>
        <table>
            <tr>
                <td style="text-align:center; width:60%;"><b>*Shows tubes where material was changed out for a new coil. Intermediate tubes used the new coil until another changed occurred.</b></td>
            </tr>
            <tr><td>&nbsp</td></tr>
            <tr>
                <td style="text-align:center; width:60%;"><b>*Format: (coil number, heat number, material type) followed by tube number in next column.</b></td>
            </tr>
            <tr><td>&nbsp</td></tr>
        </table>
        <table>
            <tr>
                <td style="text-align:left; width:10%; font-size: 18px;"><b>Steel</b></td>
                <td style="text-align:left; width:10%; font-size: 18px;"><b>Tube#</b></td>
                <td style="text-align:left; width:10%; font-size: 18px;"><b>Fil. Mesh 1</b></td>
                <td style="text-align:left; width:10%; font-size: 18px;"><b>Tube#</b></td>
                <td style="text-align:left; width:10%; font-size: 18px;"><b>Fil. Mesh 2</b></td>
                <td style="text-align:left; width:10%; font-size: 18px;"><b>Tube#</b></td>
                <td style="text-align:left; width:10%; font-size: 18px;"><b>Drain. Mesh 1</b></td>
                <td style="text-align:left; width:10%; font-size: 18px;"><b>Tube#</b></td>
                <td style="text-align:left; width:10%; font-size: 18px;"><b>Drain. Mesh 2</b></td>
                <td style="text-align:left; width:10%; font-size: 18px;"><b>Tube#</b></td>
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

            <?php for($i = 0; $i < $to; $i++): ?>
                <tr>
                    <td style="text-align:left; font-size: 14px;"><?php 
                            if(!empty($coilArr[$i])){
                                echo $coilArr[$i][0];
                                echo(",  ");
                                echo $coilArr[$i][1];
                                echo(",  ");
                                echo $coilArr[$i][2];
                            }else{
                            }?></td>
                    <td style="text-align:left; font-size: 14px;"><?php 
                            if(!empty($coilArr[$i])){
                                echo $coilTube[$i];
                            }else{
                            }?></td>
                    <td style="text-align:left; font-size: 14px;"><?php 
                            if(!empty($filterTopArr[$i])){
                                echo $filterTopArr[$i][0];
                                echo(",  ");
                                echo $filterTopArr[$i][1];
                                echo(",  ");
                                echo $filterTopArr[$i][2];
                            }else{
                            }?></td>
                    <td style="text-align:left; font-size: 14px;"><?php 
                            if(!empty($filterTopArr[$i])){
                                echo $filterTopTube[$i];
                            }else{
                            }?></td>
                    <td style="text-align:left; font-size: 14px;"><?php 
                            if(!empty($filterBotArr[$i])){
                                echo $filterBotArr[$i][0];
                                echo(",  ");
                                echo $filterBotArr[$i][1];
                                echo(",  ");
                                echo $filterBotArr[$i][2];
                            }else{
                            }?></td>
                    <td style="text-align:left; font-size: 14px;"><?php 
                            if(!empty($filterBotArr[$i])){
                                echo $filterBotTube[$i];
                            }else{
                            }?></td>
                    <td style="text-align:left; font-size: 14px;"><?php 
                            if(!empty($drainTopArr[$i])){
                                echo $drainTopArr[$i][0];
                                echo(",  ");
                                echo $drainTopArr[$i][1];
                                echo(",  ");
                                echo $drainTopArr[$i][2];
                            }else{
                            }?></td>
                    <td style="text-align:left; font-size: 14px;"><?php 
                            if(!empty($drainTopArr[$i])){
                                echo $drainTopTube[$i];
                            }else{
                            }?></td>
                    <td style="text-align:left; font-size: 14px;"><?php 
                            if(!empty($drainBotArr[$i])){
                                echo $drainBotArr[$i][0];
                                echo(",  ");
                                echo $drainBotArr[$i][1];
                                echo(",  ");
                                echo $drainBotArr[$i][2];
                            }else{
                            }?></td>
                    <td style="text-align:left; font-size: 14px;"><?php 
                            if(!empty($drainBotArr[$i])){
                                echo $drainBotTube[$i];
                            }else{
                            }?></td>
                </tr>
            <?php endfor;?>
            
        </table>
        
             
</div>
<?php
   $numPages--;
   $from = $to;
   $to += 25;
    }
?>