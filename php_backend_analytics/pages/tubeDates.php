<!-- Displays data for tubes per day and per hour-->

<?php
    $header_tilte = "Displaying Progress";
    include '../Connections/connectionTPM.php';
    include 'header.php'; 
?>

<?php
    
    $job = !empty($_GET['job']) ? $_GET['job'] : '';
    $company = !empty($_GET['company']) ? $_GET['company'] : '';

    if(empty($job)){
        header('Location: index.php'); exit;
    }
    //write query for all orders
    $sql = "SELECT * FROM orders_tbl WHERE job = $job";

    $orderACT = $db->query($sql)->fetchArray();


    $sql = "SELECT COUNT(*) AS cnt FROM tubes_tbl WHERE job = $job AND insp_check >= 1 GROUP BY job";
    
    $currTub = $db->query($sql)->fetchArray();

    //getting updated number of tubes
    $percent = round(($currTub['cnt']/$orderACT['quantity'])*100);    

    // $sql = "SELECT COUNT(*) as cnt FROM tubes_tbl WHERE job = $job GROUP BY job";
    $sql = "SELECT * FROM tubes_tbl WHERE job = $job ORDER BY mill_time ASC";
    $tubes = $db->query($sql)->fetchAll();

    $total_time = 0;

    if(count($tubes) > 1){

        //calculating time from mill
        foreach($tubes as $key => $tube){

            $lNum = $key <= 0 ? 0 : $key-1;
            $timeDiff = strtotime($tubes[$key]['mill_time']) - strtotime($tubes[$lNum]['mill_time']);

            if((round($timeDiff)/3600) < 5){
                $total_time += $timeDiff;
            }
        }            

        //calculate time of tubes where the insp time > than mill time if the mill is finished
        if(count($tubes) == $orderACT['quantity']){

            $lastMillTime = $tubes[count($tubes)-1]['mill_time'];

            $sql = "SELECT * FROM tubes_tbl WHERE job = $job AND insp_time >= '$lastMillTime'";

            $tubes = $db->query($sql)->fetchAll();

            foreach($tubes as $key => $tube){
                $lNum = $key <= 0 ? 0 : $key-1;
                $timeDiff = strtotime($tubes[$key]['insp_time']) - strtotime($tubes[$lNum]['insp_time']);

                //checks to see if difference in time between timestamps of two tubes is > 5 hours
                if( ($timeDiff < 5*3600) && ($timeDiff > 0) ){
                    $total_time += $timeDiff;
                }
            }

        }
    }
        
    $total_time = round($total_time/3600);

?>
<?php
    function getCustomer($cust_id){
        include '../Connections/connectionTPM.php';
        $sql = "SELECT * FROM cust_tbl WHERE cust_id = '".$cust_id."'";

        //make query & get result
        if ($result= $conn -> query($sql)) {
                                
        }
                                
        //fetch resulting rows as an array
        $ordersACT = mysqli_fetch_assoc($result);

        return $ordersACT['customer'];
    }
?>

<!-- getting total tubes mill and insp for each day -->
<?php
 $totalTubeData = array();
 $hourTotalTableArr = array();
 $hourArr = array("06:00-07:00","07:00-08:00", "08:00-09:00", "09:00-10:00", "10:00-11:00", "11:00-12:00", "12:00-13:00", "13:00-14:00", "14:00-15:00", "15:00-16:00", "16:00-17:00", "17:00-18:00", "18:00-19:00", "19:00-20:00", "20:00-21:00", "21:00-22:00");
 $sql = "SELECT  id, mill_time FROM tubes_tbl WHERE job = $job";

    //make query & get result
    if ($result= $conn -> query($sql)) {
	
    }
    $millTubes = array();
    while($order = mysqli_fetch_array($result)){
        $millTubes[] = $order;
    }
    $dateArr = array();
    $totalDayArr = array();

    foreach($millTubes as $millTube){
        $date_time = $millTube['mill_time'];
        $new_date = date("Y-m-d",strtotime($date_time));
        if(!(in_array($new_date, $dateArr))){
            array_push($totalDayArr, 1);
            array_push($dateArr, $new_date);   
        }else{

            $totalDayArr[array_search($new_date, $dateArr)]++;
        }
    }

    $dayTableArr = array();
    for($i = 0; $i < sizeof($dateArr); $i++){
        array_push($dayTableArr, array("label"=>$dateArr[$i], "y" => $totalDayArr[$i], "color"=>'#8B0000'));
    }
    
?>

<!-- getting total tubes mill for each day -->
<?php
 $sql = "SELECT insp_time FROM tubes_tbl WHERE job = $job";

    //make query & get result
    if ($result= $conn -> query($sql)) {
	
    }
    $InspTubes = array();
    while($order = mysqli_fetch_array($result)){
        $InspTubes[] = $order;
    }

    $totalDayArrInsp = array_fill(0,sizeof($dateArr),0);
    

    foreach($InspTubes as $InspTube){
        $date_time = $InspTube['insp_time'];
        $new_date = date("Y-m-d",strtotime($date_time));
        if(!(in_array($new_date, $dateArr))){
            array_push($totalDayArrInsp, 1);
            array_push($dateArr, $new_date);
        }else{

            $totalDayArrInsp[array_search($new_date, $dateArr)]++;
        }
    }

    $dayTableArrInsp = array();
    for($i = 0; $i < sizeof($dateArr); $i++){
        array_push($dayTableArrInsp, array("label"=>$dateArr[$i], "y" => $totalDayArrInsp[$i], "color"=>'#000080'));
    }

    
?>

<!-- getting total tubes for each hour/day -->
<?php


    function getTubesHourMill($day, $job){
        include '../Connections/connectionTPM.php';

        $dayStart = date("Y-m-d H:i:s", strtotime($day));
        $dayEnd = date("Y-m-d H:i:s", strtotime($day .' +1 day'));

        $sql = "SELECT * FROM tubes_tbl WHERE job = $job AND mill_time > '$dayStart' AND mill_time < '$dayEnd'";

        //make query & get result
        if ($result= $conn -> query($sql)) {
        
        }
        $millTubesHour = array();
        while($order = mysqli_fetch_assoc($result)){
            $millTubesHour[] = $order;
        }


        $totalHourArrMill = array(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0);

        foreach($millTubesHour as $millTube){
            $date_time = $millTube['mill_time'];
            $new_date = date("H-i-s",strtotime($date_time));
            if(($new_date >= "06:00:00") && ($new_date < "07:00:00")){
                    $totalHourArrMill[0]++;
            }
            if(($new_date >= "07:00:00") && ($new_date < "08:00:00")){
                    $totalHourArrMill[1]++;
            }
            if(($new_date >= "08:00:00") && ($new_date < "09:00:00")){
                    $totalHourArrMill[2]++;
            }
            if(($new_date >= "09:00:00") && ($new_date < "10:00:00")){
                    $totalHourArrMill[3]++;
            }
            if(($new_date >= "10:00:00") && ($new_date < "11:00:00")){
                    $totalHourArrMill[4]++;
            }
            if(($new_date >= "11:00:00") && ($new_date < "12:00:00")){
                    $totalHourArrMill[5]++;
            }
            if(($new_date >= "12:00:00") && ($new_date < "13:00:00")){
                    $totalHourArrMill[6]++;
            }
            if(($new_date >= "13:00:00") && ($new_date < "14:00:00")){
                    $totalHourArrMill[7]++;
            }
            if(($new_date >= "14:00:00") && ($new_date < "15:00:00")){
                    $totalHourArrMill[8]++;
            }
            if(($new_date >= "15:00:00") && ($new_date < "16:00:00")){
                    $totalHourArrMill[9]++;
            }
            if(($new_date >= "16:00:00") && ($new_date < "17:00:00")){
                    $totalHourArrMill[10]++;
            }
            if(($new_date >= "17:00:00") && ($new_date < "18:00:00")){
                    $totalHourArrMill[11]++;
            }
            if(($new_date >= "18:00:00") && ($new_date < "19:00:00")){
                    $totalHourArrMill[12]++;
            }
            if(($new_date >= "19:00:00") && ($new_date < "20:00:00")){
                    $totalHourArrMill[13]++;
            }   
            if(($new_date >= "20:00:00") && ($new_date < "21:00:00")){
                    $totalHourArrMill[14]++;
            }
            if(($new_date >= "21:00:00") && ($new_date < "22:00:00")){
                    $totalHourArrMill[15]++;
            }
        }

        return $totalHourArrMill;
    }

    function getTubesHourInsp($day, $job){
        include '../Connections/connectionTPM.php';

        $dayStart = date("Y-m-d H:i:s", strtotime($day));
        $dayEnd = date("Y-m-d H:i:s", strtotime($day .' +1 day'));

        $sql = "SELECT * FROM tubes_tbl WHERE job = $job AND insp_time > '$dayStart' AND insp_time < '$dayEnd'";

        //make query & get result
        if ($result= $conn -> query($sql)) {
        
        }
        $inspTubesHour = array();
        while($order = mysqli_fetch_assoc($result)){
            $inspTubesHour[] = $order;
        }


        
        $totalHourArrInsp = array(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0);

        foreach($inspTubesHour as $inspTube){
            $date_time = $inspTube['insp_time'];
            $new_date = date("H-i-s",strtotime($date_time));
            if(($new_date >= "06:00:00") && ($new_date < "07:00:00")){
                    $totalHourArrInsp[0]++;
            }
            if(($new_date >= "07:00:00") && ($new_date < "08:00:00")){
                    $totalHourArrInsp[1]++;
            }
            if(($new_date >= "08:00:00") && ($new_date < "09:00:00")){
                    $totalHourArrInsp[2]++;
            }
            if(($new_date >= "09:00:00") && ($new_date < "10:00:00")){
                    $totalHourArrInsp[3]++;
            }
            if(($new_date >= "10:00:00") && ($new_date < "11:00:00")){
                    $totalHourArrInsp[4]++;
            }
            if(($new_date >= "11:00:00") && ($new_date < "12:00:00")){
                    $totalHourArrInsp[5]++;
            }
            if(($new_date >= "12:00:00") && ($new_date < "13:00:00")){
                    $totalHourArrInsp[6]++;
            }
            if(($new_date >= "13:00:00") && ($new_date < "14:00:00")){
                    $totalHourArrInsp[7]++;
            }
            if(($new_date >= "14:00:00") && ($new_date < "15:00:00")){
                    $totalHourArrInsp[8]++;
            }
            if(($new_date >= "15:00:00") && ($new_date < "16:00:00")){
                    $totalHourArrInsp[9]++;
            }
            if(($new_date >= "16:00:00") && ($new_date < "17:00:00")){
                    $totalHourArrInsp[10]++;
            }
            if(($new_date >= "17:00:00") && ($new_date < "18:00:00")){
                    $totalHourArrInsp[11]++;
            }
            if(($new_date >= "18:00:00") && ($new_date < "19:00:00")){
                    $totalHourArrInsp[12]++;
            }
            if(($new_date >= "19:00:00") && ($new_date < "20:00:00")){
                    $totalHourArrInsp[13]++;
            }   
            if(($new_date >= "20:00:00") && ($new_date < "21:00:00")){
                    $totalHourArrInsp[14]++;
            }
            if(($new_date >= "21:00:00") && ($new_date < "22:00:00")){
                    $totalHourArrInsp[15]++;
            }
        }
        
        return $totalHourArrInsp;
    }


 
?>

<?php
    $millHourArr = array();
    $inspHourArr = array();
    $count = 0;
    $hoursWorkingMill = 0;
    $hoursWorkingInsp = 0;
    if(isset($_POST['submit'])){
        $millHourArr = getTubesHourMill($_POST['tubeDate'], $job);
        $inspHourArr = getTubesHourInsp($_POST['tubeDate'], $job);

        foreach($millHourArr as $hour){
            if($hour > 0){
                $hoursWorkingMill++;
            }
        }

        foreach($inspHourArr as $hour){
            if($hour > 0){
                $hoursWorkingInsp++;
            }
        }

    }
?>
<script src="https://canvasjs.com/assets/script/canvasjs.min.js"></script>
<div class="container-fluid px-4 pb-4">
    <div class="card mt-4">
        <div class="card-header">
            <h3 class="text-center py-0"><b> Job <?php echo $job; ?></b></h3>
        </div>
        <div class="card-body">

            <div class="row px-4 mb-4">
                <div class="col-md-3 col-xs-hidden"></div>
                <div class="col-md-6 col-xs-12">
                    <div class="row">
                        <div class="col-6 text-left px-0">
                            <h4 class="font-weight-bold text-secondary">Mill: <label class="text-info"><?= !empty($orderACT['device']) ? substr($orderACT['device'],6) : 'Unassigned' ?></label></h4>                                
                        </div>
                        <div class="col-6 text-left px-0">                            
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-6 text-left px-0">
                        <h4 class="font-weight-bold text-secondary">Start Time: <label class="text-info font-weight-bold"><?= !empty($orderACT['began']) ? $orderACT['began'] : '0000-00-00';?></label></h4>
                        </div>
                        <div class="col-6 text-left px-0">
                            <h4 class="font-weight-bold text-secondary">Completed Time: <label class="text-info font-weight-bold"><?= !empty($orderACT['has_finished']) ? $orderACT['finished'] : 'Still In Progress';?></label></h4>                                
                        </div>
                    </div>
                    
                    <div class="row">
                        <div class="col-6 text-left px-0">
                        <h4 class="font-weight-bold text-secondary">Quantity: <label class="text-info font-weight-bold"><?= !empty($orderACT['quantity']) ? $orderACT['quantity'] : '0';?></label></h4>
                        </div>
                        <div class="col-6 text-left px-0">
                            <h4 class="font-weight-bold text-secondary">Run Time: <label class="text-info font-weight-bold"><?= $total_time;?> hrs</label></h4>
                        </div>
                    </div>

                </div>
            </div>
        </div>
    </div>
</div>


        
    <!-- <h2 class= "millTitle center" id="tubeJob"><b> Job <?php echo $job; ?></b></h2>        
    <div class="tableContainer" id="millDesc">
        
            <div class ="dataTitle">
                    <h3 id="displayTitle"><b> Mill: <?php echo ($orderACT['device'] == '' ? '<div class= "display center"> Unassigned </div>' : '<div class= "display center"> ' .substr($orderACT['device'],6).' </div>'); ?></b></h3>
                    <h3 id="displayTitle"><b></b></h3>
                    <h3 id="displayTitle"><b>Start Time: <?php echo '<div class= "display center"> ' .$orderACT['began']; ?></b></h3>
                    <h3 id="displayTitle"><b>Completed at: <?php echo ($orderACT['has_finished'] == 1 ? '<div class= "display center"> ' .$orderACT['finished'] : '<div class= "display center"> Still In Progress'); ?></b></h3>
                    <h3 id="displayTitle"><b>Quantity: <?php echo '<div class= "display center"> ' .$orderACT['quantity']; ?></b></h3>
                    <h3 id="displayTitle"><b>Run Time: <?php  echo '<div class= "display center"> ' .$total_time.' hrs';?></b></h3>
                    <br><br />
            </div>
    </div> -->
    <script>
        window.onload = function () {
 
            var categories = [];
                var totTubes = {
                        "Total Tubes": [{
                        name: "Total Tubes Mill",
                        type: "column",
                        color: '#8B0000',
                        showInLegend: true,
                        dataPoints: <?php echo json_encode($dayTableArr, JSON_NUMERIC_CHECK); ?>
                        },{
                        name: "Total Tubes Insp",
                        type: "column",
                        color: '#000080',
                        showInLegend: true,
                        dataPoints: <?php echo json_encode($dayTableArrInsp, JSON_NUMERIC_CHECK); ?>
                        }]
                };
                

                var chartOptions = {
                animationEnabled: true,
                theme: "light2",
                title: {
                    text: "Total Tubes"
                },
                subtitles:[{
                }],
                data: [
                    
                ]
                };

                var chart = new CanvasJS.Chart("chartContainer", chartOptions);
                chart.options.data = totTubes['Total Tubes'];
                chart.render();
            };
    </script>

    <div id="chartContainer" style="height: 500px; width: 90%; padding:5%;"></div>
    <button class="btn invisible" id="backButton">&lt; Back</button> 
    
    <form action="tubeDates.php?job=<?php echo $job; ?>" method="POST" class="col-3 mx-auto center mb-4 pb-4">
        <label for="tubeDate" style="font-size:30px; padding-top:150px;" class="center">Date For Tubes per Hour</label>
        <input type="date" class="form-control center" style="font-size:30px; padding:20px;" name="tubeDate" placeholder="0000-00-00">
        <input type="submit" class="btn btn-primary btn-md center mt-2 mb-0" name="submit" value="Submit" style="margin-bottom:100px;">
    </form>
<?php if(isset($_POST['tubeDate'])):?>
    <h3 class="center tubeJobTitle"><b><?php echo $_POST['tubeDate']; ?></b></h3>
    <h4 class="center tubeJobTitle" style="font-size: 30px;"> Tubes per Hour Mill: <b><?php echo ($hoursWorkingMill == 0 ? 0 :number_format($totalDayArr[array_search($_POST['tubeDate'], $dateArr)]/$hoursWorkingMill, 2, '.', '')); ?></b></h4>
    <h4 class="center tubeJobTitle" style="font-size: 30px;"> Tubes per Hour Insp: <b><?php echo ($hoursWorkingInsp == 0 ? 0 :number_format($totalDayArrInsp[array_search($_POST['tubeDate'], $dateArr)]/$hoursWorkingInsp, 2, '.', '')); ?></b></h4>    
    <div class="tubePerHour col-10 mx-auto mb-4">
        <table class="table table-striped table-bordered" id="tubeperHour">
            <thead>
                <tr>
                    <td style ="vertical-align: middle;" >Hour</td>
                    <td style ="vertical-align: middle;">Number of Tubes Mill</td>
                    <td style ="vertical-align: middle;">Number of Tubes Insp</td>
                </tr>
                </tr>
            </thead>
            <tbody>
                <?php foreach($hourArr as $order):
                if(($millHourArr[$count] > 0) || ($inspHourArr[$count] > 0)){
                        ?>
                        <tr>
                            <td style ="vertical-align: middle;"><?php echo $hourArr[$count+1];?></td>
                            <td style ="vertical-align: middle;"><?php echo ($millHourArr[$count] > 0 ? '<h6><b>'.$millHourArr[$count].'</b></h6>': $millHourArr[$count]);?></td>
                            <td style ="vertical-align: middle;"><?php echo ($inspHourArr[$count] > 0 ? '<h6><b>'.$inspHourArr[$count].'</b></h6>': $inspHourArr[$count]);?></td>
                        </tr> 
                <?php }$count++;endforeach; ?>
            </tbody>
        </table>
    </div>             
<?php endif;?>
    <?php
        if(isset($_POST['submit'])){
            echo '<style type="text/css">
                    .tubePerHour, .tubeJobTitle {
                        visibility: visible;
                    }
                </style>';
        }
    ?>
<script type="text/javascript">
  $(function () {    
    $('#tubeperHour').DataTable( {        
        responsive: true,
        // pageLength : 25,
    } );
    
  });
</script>  
<style>
    tbody {
        font-size: 12pt;
    }
    .dataTables_length label, .dataTables_filter label{
        font-size: 12pt;
    }
</style>
    </body>
</html>

