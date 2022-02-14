<!-- Displays all active orders organized by mill number-->

<?php
    include '../Connections/connectionTPM.php';
?>

<?php
    //write query for all orders
    $sql = 'SELECT * FROM mac_add_tbl';

    //make query & get result
    if ($result= $conn -> query($sql)) {
	
	}
	

    $ordersACT = array();
    //fetch resulting rows as an array
    while($order = mysqli_fetch_array($result)){
        $ordersACT[] = $order;
    }
?>
<?php

    if(isset($_POST['updateDevName'])){
        //write query for all orders
        echo "hi";
        $sql = "UPDATE mac_add_tbl SET MAC_address = '".$_POST['newAddress']."' WHERE device = '".$_POST['devName']."'";

        //make query & get result
        if ($result= $conn -> query($sql)) {
            header("Location: macAdd.php");
        
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
        <link href="https://fonts.googleapis.com/css?family=Montserrat:300,400|Slabo+27px" rel="stylesheet">
        <link rel = "stylesheet" href = "activeOrders.css">
        <link rel = "stylesheet" href = "hamburger.css">
        <link rel = "stylesheet" href = "https://cdn.datatables.net/1.10.12/css/dataTables.bootstrap.min.css" />
        <link href = "https://fonts.googleapis.com/css?family=Merriweather|Playfair+Display|Raleway:400,700|Vollkorn:700&display=swap" rel="stylesheet">

        <title>Devices</title>
    </head>
  <body>
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

    <?php

        if(isset($_POST['updateDev'])){
            echo '<style type="text/css">
            #devUpdate {
                display: block;
            }

            #upOrders{
                opacity: .1;
            }
            </style>';

        }
    ?>
    <script>
            function hideAssign(){
                document.getElementById("MillForm").style.display = "none";
                document.getElementById("upOrders").style.opacity = 1;
            }
    </script>

    

    <div class="tableContainer">
        <div class ="title">
                <h2 id="OOTitle"><b>Fire Tablets</b></h2>
        </div>

        <form action="macAdd.php" method= "POST" class="center" id="devUpdate">
            <input type="hidden" name="devName" value="<?php echo $_POST['deviceName'] ?>">
                <label>New MAC Address For <?php echo $_POST['deviceName'] ?></label>
                <input type="text" name="newAddress">
                <input type="submit" name="updateDevName" value="Update" class="button">
                <button onclick= "hideAssign()" class="button">Back</button>
        </form>

        <div class="outTable">
            <table id= "upOrders" class="table table-striped table-bordered">
                <thead>
                    <tr>
                        <td style ="vertical-align: middle;" >Station Device</td>
                        <td style ="vertical-align: middle;">MAC Address</td>
                        <td style ="vertical-align: middle;">Update</td>
                    </tr>
                </thead>
                <tbody>
                    <?php foreach($ordersACT as $order): ?>
                            <tr>
                                <td style ="vertical-align: middle;"><?php echo htmlspecialchars($order['device']); ?></td>
                                <td style ="vertical-align: middle;"><?php echo htmlspecialchars($order['MAC_address']); ?></td>
                                <td style ="vertical-align: middle;">
                                    <form action="macAdd.php" method="POST">
                                        <input type="hidden" name="deviceName" value="<?php echo $order['device'] ?>">
                                        <input type="submit" name="updateDev" value="Update" class="button">
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