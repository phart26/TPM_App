<!-- Displays the order progress information for the mill that is clicked on from the active orders page -->

<?php
    include '../Connections/connectionTPM.php';
?>

<?php
    if(isset($_POST['reassign'])){

        $job = $_POST['job'];

        $sql = "UPDATE orders_tbl SET device = ' ' WHERE job = $job";
        if ($result= $conn -> query($sql)) {
	
        }

        $sql = "UPDATE live_shop_tbl SET mill = 0 WHERE job = $job";
        if ($result= $conn -> query($sql)) {
            header("Location: upcomingOrders.php");
        }
    }

    $job = $_GET['job'];
    $company = $_GET['company'];
    $totTub = $_GET['quantity'];


    $sql = "SELECT * FROM orders_tbl WHERE job = $job";

    //make query & get result
    if ($result= $conn -> query($sql)) {
	
	}
	
    $job_mill = mysqli_fetch_array($result);


    //write query for all orders
    $sql = "SELECT * FROM tubes_tbl WHERE job = $job";

    //make query & get result
    if ($result= $conn -> query($sql)) {
	
	}
	
    $orderACT = array();
    while($order = mysqli_fetch_array($result)){
        $orderACT[] = $order;
    }

    //getting updated number of tubes
    $currTub = sizeof($orderACT);
    $percent = round(($currTub/$totTub)*100);

    //calculating the number of tubes welded and inspected today
    date_default_timezone_set("US/Central");
    $weld_tod = 0;
    $insp_tod = 0;
    $insp_tot = 0;
    foreach($orderACT as $tube){
        $date_time_mill = $tube['mill_time'];
        $date_time_insp = $tube['insp_time'];
        $new_date_mill = date("Y-m-d",strtotime($date_time_mill));
        $new_date_insp = date("Y-m-d",strtotime($date_time_insp));

        if($new_date_mill == date("Y-m-d")){
            $weld_tod++;
        }
        if($new_date_insp == date("Y-m-d") && $tube['insp_check'] == 1){
            $insp_tod++;
        }
        if($tube['insp_check'] == 1){
            $insp_tot++;
        }
    }


    
    $timeStamp = date("Y-m-d H:i:s");

    
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
        
            <h2 class= "millTitle center"><b> Mill <?php echo substr($job_mill['device'], 6); ?></b></h2>
            
        
    <div class="tableContainer" id="millDesc">
        <div class ="dataTitle">
                <h3 id="displayTitle"><b> Job #: <?php echo '<div class= "display center"> ' .$job; ?></b></h3>
                <h3 id="displayTitle"><b>Company: <?php echo '<div class= "display center"> ' .$company; ?></b></h3>
                <h3 id="displayTitle"><b>Quantity: <?php echo '<div class= "display center"> ' .$totTub; ?></b></h3>
                <h3 id="displayTitle"><b>Tubes Left on Mill: <?php echo '<div class= "display center"> ' .($totTub - $currTub); ?></b></h3>
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
                    <li> Tubes Welded Today at <?php echo $timeStamp; ?><?php echo '<div class= "display"> '.$weld_tod.' </div>'; ?></li>
                    <li> Tubes Inspected Today at <?php echo $timeStamp; ?><?php echo '<div class= "display"> '.$insp_tod.' </div>'; ?></li>
                    <li> Total Tubes Welded <?php echo '<div class= "display"> '.sizeof($orderACT).' </div>'; ?></li>
                    <li> Total Tubes Inspected <?php echo '<div class= "display"> '.$insp_tot.' </div>'; ?></li>
                    
                </ul>
            </div>
        </section>
    </div>
    
    
  </body>
</html>