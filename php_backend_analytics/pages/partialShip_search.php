<?php
    include '../Connections/connectionTPM.php';
?>

<?php
    $shipments = array();
    if(isset($_GET['Search'])){
        

        if($_GET['job']!= ""){
            $sql = 'SELECT * FROM partial_ship WHERE job = "'.$_GET["job"].'"';

            //make query & get result
            if ($result= $conn -> query($sql)) {
            
            }
            while($queryResult = mysqli_fetch_array($result)){
                $shipments[] = $queryResult;
            }
        }

        
    }
    if(isset($_POST['delete'])){
        $job = $_POST['jobNum'];
        $cust = $_POST['cust_id'];
        $quan = $_POST['quantity'];
        $ship_date = $_POST['ship_date'];
        
        $sql = "DELETE FROM partial_ship WHERE job ='$job' AND cust_id = '$cust' AND quantity = '$quan' AND ship_date = '$ship_date'";

        //make query & get result
        if ($result= $conn -> query($sql)) {

        }

        header('Location:http://198.71.55.128/page/partialShip_search.php?job='.$job.'&Search=Search');
        exit();

        
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

        <title>TPM Shipments</title>
    </head>
  <body>
    <div class="straightNav center">
        <div class="menu">
            <a href="upcomingOrders.php" >Upcoming Orders</a>
            <a href="todTomOrders.php" >Shipping Today and Tomorrow</a>
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
                <h2 id="OOTitle"><b>Shipments</b></h2>
        </div>
        <form action="partialShip_search.php" method="GET" class="center">
            <label for="job" style="font-size:45px;">Job #</label>
            <input type="text" class="form-control center" style="font-size:30px; width: 30%; margin-left: 35%;" name="job" placeholder="1234">
            <input type="submit" class="btn btn-primary btn-md " name="Search" value="Search">
        </form>
        
        <div class="outTable">
            <table id= "outgoingOrders" class="table table-striped table-bordered">
                <thead>
                    <tr>
                        <td style ="vertical-align: middle;">Job</td>
                        <td style ="vertical-align: middle;">Company</td>
                        <td style ="vertical-align: middle;">Quantity</td>
                        <td style ="vertical-align: middle;">Ship Date</td>
                        <td style ="vertical-align: middle;"></td>

                        
                    </tr>
                </thead>
                <tbody>
                        <?php foreach($shipments as $shipment): ?>
                            <tr>
                            <td style ="vertical-align: middle;"><?php echo htmlspecialchars($shipment['job']); ?></td>
                                <td style ="vertical-align: middle;"><?php echo htmlspecialchars(getCustomer($shipment['cust_id'])); ?></td>
                                <td style ="vertical-align: middle;"><?php echo htmlspecialchars($shipment['quantity']); ?></td>
                                <td style ="vertical-align: middle;"><?php echo htmlspecialchars($shipment['ship_date']); ?></td> 
                                <td style ="vertical-align: middle;" id="deleteBtn">
                                <form action="" method="POST">
                                    <input type="hidden" name="jobNum" value="<?php echo $shipment['job'] ?>">
                                    <input type="hidden" name="cust_id" value="<?php echo $shipment['cust_id'] ?>">
                                    <input type="hidden" name="quantity" value="<?php echo $shipment['quantity'] ?>">
                                    <input type="hidden" name="ship_date" value="<?php echo $shipment['ship_date'] ?>">
                                    <input type="submit" name="delete" value="Delete" class="button">
                                </form>  
                            </tr>
                        <?php endforeach;?>
                </tbody>
            </table>
        </div>
    </div> 
  </body>
</html>
<?php

    function getCustomer($cust_id){
        include '../Connections/connectionTPM.php';
        $sqls = "SELECT * FROM cust_tbl WHERE cust_id = '".$cust_id."'";

        //make query & get result
        if ($results= $conn -> query($sqls)) {
        
        }
        
        //fetch resulting rows as an array
        $orderACTS = mysqli_fetch_assoc($results);

        return $orderACTS['customer'];
    }
?>