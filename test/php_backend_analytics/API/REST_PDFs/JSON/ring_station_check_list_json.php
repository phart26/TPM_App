<?php
    if(isset($_GET['from']) && !empty($_GET['from']))
        $from = $_GET['from'];
    else
        $from = 1;
    if(isset($_GET['to']))
        $too = $_GET['to'];
    else
        $too = 20;
    $alldigit = range($from, $too);
    $allLoop = array_chunk($alldigit, 25); 
    $pages_count = $allLoop;
    
?>
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
    
    $jsonArr = array(
            'job' => $job,
            'poNum' => $orderACT['po'],
            'ringMin' => $partSpec['ring_min'],
            'lineItem' => $orderACT['item'],
            'ringMax' => $partSpec['ring_max'],
            'quantity' => $orderACT['quantity'],
            'partDesc' => $partSpec['description'],
            // 'from' => $from,
            // 'too' => $too,
            // 'pageCount' => $pages_count
    );

    
?>