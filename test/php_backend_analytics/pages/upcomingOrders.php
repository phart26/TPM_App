
<!-- Displays all non-active orders-->

<?php
    include '../Connections/connectionTPM.php';
?>

<?php

    //write query for all orders
    $sql = 'SELECT * FROM orders_tbl WHERE has_started = 0 AND has_finished = 0 ORDER BY Ship_Date';

    //make query & get result
    if ($result= $conn -> query($sql)) {
	
	}
	

    $ordersACT = array();
    //fetch resulting rows as an array
    while($order = mysqli_fetch_array($result)){
        $ordersACT[] = $order;
    }

?>

<!-- updates database after mill selection -->
<?php

    if(isset($_POST['millNum'])){
        $mill_num = 'mill_0'.$_POST['millSelect'];
        //write query for all orders
        $sql = "UPDATE orders_tbl SET device = '$mill_num', has_finished = 0 WHERE job = '".$_POST['jobNumber']."'";

        //make query & get result
        if ($result= $conn -> query($sql)) {
            header("Location: upcomingOrders.php");
        
        }
    }

    if(isset($_POST['startMillNum'])){
        date_default_timezone_set("US/Central");
        $timeStamp = date("m-d H:i");
        $mill_num = 'mill_0'.$_POST['startMillSelect'];
        //write query for all orders
        $sql = "UPDATE orders_tbl SET device = '$mill_num' WHERE job = '".$_POST['jobNumber']."'";

        //make query & get result
        if ($result= $conn -> query($sql)) {
            
        }

        if($_POST['paused'] == 1){
            $sql = " SELECT * FROM orders_tbl WHERE job = '".$_POST['jobNumber']."'"; 

            //make query & get result
            if ($result= $conn -> query($sql)) {
                $jobRow = mysqli_fetch_assoc($result);
            
                $sql = " UPDATE live_shop_tbl SET mill = '".$jobRow['Mill']."' WHERE job = '".$_POST['jobNumber']."'";

                if ($result= $conn -> query($sql)) {
                        
                }

                $sql = " UPDATE orders_tbl SET paused = 0 WHERE job = '".$_POST['jobNumber']."'";

                if ($result= $conn -> query($sql)) {
                    header("Location: index.php");
                }
            }

            
            

        }else{
            $sql = "INSERT INTO live_shop_tbl(job, mill) SELECT job, mill FROM orders_tbl WHERE job = '".$_POST['jobNumber']."'"; 

            //make query & get result
            if ($result= $conn -> query($sql)) {

            }

            $sql = "UPDATE live_shop_tbl SET time_weld = '$timeStamp' , time_insp = '$timeStamp' WHERE job = '".$_POST['jobNumber']."'" ; 

            //make query & get result
            if ($result= $conn -> query($sql)) {
                header("Location: index.php");
            }
        }
    }

    // selecting active mills

    $sql = 'SELECT * FROM orders_tbl WHERE device != ""  AND has_started = 1 ORDER BY Ship_Date';

        //make query & get result
        if ($result= $conn -> query($sql)) {
                
        }
                

        $actOrders = array();
        //fetch resulting rows as an array
        while($order = mysqli_fetch_array($result)){
             $actOrders[] = $order;
        }

        $pendingMills = array();
        foreach($actOrders as $order){
            if($order['device'] != ""){
                array_push($pendingMills, $order['device']);
            }
        }
?>

<?php
    // find jobs that could potentially be paused
    $sql = "SELECT * FROM orders_tbl WHERE has_started = 1 AND has_finished = 1 AND job > 7820";

    if ($result= $conn -> query($sql)) {
	
	}
	
    $Jobs = array();
    $pausedJobs = array();
    while($order = mysqli_fetch_array($result)){
        $Jobs[] = $order;
    }
    
    // run through each job and check if tubes are finished, if not, add to paused list
    foreach($Jobs as $job){
        $sql = "SELECT * FROM tubes_tbl WHERE job = '".$job['job']."'";
        //make query & get result
        if ($result= $conn -> query($sql)) {
        
        }
        $tubes = array();
        while($order = mysqli_fetch_array($result)){
            $tubes[] = $order;
        }
        
        if(sizeof($tubes) < $job['quantity']){
            array_push($pausedJobs, $job);
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

        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/materialize/1.0.0/css/materialize.min.css">
        <link rel = "stylesheet" href = "https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css" />
        <link rel = "stylesheet" href = "activeOrders.css">
        <link rel = "stylesheet" href = "hamburger.css">
        <link rel = "stylesheet" href = "https://cdn.datatables.net/1.10.12/css/dataTables.bootstrap.min.css" />
        <link href = "https://fonts.googleapis.com/css?family=Merriweather|Playfair+Display|Raleway:400,700|Vollkorn:700&display=swap" rel="stylesheet">

        <title>Upcoming Orders</title>
    </head>
  <body >

    <!-- what happens when the assign and start buttons are pressed -->
        <?php


            if(isset($_POST['assign'])){
                echo '<style type="text/css">
                #millForm {
                    display: block;
                }

                #upOrders{
                    opacity: .1;
                }
                </style>';
            }

            if(isset($_POST['start'])){
                

                echo '<style type="text/css">
                #startMillForm {
                    display: block;
                }

                #upOrders{
                    opacity: .1;
                }
                </style>';

            }
        ?>
        <script>
            function hideStart(){
                document.getElementById("startMillForm").style.display = "none";
                document.getElementById("upOrders").style.opacity = 1;
            }

            function hideAssign(){
                document.getElementById("MillForm").style.display = "none";
                document.getElementById("upOrders").style.opacity = 1;
            }
        </script>

    <div class="straightNav center">
        <div class="menu">
            <a href="index.php" >All Orders</a>
            <a href="../../TPM_Orders/todTomOrders.php">Shipping Today and Tomorrow</a>
            <!-- <a href="../../TPM_Orders/viewOrders.php">All Orders</a> -->
            <a href="millTable.php">Mills</a>
            <a href="macAdd.php">Devices</a>
        </div>
    </div>

   <!-- nav bar -->
   <div class="navBar">
        <div class="nav-toggle">
            <div class="nav-toggle-bar"></div>
        </div>

        <nav id="nav" class="nav">
            <ul>
                <li><h3><a href="index.php" id="two">All Orders &nbsp &nbsp</a></h3></li>
                <li><h3><a href="../../TPM_Orders/todTomOrders.php" id="two" >Shipping Today</a></h3></li>
                <!-- <li><h3><a href="../../TPM_Orders/viewOrders.php" id="two">All Orders &nbsp &nbsp</a></h3></li> -->
                <li><h3><a href="millTable.php" id="two">Mills &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp</a></h3></li>
            </ul>
        </nav>
    </div>

    <!-- hamburger icon scripts -->
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

    <div class="tableContainer">
        <div class ="title">
                <h2 class="OOTitle"><b>Upcoming Orders</b></h2>
        </div>

        <!-- form set up -->
            <form action="upcomingOrders.php" method= "POST" class="center" id="millForm">
            <input type="hidden" name="jobNumber" value="<?php echo $_POST['jobNum'] ?>">
                <label>Mill</label>
                <input list="Mills" name="millSelect">
                <datalist id="Mills">
                    <option value="1">
                    <option value="2">
                    <option value="3">
                    <option value="4">
                    <option value="5">
                </datalist>
                <input type="submit" name="millNum" value="Assign" class="button">
                <button onclick= "hideAssign()" class="button">Back</button>
            </form>

            <form action="upcomingOrders.php" method= "POST" class="center" id="startMillForm">
            <input type="hidden" name="jobNumber" value="<?php echo $_POST['jobNum'] ?>">
            <input type="hidden" name="paused" value="<?php echo $_POST['paused'] ?>">
                <label>Mill</label>
                <input list="startMills" name="startMillSelect">
                <datalist id="startMills">
                    <?php
                        
                        if(in_array(1, $pendingMills)){
                            
                        }else{
                            echo '<option value="1">';
                        }

                        if(in_array(2, $pendingMills)){
                            
                        }else{
                            echo '<option value="2">';
                        }

                        if(in_array(3, $pendingMills)){
                            
                        }else{
                            echo '<option value="3">';
                        }

                        if(in_array(4, $pendingMills)){
                            
                        }else{
                            echo '<option value="4">';
                        }

                        if(in_array(5, $pendingMills)){
                            
                        }else{
                            echo '<option value="5">';
                        }

                    ?>
                </datalist>
                <input type="submit" name="startMillNum" onclick= "return confirm('<?php echo 'Are you sure you would like to start job '.$_POST['jobNum']?>')" value="Start" class="button">
                <button onclick= "hideStart()" class="button">Back</button>
            </form>
        
        <!-- table setup -->

        <div class="outTable">
            <table id= "upOrders" class="table table-striped table-bordered">
                <thead>
                    <tr>
                        <td style ="vertical-align: middle;">Customer</td>
                        <td style ="vertical-align: middle;">Ship Date</td>
                        <td style ="vertical-align: middle;">Part #</td>
                        <td style ="vertical-align: middle;">Job #</td>
                        <td style ="vertical-align: middle;">QTY</td>
                        <td style ="vertical-align: middle;">Description</td>
                        <td style ="vertical-align: middle;">Mill</td>
                    </tr>
                </thead>
                <tbody>
                    <?php foreach($ordersACT as $order): ?>
                            <tr>
                                <td style ="vertical-align: middle;"><?php echo htmlspecialchars(getCustomer($order['cust_id'])); ?></td>
                                <td style ="vertical-align: middle;" class= "shipDate"><?php echo htmlspecialchars($order['ship_date']); ?></td>
                                <td style ="vertical-align: middle;"><?php echo htmlspecialchars($order['part']); ?></td>
                                <td style ="vertical-align: middle;"><?php echo htmlspecialchars($order['job']); ?></td>
                                <td style ="vertical-align: middle;"><?php echo htmlspecialchars($order['quantity']); ?></td>
                                <td id="desc" style ="vertical-align: middle;"><?php echo htmlspecialchars(getDesc($order['part'])); ?></td>
                                <td style ="vertical-align: middle;" id="millBtn">
                                    <?php
                                        if($order['device'] != ""){
                                            echo substr($order['device'],6);
                                            echo "<br><br />";

                                        }
                                        if(count($pendingMills) < 5){
                                            echo '<style type="text/css">
                                                 input[name="start"]{
                                                    display: inline;
                                                }
                                                </style>';
                                        }

                                        /*if($order['paused'] == 1){
                                            echo 'On hold';
                                        }*/
                                    ?>
                                    <form action="upcomingOrders.php" method="POST" id= "assignForm">
                                        <input type="hidden" name="jobNum" value="<?php echo $order['job'] ?>">
                                        <input type="submit" name="assign" value="Assign" class="button">
                                    </form>

                                    <form action="upcomingOrders.php" method="POST" id= "form">
                                        <input type="hidden" name="jobNum" value="<?php echo $order['job'] ?>">
                                        <input type="hidden" name="paused" value="<?php echo $order['paused'] ?>">
                                        <input type="submit" name="start" value="Start" class="button">
                                    </form>
                                        
                                        
                                    
                                </td>
                            </tr> 
                    <?php endforeach; ?>
                    

                    <!-- getting customer and description functions -->

                    <?php

                            function getCustomer($cust_id){
                                include '../Connections/connectionTPM.php';
                                $sql = "SELECT * FROM cust_tbl WHERE cust_id = '".$cust_id."'";

                                //make query & get result
                                if ($result= $conn -> query($sql)) {
                                
                                }
                                
                                //fetch resulting rows as an array
                                $orderACT = mysqli_fetch_assoc($result);

                                return $orderACT['customer'];
                            }

                            function getDesc($part){
                                include '../Connections/connectionTPM.php';
                                $sql = "SELECT * FROM part_tbl WHERE part = '".$part."'";

                                //make query & get result
                                if ($result= $conn -> query($sql)) {
                                
                                }
                                
                                //fetch resulting rows as an array
                                $orderACT = mysqli_fetch_assoc($result);

                                return $orderACT['description'];
                            }
                    ?>
                    


                </tbody>
            </table>
        </div>
    </div>

    <div class="tableContainer">
        <div class ="title">
            <h2 class="OOTitle"><b>Paused Orders</b></h2>
        </div>

        <div class="outTable">
            <table class="table table-striped table-bordered">
                <thead>
                    <tr>
                        <td style ="vertical-align: middle;">Customer</td>
                        <td style ="vertical-align: middle;">Ship Date</td>
                        <td style ="vertical-align: middle;">Part #</td>
                        <td style ="vertical-align: middle;">Job #</td>
                        <td style ="vertical-align: middle;">QTY</td>
                        <td style ="vertical-align: middle;">Description</td>
                        <td style ="vertical-align: middle;">Mill</td>
                    </tr>
                </thead>
                <tbody>
                    <?php foreach($pausedJobs as $order): ?>
                            <tr>
                                <td style ="vertical-align: middle;"><?php echo htmlspecialchars(getCustomer($order['cust_id'])); ?></td>
                                <td style ="vertical-align: middle;" class= "shipDate"><?php echo htmlspecialchars($order['ship_date']); ?></td>
                                <td style ="vertical-align: middle;"><?php echo htmlspecialchars($order['part']); ?></td>
                                <td style ="vertical-align: middle;"><?php echo htmlspecialchars($order['job']); ?></td>
                                <td style ="vertical-align: middle;"><?php echo htmlspecialchars($order['quantity']); ?></td>
                                <td style ="vertical-align: middle;" id="desc1"><?php echo htmlspecialchars(getDesc($order['part'])); ?></td>
                                <td style ="vertical-align: middle;" id = "millBtn1">
                                    <?php
                                        if($order['device'] != ""){
                                            echo substr($order['device'],6);
                                            echo "<br><br />";

                                        }
                                        if(count($pendingMills) < 5){
                                            echo '<style type="text/css">
                                                 input[name="start"]{
                                                    display: inline;
                                                }
                                                </style>';
                                        }

                                        /*if($order['paused'] == 1){
                                            echo 'On hold';
                                        }*/
                                    ?>
                                    <form action="upcomingOrders.php" method="POST" id= "assignForm1">
                                        <input type="hidden" name="jobNum" value="<?php echo $order['job'] ?>">
                                        <input type="submit" name="assign" value="Assign" class="button">
                                    </form>

                                    <form action="upcomingOrders.php" method="POST" id= "form1">
                                        <input type="hidden" name="jobNum" value="<?php echo $order['job'] ?>">
                                        <input type="hidden" name="paused" value="<?php echo $order['paused'] ?>">
                                        <input type="submit" name="start" value="Start" class="button">
                                    </form>
                                        
                                        
                                    
                                </td>
                            </tr> 
                    <?php endforeach; ?>

                </tbody>
            </table>
        </div>
    </div>

    
    
  </body>
</html>