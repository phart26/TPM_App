
<?php
    include '../Connections/connectionTPM.php';
    $sql = "SELECT * FROM orders_tbl WHERE job = $job";

    if ($result= $conn -> query($sql)) {
        
        }
        
    //fetch resulting rows as an array
    $orderACT = mysqli_fetch_assoc($result);

    $sql1 = "SELECT * FROM part_tbl WHERE part = '".$orderACT['part']."'";

    if ($result1= $conn -> query($sql1)) {
        
        }
        
    //fetch resulting rows as an array
    $partSpec = mysqli_fetch_assoc($result1);

    $sql2 = "SELECT * FROM cust_tbl WHERE cust_id = '".$orderACT['cust_id']."'";

    if ($result2= $conn -> query($sql2)) {
        
        }
        
    //fetch resulting rows as an array
    $custSpec = mysqli_fetch_assoc($result2);

    $jsonArr = array(
            'customer' => $custSpec['customer'],
            'job' => $job,
            'partDesc' => $partSpec['description'],
            'partNum' => $orderACT['part'],
            'poNum' => $orderACT['po'],
            // 'tubeHeatNum' => $header['tube_heat_number'],
            // 'ringHeatNum' => $header['ring_heat_number'],
            'quantity' => $orderACT['quantity'],
            // 'containerType' => $header['container_type'],
            // 'shippingMethod' => $header['shipping_method'],
            'shipDate' => $orderACT['ship_date'],
            'lineItem' => $orderACT['item']
    );

    
?>