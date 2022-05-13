<?php
    $header_tilte = "Shipping Outlook";
    include '../Connections/connectionTPM.php';
    include 'header.php';
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

<div class="container-fluid px-4 pb-4">
    <div class="card my-4">
        <div class="card-header">
            <h3 class="text-center py-0"><b> Shipping Today</b></h3>
        </div>
        <div class="card-body">
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
    </div>

    <div class="card my-4">
        <div class="card-header">
            <h3 class="text-center py-0"><b> Shipping Tomorrow</b></h3>
        </div>
        <div class="card-body">
            <table id="outgoingOrdersTom" class="table table-striped table-bordered">
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
</div>

<script type="text/javascript">
    $(function () {    
        $('#outgoingOrdersToday').DataTable( {        
            responsive: true,
            // pageLength : 25,
        } );        
        $('#outgoingOrdersTom').DataTable( {        
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
  </body>
</html>
