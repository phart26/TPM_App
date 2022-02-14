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
     include 'testData.php';
    $jsonArr = array(
            'poNum' => $orderACT['po'],
            'quantity' => $orderACT['quantity'],
            'drawingNum' => $partSpec['drawing_number'],
            'job' => $job
            // 'from' => $from,
            // 'too' => $too,
            // 'pageCount' => $pages_count,
    );

    
?>