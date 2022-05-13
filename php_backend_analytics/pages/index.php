<!-- Displays all active orders organized by mill number-->
<?php
    $header_tilte = "All Orders";
    include '../Connections/connectionTPM.php';
    include 'header.php';
?>
<?php
    date_default_timezone_set("US/Central");
    //write query for all orders
    $sql = 'SELECT * FROM orders_tbl WHERE has_finished = 0 AND has_started = 1 ORDER BY ship_date';
    $ordersStarted = $db->query($sql)->fetchAll();

    $sql = 'SELECT * FROM orders_tbl WHERE has_finished = 0 AND has_started = 0 ORDER BY ship_date';
    $ordersNotStarted = $db->query($sql)->fetchAll();

    function getCustomer($cust_id){
        include '../Connections/connectionTPM.php';
        $sql = "SELECT * FROM cust_tbl WHERE cust_id = '".$cust_id."'";
        
        return !empty( $db->query($sql)->fetchArray()['customer']) ? $db->query($sql)->fetchArray()['customer'] : "";
    }
?>    
    <div class="container-fluid px-4 pb-4">

        <!-- In progress Orders >> -->
        <div class="card mt-4">
            <div class="mb-0 pt-2 card-header">
                <h3 class="text-center col-12 p-0"><b>In Progress Orders</b> ( <?= !empty(count($ordersStarted)) ? count($ordersStarted) : 0; ?> )</h3>
            </div>
            <div class="card-body">
                <table id="outgoingOrders" class="table table-striped table-bordered">
                    <thead>
                        <tr>
                            <th><h4 class="mb-0 text-center">Mill</h4></th>
                            <th><h4 class="mb-0 text-center">Job Number</h4></th>
                            <th><h4 class="mb-0 text-center">Company Name</h4></th>
                            <th><h4 class="mb-0 text-center">Quantity</h4></th>
                            <th><h4 class="mb-0 text-center">Ordered Date</h4></th>
                            <th><h4 class="mb-0 text-center">Ship Date</h4></th>
                            <!-- <th><h4 class="mb-0 text-center">Most Recent Update</h4></th> -->
                        </tr>
                    </thead>
                    <tbody>
                        <?php foreach($ordersStarted as $order): ?>
                                <tr>
                                    <td><?php echo ($order['device'] != "" ? "<a href='displayProg.php?company=".getCustomer($order['cust_id'])."&quantity=".$order['quantity']."&job=".$order['job']."'>" . htmlspecialchars(substr($order['device'],6)) . "</a> " : ""); ?></td>
                                    <td><?php echo ($order['has_started'] == 1 || ($order['device'] != "" && $order['has_finished'] == 0)  ? "<a href='timeStamp.php?job=".$order['job']."&company=".getCustomer($order['cust_id'])."'>" . htmlspecialchars($order['job']) . "</a> " : htmlspecialchars($order['job'])); ?></td>
                                    <td ><?php echo htmlspecialchars(getCustomer($order['cust_id'])); ?></td>
                                    <td ><?php echo htmlspecialchars($order['quantity']); ?></td>
                                    <td ><?php echo htmlspecialchars($order['ordered']); ?></td>
                                    <td ><?php echo htmlspecialchars($order['ship_date']); ?></td>
                                </tr> 
                        <?php endforeach; ?>                        
                    </tbody>
                </table>
            </div>
        </div>

        <!-- Not Started Orders >> -->
        <div class="card mt-4">
            <div class="mb-0 pt-2 card-header">
                <h3 class="text-center col-12 p-0"><b>Not Started Orders</b> ( <?= !empty(count($ordersNotStarted)) ? count($ordersNotStarted) : 0; ?> )</h3>
            </div>
            <div class="card-body">
                <table id="ordersNotStarted" class="table table-striped table-bordered">
                    <thead>
                        <tr>
                            <th><h4 class="mb-0 text-center">Mill</h4></th>
                            <th><h4 class="mb-0 text-center">Job Number</h4></th>
                            <th><h4 class="mb-0 text-center">Company Name</h4></th>
                            <th><h4 class="mb-0 text-center">Quantity</h4></th>
                            <th><h4 class="mb-0 text-center">Ordered Date</h4></th>
                            <th><h4 class="mb-0 text-center">Ship Date</h4></th>
                            <!-- <th><h4 class="mb-0 text-center">Most Recent Update</h4></th> -->
                        </tr>
                    </thead>
                    <tbody>
                        <?php foreach($ordersNotStarted as $order): ?>
                                <tr>
                                    <td><?php echo ($order['device'] != "" ? "<a href='displayProg.php?company=".getCustomer($order['cust_id'])."&quantity=".$order['quantity']."&job=".$order['job']."'>" . htmlspecialchars(substr($order['device'],6)) . "</a> " : ""); ?></td>
                                    <td><?php echo ($order['has_started'] == 1 || ($order['device'] != "" && $order['has_finished'] == 0)  ? "<a href='timeStamp.php?job=".$order['job']."&company=".getCustomer($order['cust_id'])."'>" . htmlspecialchars($order['job']) . "</a> " : htmlspecialchars($order['job'])); ?></td>
                                    <td ><?php echo htmlspecialchars(getCustomer($order['cust_id'])); ?></td>
                                    <td ><?php echo htmlspecialchars($order['quantity']); ?></td>
                                    <td ><?php echo htmlspecialchars($order['ordered']); ?></td>                                    
                                    <td ><?php echo htmlspecialchars($order['ship_date']); ?></td>                                    
                                </tr> 
                        <?php endforeach; ?>
                    </tbody>
                </table>
            </div>
        </div>

    </div>
<!-- js proc >>  -->
<script type="text/javascript">
  $(function () {    
    $('#outgoingOrders').DataTable( {        
        responsive: true,
        // pageLength : 25,
    } );

    $('#ordersNotStarted').DataTable( {        
        responsive: true,
        // pageLength : 25,
    } );
    $('#ordersCompleted').DataTable( {        
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