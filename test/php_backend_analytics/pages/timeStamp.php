<!-- Displays time stamps for specific started job-->

<?php
    include '../Connections/connectionTPM.php';
?>

<?php
    if(isset($_POST['unassign'])){

        $job = $_POST['job'];

        $sql = "UPDATE orders_tbl SET device = '' WHERE job = $job";

        if ($result= $conn -> query($sql)) {
            header("Location: index.php");
        }

        // $sql = "SELECT * FROM orders_tbl WHERE job = $job";

        // if ($result= $conn -> query($sql)) {

        // }

        // $jobNum = mysqli_fetch_array($result);   

        // if($jobNum['has_started'] == '1'){

        //     $sql = "UPDATE orders_tbl SET has_finished = 1 WHERE job = $job";
        
        //     if ($result= $conn -> query($sql)) {
        //         header("Location: index.php");
        //     }
        // } else{
        //     header("Location: index.php");
        // }
        
    }
    $job = $_GET['job'];
    //write query for all orders
    $sql = "SELECT * FROM orders_tbl WHERE job = $job";

    //make query & get result
    if ($result= $conn -> query($sql)) {
	
	}
	
    //fetch resulting rows as an array
    $orderACT = mysqli_fetch_assoc($result);

    $sql = "SELECT * FROM tubes_tbl WHERE job = $job AND insp_check = 1";

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

    if(mysqli_num_rows($result) > 0){

        $tubes = array();

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
        $orderACT = mysqli_fetch_assoc($result);

        return $orderACT['customer'];
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
        
            <h2 class= "millTitle center"><b> Job <?php echo $job; ?></b></h2>
            
            <?php
                if($orderACT['device'] != "")
                {
                ?>
                    <form action="timeStamp.php" method="POST">
                    <input type="hidden" name="job" value= "<?php echo $job?>">
                    <input type="submit" name="unassign" value="Unassign Mill" class="button reassign">
                    </form>
            <?php
                }
            ?>
        
    <div class="tableContainer" id="millDesc">
        
            <div class ="dataTitle">
                    <h3 id="displayTitle"><b> Mill: <?php echo ($orderACT['device'] == '' ? '<div class= "display center"> Unassigned </div>' : '<div class= "display center"> ' .substr($orderACT['device'],6).' </div>'); ?></b></h3>
                    <h3 id="displayTitle"><b>Company: <?php echo '<div class= "display center"> ' .getCustomer($orderACT['cust_id']); ?></b></h3>
                    <h3 id="displayTitle"><b>Quantity: <?php echo '<div class= "display center"> ' .$orderACT['quantity']; ?></b></h3>
                    <h3 id="displayTitle"><b>Tubes Left to Inspect: <?php echo '<div class= "display center"> ' .($orderACT['quantity'] - $currTub); ?></b></h3>
                    <h3 id="displayTitle"><b>Start Time: <?php echo '<div class= "display center"> ' .$orderACT['began']; ?></b></h3>
                    <h3 id="displayTitle"><b>Run Time: <?php  echo '<div class= "display center"> ' .$total_time.' hrs';?></b></h3>
                    <br><br />
            </div>
    
        <div class="outter">
                <div class="inner">
                    <div class="right percent">
                        <b><?php echo $percent ?>%</b>
                    </div>  
                </div>
            </div>
            <br><br />
    </div>
    <div class="dataContain">
        <section class="container grey lighten-4 " id="box">
            <div class="center">
                <style type="text/CSS">
                .outter{
                        height:27px;
                        width: 60%;
                        border: solid 2px black;
                        border-radius: 3px;
                        margin-left: 20%;
                    }

                    .inner{
                        height:24px;
                        width: <?php echo $percent ?>%;
                        border-right: solid 2px black;
                        /* Permalink - use to edit and share this gradient: https://colorzilla.com/gradient-editor/#b4e391+0,61c419+50,b4e391+100;Green+3D */
                        background: #b4e391; /* Old browsers */
                        background: -moz-linear-gradient(top, #b4e391 0%, #61c419 50%, #b4e391 100%); /* FF3.6-15 */
                        background: -webkit-linear-gradient(top, #b4e391 0%,#61c419 50%,#b4e391 100%); /* Chrome10-25,Safari5.1-6 */
                        background: linear-gradient(to bottom, #b4e391 0%,#61c419 50%,#b4e391 100%); /* W3C, IE10+, FF16+, Chrome26+, Opera12+, Safari7+ */
                        filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#b4e391', endColorstr='#b4e391',GradientType=0 ); /* IE6-9 */


                    }
                </style>
                
                <ul class="progList">
                    <li> Setup Start Time <?php echo '<div class= "display"> '.$orderACT['setup_start'].' </div>'; ?></li>
                    <li> Setup End Time <?php echo '<div class= "display"> '.$orderACT['setup_end'].' </div>'; ?></li>
                    <li> Mill Start Time<?php echo '<div class= "display"> '.$tubes[0]['mill_time'].' </div>'; ?></li>
                    <li> Mill End Time<?php echo ($orderACT['has_finished'] == 1 ? '<div class= "display"> '.$tubes[-1]['mill_time'].' </div>' : '<div class= "display"> Job in progress </div>'); ?></li>
                    
                </ul>
            </div>
        </section>
    </div>
    
    
  </body>
</html>