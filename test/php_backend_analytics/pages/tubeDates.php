<!-- Displays data for tubes per day and per hour-->

<?php
    include '../Connections/connectionTPM.php';
?>

<?php
    
    $job = $_GET['job'];
    $company = $_GET['company'];
    //write query for all orders
    $sql = "SELECT * FROM orders_tbl WHERE job = $job";

    //make query & get result
    if ($result= $conn -> query($sql)) {
	
	}
	
    //fetch resulting rows as an array
    $orderACT = mysqli_fetch_assoc($result);


    $sql = "SELECT * FROM tubes_tbl WHERE job = $job AND insp_check = > 1";

    //make query & get result
    if ($result= $conn -> query($sql)) {
	
	}
	
    $tubes = array();
    while($order = mysqli_fetch_array($result)){
        $tubes[] = $order;
    }

    //getting updated number of tubes
    $currTub = sizeof($tubes);
    $percent = round(($currTub/$orderACT['quantity'])*100);

    
?>

<?php

    //getting total time for the job
    $sql = "SELECT * FROM orders_tbl WHERE job = $job";

    if ($result= $conn -> query($sql)) {

    }

    $time_Job = mysqli_fetch_assoc($result);

    $sql = "SELECT * FROM tubes_tbl WHERE job = $job";

    //make query & get result
    if ($result= $conn -> query($sql)) {

    }

    date_default_timezone_set("US/Central");
    $timeStamp = date("Y-m-d H:i:s");
    $total_time = 0;
    $tubes = array();

    if(mysqli_num_rows($result) > 0){

        

        while($order = mysqli_fetch_array($result)){
            $tubes[] = $order;
        }

            
            //calculating time from mill
            for($tube = 1; $tube < sizeof($tubes); $tube++){

                //checks to see if difference in time between timestamps of two tubes is > 5 hours
                if(round((strtotime($tubes[$tube]['mill_time']) - strtotime($tubes[$tube-1]['mill_time']))/3600) >= 5){

                }else{
                    $total_time += (strtotime($tubes[$tube]['mill_time']) - strtotime($tubes[$tube-1]['mill_time']));
                }
            }

        //calculate time of tubes where the insp time > than mill time if the mill is finished
        if(sizeof($tubes) == $orderACT['quantity']){
            $lastMillTime = $tubes[-1]['mill_time'];

            $sql = "SELECT * FROM tubes_tbl WHERE insp_time > '$lastMillTime'";

            if ($result= $conn -> query($sql)) {
            
            }

            if(mysqli_num_rows($result) > 0){

                $tubesInsp = array();

                while($order = mysqli_fetch_array($result)){
                    $tubesInsp[] = $order;
                }
            
            
                    for($tube = 1; $tube < sizeof($tubesInsp); $tube++){
            
                        //checks to see if difference in time between timestamps of two tubes is > 5 hours
                        if(round((strtotime($tubesInsp[$tube]['insp_time']) - strtotime($tubesInsp[$tube-1]['insp_time']))/3600) >= 5){
            
                        }else{
                            $total_time += (strtotime($tubesInsp[$tube]['insp_time']) - strtotime($tubesInsp[$tube-1]['insp_time']));
                        }
                    }

            }
        }
    }
        
    $total_time = round($total_time/3600);

    if($total_time < 0){
        $total_time = 0;
    }


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
            $totalDayArrInsp[array_search($new_date, $dateArr)] = 1;
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



  


<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
   "http://www.w3.org/TR/html4/loose.dtd">

<html lang="en">
    <head>
        <meta charset="utf-8">
        <meta name="description" content="Table display for out going TPM orders for the next two weeks">
        <meta name="viewport" content="width=device-width, initial-scale = 1.0">
        <meta http-equiv="X-UA-Compatible" content="ie=edge">
        
        <script src = "https://ajax.googleapis.com/ajax/libs/jquery/2.2.0/jquery.min.js"></script>
        <script src = "https://cdn.datatables.net/1.10.12/js/jquery.dataTables.min.js"></script>
        <script src = "https://cdn.datatables.net/1.10.12/js/dataTables.bootstrap.min.js"></script>
        <script src="https://canvasjs.com/assets/script/canvasjs.min.js"></script>
        <script src="https://canvasjs.com/assets/script/jquery-1.11.1.min.js"></script>

        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/materialize/1.0.0/css/materialize.min.css">
        <link rel = "stylesheet" href = "https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css" />
        <link rel = "stylesheet" href = "activeOrders.css">
        <link rel = "stylesheet" href = "hamburger.css">
        <link rel = "stylesheet" href = "https://cdn.datatables.net/1.10.12/css/dataTables.bootstrap.min.css" />
        <link href = "https://fonts.googleapis.com/css?family=Merriweather|Playfair+Display|Raleway:400,700|Vollkorn:700&display=swap" rel="stylesheet">

        <title>Displaying Progress</title>
    </head>
  <body >
    <div class="straightNav center">
            <div class="menu">
                <a href="upcomingOrders.php" >Upcoming Orders</a>
                <a href="../../TPM_Orders/todTomOrders.php" >Shipping Today and Tomorrow</a>
                <!-- <a href="../../TPM_Orders/viewOrders.php" >All Orders</a> -->
                <a href="millTable.php">Mills</a>
                <a href="index.php">All Orders</a>
            </div>
    </div>

        <!-- nav bar -->
        <div class="navBar">
            <div class="nav-toggle">
                <div class="nav-toggle-bar"></div>
            </div>

            <nav id="nav" class="nav">
                <ul>
                <li><h3><a href="upcomingOrders.php" id="two">Upcoming Orders</a></h3></li>
                    <li><h3><a href="../../TPM_Orders/todTomOrders.php" id="two" >Shipping Today</a></h3></li>
                    <!-- <li><h3><a href="../../TPM_Orders/viewOrders.php" id="two">All Orders &nbsp &nbsp</a></h3></li> -->
                    <li><h3><a href="millTable.php" id="two">Mills &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp</a></h3></li>
                    <li><h3><a href="index.php" id="two">All Orders &nbsp&nbsp &nbsp</a></h3></li>
                </ul>
            </nav>
        </div>
        <script>
            (function() {

                let hamburger = {
                    nav: document.querySelector('#nav'),
                    navToggle: document.querySelector('.nav-toggle'),

                    initialize() {
                        this.navToggle.addEventListener('click',
                    () => { this.toggle(); });
                    },

                    toggle() {
                        this.navToggle.classList.toggle('expanded');
                        this.nav.classList.toggle('expanded');
                    },
                };

                hamburger.initialize();

            }());
        </script>
        
            <h2 class= "millTitle center" id="tubeJob"><b> Job <?php echo $job; ?></b></h2>
        
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
    </div>
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
    
    <form action="tubeDates.php?job=<?php echo $job; ?>" method="POST" class="center">
        <label for="tubeDate" style="font-size:45px; padding-top:150px;" class="center">Date For Tubes per Hour</label>
        <input type="date" class="form-control center" style="font-size:30px; padding:20px;" name="tubeDate" placeholder="0000-00-00">
        <input type="submit" class="btn btn-primary btn-md center" name="submit" value="Submit" style="margin-bottom:100px;">
    </form>

    <h3 class= "center" id="tubeJobTitle"><b><?php echo $_POST['tubeDate']; ?></b></h3>
    <h4 class= "center" id="tubeJobTitle" style="font-size: 30px;"> Tubes per Hour Mill: <b><?php echo ($hoursWorkingMill == 0 ? 0 :number_format($totalDayArr[array_search($_POST['tubeDate'], $dateArr)]/$hoursWorkingMill, 2, '.', '')); ?></b></h4>
    <h4 class= "center" id="tubeJobTitle" style="font-size: 30px;"> Tubes per Hour Insp: <b><?php echo ($hoursWorkingInsp == 0 ? 0 :number_format($totalDayArrInsp[array_search($_POST['tubeDate'], $dateArr)]/$hoursWorkingInsp, 2, '.', '')); ?></b></h4>
    
    <div class="tubePerHour">
            <table class="table table-striped table-bordered">
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
                                <td style ="vertical-align: middle;"><?php echo ($millHourArr[$count] > 0 ? '<h3><b>'.$millHourArr[$count].'</b></h3>': $millHourArr[$count]);?></td>
                                <td style ="vertical-align: middle;"><?php echo ($inspHourArr[$count] > 0 ? '<h3><b>'.$inspHourArr[$count].'</b></h3>': $inspHourArr[$count]);?></td>
                            </tr> 
                    <?php }$count++;endforeach; ?>
        </div>         
        <?php
            if(isset($_POST['submit'])){
                echo '<style type="text/css">
                        .tubePerHour {
                            visibility: visible;
                        }
                        
                        
                        
                        #tubeJobTitle {
                            visibility: visible;
                        }</style>';
            }
        ?>
    
  </body>
</html>

