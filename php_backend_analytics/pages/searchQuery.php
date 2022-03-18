<!-- Active TPM query for past orders-->

<?php
    include '../Connections/connectionTPM.php';
?>

<?php
    $ordersACT = array();
    if(isset($_POST['Search'])){
        
        if($_POST['jobNum']!= ""){
            $sql = 'SELECT * FROM orders_tbl WHERE job = "'.$_POST["jobNum"].'"';

            //make query & get result
            if ($result= $conn -> query($sql)) {
            
            }
            while($order = mysqli_fetch_array($result)){
                $ordersACT[] = $order;
            }
        }elseif($_POST['partNum']!= ""){

            $sql = 'SELECT * FROM orders_tbl WHERE part = "'.$_POST["partNum"].'"';

            //make query & get result
            if ($result= $conn -> query($sql)) {
            
            }
           
            //fetch resulting rows as an array
            while($order = mysqli_fetch_array($result)){
                $ordersACT[] = $order;
            }

        }elseif(($_POST['partNum']!= "") && ($_POST['startDate'] != "")){

            $sql = "SELECT * FROM orders_tbl WHERE part = '".$_POST['partNum']."' AND shipped >'".$_POST['startDate']."' AND shipped <'".$_POST['endDate']."' ";

            //make query & get result
            if ($result= $conn -> query($sql)) {
            
            }
            
            //fetch resulting rows as an array
            while($order = mysqli_fetch_array($result)){
                $ordersACT[] = $order;
            }

        }elseif(($_POST['partNum'] == "") && ($_POST['startDate'] != "")){
            
            
            $sql = "SELECT * FROM orders_tbl WHERE shipped >'".$_POST['startDate']."' AND shipped <'".$_POST['endDate']."' ";

            //make query & get result
            if ($result= $conn -> query($sql)) {
            
            }
           
            //fetch resulting rows as an array
            while($order = mysqli_fetch_array($result)){
                $ordersACT[] = $order;
            }
        }else{

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
        <script type="text/javascript" src="https://cdn.jsdelivr.net/jquery/latest/jquery.min.js"></script>
        <script type="text/javascript" src="https://cdn.jsdelivr.net/momentjs/latest/moment.min.js"></script>
        <script type="text/javascript" src="https://cdn.jsdelivr.net/npm/daterangepicker/daterangepicker.min.js"></script>

        <link rel="stylesheet" type="text/css" href="https://cdn.jsdelivr.net/npm/daterangepicker/daterangepicker.css" />
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/materialize/1.0.0/css/materialize.min.css">
        <link rel = "stylesheet" href = "https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css" />
        <link href="https://fonts.googleapis.com/css?family=Montserrat:300,400|Slabo+27px" rel="stylesheet">
        <link rel = "stylesheet" href = "activeOrders.css">
        <link rel = "stylesheet" href = "hamburger.css">
        <link rel = "stylesheet" href = "https://cdn.datatables.net/1.10.12/css/dataTables.bootstrap.min.css" />
        <link href = "https://fonts.googleapis.com/css?family=Merriweather|Playfair+Display|Raleway:400,700|Vollkorn:700&display=swap" rel="stylesheet">

        <title>Search Query</title>
    </head>
  <body>
  <div class="straightNav center">
        <div class="menu">
            <a href="upcomingOrders.php" >Upcoming Orders</a>
            <a href="../../TPM_Orders/todTomOrders.php" >Shipping Today and Tomorrow</a>
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
                <li><h3><a href="millTable.php" id="two">Mills &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp</a></h3></li>
                <li><h3><a href="index.php" id="two">All Orders &nbsp &nbsp &nbsp</a></h3></li>
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
    
    <div class="tableContainer">
        <div class ="title">
                <h2 id="OOTitle"><b>TPM Order Search Query</b></h2>
        </div>
        <form action="searchQuery.php" method="POST">
            <!-- Grid row -->
            <div class="form-row" style="font-size:40px;">
                <!-- Default input -->
                <div class="form-group col-md-6" style="padding-left:0">
                    <label for="jobNum" style="font-size:45px;">Job #</label>
                    <input type="text" class="form-control" style="font-size:30px;" name="jobNum" placeholder="1234">
                </div>
                <!-- Default input -->
                <div class="form-group col-md-6">
                    <label for="partNum" style="font-size:45px;">Part #</label>
                    <input type="text" class="form-control"  style="font-size:30px;" name="partNum" placeholder="12345678">
                </div>
            </div>
        
            <!-- Grid row -->
            <div class="form-row">
                <!-- Default input -->
                <div class="form-group col-md-6"  style="padding-left:0">
                    <label for="startDate" style="font-size:45px;">From</label>
                    <input type="date" class="form-control" style="font-size:30px;" name="startDate" placeholder="0000-00-00">
                </div>
                <!-- Default input -->
                <div class="form-group col-md-6"  style="padding-left:0">
                    <label for="endDate" style="font-size:45px;">To</label>
                    <input type="date" class="form-control" style="font-size:30px;" name="endDate" placeholder="0000-00-00">
                </div>
            </div>
            <!-- Grid row -->
            <input type="submit" class="btn btn-primary btn-md " name="Search" value="Search">
        </form>
        
        <div class="outTable">
            <table id= "outgoingOrders" class="table table-striped table-bordered">
                <thead>
                    <tr>
                        <td style ="vertical-align: middle;" >Mill</td>
                        <td style ="vertical-align: middle;">Job Number</td>
                        <td style ="vertical-align: middle;">Company Name</td>
                        <td style ="vertical-align: middle;">Quantity</td>
                        <td style ="vertical-align: middle;">Ship Date</td>
                        <td style ="vertical-align: middle;">Status</td>
                    </tr>
                </thead>
                <tbody>
                    <?php foreach($ordersACT as $order): ?>
                            <tr>
                                <td class="firstRow" style ="vertical-align: middle;"><?php echo ($order['Mill'] > 0 ? "<a href='displayProg.php?company=".getCustomer($order['cust_id'])."&quantity=".$order['quantity']."&job=".$order['job']."'>" . htmlspecialchars($order['Mill']) . "</a> " : ""); ?></td>
                                <td style ="vertical-align: middle;" class="firstRow"><?php echo ($order['has_started'] == 1 ? "<a href='tubeDates.php?job=".$order['job']."&company=".getCustomer($order['cust_id'])."'>" . htmlspecialchars($order['job']) . "</a> " : htmlspecialchars($order['job'])); ?></td>
                                <td style ="vertical-align: middle;"><?php echo htmlspecialchars(getCustomer($order['cust_id'])); ?></td>
                                <td style ="vertical-align: middle;"><?php echo htmlspecialchars($order['quantity']); ?></td>
                                <td style ="vertical-align: middle;"><?php echo htmlspecialchars($order['ship_date']); ?></td>
                                <td style ="vertical-align: middle;">
                                    <?php 
                                       if($order['has_started'] == 0){
                                           echo "Pending";
                                       }else if(($order['has_started'] == 1) && ($order['has_finished'] == 0)){
                                           echo "Active";
                                       }else{
                                           echo "Completed";
                                       }
                                    ?></td>     
                            </tr> 
                    <?php endforeach; ?>
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
                </tbody>
            </table>
        </div>
    </div> 
    
  </body>
</html>