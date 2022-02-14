<?php
    include '../Connections/connectionTPM.php';
?>

<?php
    $page = $_SERVER['PHP_SELF'];
    $sec = "3600";
?>
<?php

    date_default_timezone_set('America/Chicago');
    $today = date("Y-m-d", time());
    $tomorrow = date("Y-m-d", strtotime('tomorrow'));
    
    //write query for all orders
    $sqlTOD = "SELECT * FROM partial_ship WHERE ship_date = '$today' ORDER BY job";
    $sqlTOM = "SELECT * FROM partial_ship WHERE ship_date = '$tomorrow' ORDER BY job";

    //make query & get result
    if ($resultTOD = $conn -> query($sqlTOD)) {
        
    }

    if ($resultTOM = $conn -> query($sqlTOM)) {
        
    }
    
    $ordersTOD = array();
    $ordersTOM = array();


    //fetch resulting rows as an array
    while($orderTOD = mysqli_fetch_array($resultTOD)){
        $ordersTOD[] = $orderTOD;
    }

    while($orderTOM = mysqli_fetch_array($resultTOM)){
        $ordersTOM[] = $orderTOM;
    }
        
?>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
   "http://www.w3.org/TR/html4/loose.dtd">

<html lang="en">
    <head>
    <meta charset="utf-8">
    <meta charset="utf-8">
        <meta name="description" content="Table display for out going TPM orders for the next two weeks">
        <meta name="viewport" content="width=device-width, initial-scale = 1.0">        
        <meta http-equiv="X-UA-Compatible" content="ie=edge">
        <meta http-equiv="refresh" content="<?php echo $sec?>;URL='<?php echo $page?>'">

        <script src = "https://ajax.googleapis.com/ajax/libs/jquery/2.2.0/jquery.min.js"></script>
        <script src = "https://cdn.datatables.net/1.10.12/js/jquery.dataTables.min.js"></script>
        <script src = "https://cdn.datatables.net/1.10.12/js/dataTables.bootstrap.min.js"></script>

        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/materialize/1.0.0/css/materialize.min.css">
        <link rel = "stylesheet" href = "https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css" />
        <link rel = "stylesheet" href = "millStylesheet.css">
        <link rel = "stylesheet" href = "hamburger.css">
        <link rel = "stylesheet" href = "https://cdn.datatables.net/1.10.12/css/dataTables.bootstrap.min.css" />
        <link href = "https://fonts.googleapis.com/css?family=Merriweather|Playfair+Display|Raleway:400,700|Vollkorn:700&display=swap" rel="stylesheet">

        <title>Shipping Outlook</title>
    </head>
  <body>
      <!-- nav bar -->
      <div class="navBar">
            <div class="nav-toggle">
                <div class="nav-toggle-bar"></div>
            </div>
        </div>
    <div class="tableContainer">
        <div class ="title">
                <h2 id="todayTitle"><b>Shipping Today</b></h2>
        </div>
        <div class="outTodayTable">
            <table id= "outgoingOrdersToday" class="table table-striped table-bordered">
                <thead>
                    <tr>
                        <td>Job</td>
                        <td>Company</td>
                        <td>Quantity</td>
                        <td>Ship Date</td>
                    </tr>
                </thead>
                <tbody>
                    <?php foreach($ordersTOD as $order): ?>
                        <tr>
                        <td><b><?php echo htmlspecialchars($order['job']); ?></b></td>
                        <td><b><?php echo htmlspecialchars(getCustomer($order['cust_id'])); ?></b></td>
                        <td><b><?php echo htmlspecialchars($order['quantity']); ?></b></td>
                        <td><b><?php echo htmlspecialchars($order['ship_date']); ?></b></td>
                        </tr> 
                    <?php endforeach; ?>
                </tbody>
            </table>
        </div>

        <div class ="title">
                <h2 id="tomorrowTitle"><b>Shipping Tomorrow</b></h2>
        </div>
        <div class="outTomTable">
            <table id= "outgoingOrdersTom" class="table table-striped table-bordered">
                <thead>
                    <tr>
                        <td>Job</td>
                        <td>Company</td>
                        <td>Quantity</td>
                        <td>Ship Date</td>
                    </tr>
                </thead>
                <tbody>
                    <?php foreach($ordersTOM as $order): ?>
                        <tr>
                        <td><?php echo htmlspecialchars($order['job']); ?></td>
                        <td><?php echo htmlspecialchars(getCustomer($order['cust_id'])); ?></td>
                        <td><?php echo htmlspecialchars($order['quantity']); ?></td>
                        <td><?php echo htmlspecialchars($order['ship_date']); ?></td>
                        </tr> 
                    <?php endforeach; ?>
                </tbody>
            </table>
        </div>
    </div> 
  </body>
</html>

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