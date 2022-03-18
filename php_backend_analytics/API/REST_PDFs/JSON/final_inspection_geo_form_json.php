<?php
    if(isset($_GET['from'])){
            $from = $_GET['from'];
    }else{
            $from = 1;
    }

    if(isset($_GET['to'])){
            $too = $_GET['to'];
    }else{
            $too = 20;
    }

        $total = $too - $from;
        $no_of_pages = ceil($total/25);
        $pages_count = array();

        for ($i = 0; $i < $no_of_pages; $i++)
        {
            array_push($pages_count, $i);
        }
        foreach($pages_count as $key=>$value){
            if ($key == 0) {
                if ($too < 25) {
                $to = $too;  
                } else {
                $to = $from+24;
                }
            } else {
                $from = $from+25;
                $to2 = $to+25;
                if ($to2 < $too) {
                $to = $to+25;
                } else {
                $to = $too;
                }
            }
        }
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
            'length' => $partSpec['finished_length'],
            'lineItem' => $orderACT['item'],
            'finLenPos' => $partSpec['length_plus'],
            'finLenNeg' => $partSpec['length_minus'],
            'quantity' => $orderACT['quantity'],
            'od' => $partSpec['dim'],
            'odPostive' => $partSpec['dim_plus'],
            'odNegtive' => $partSpec['dim_minus'],
            'idDrift' => $partSpec['drift'],
            'inspNotes' => $partSpec['insp_notes'],
            // 'from' => $from,
            // 'too' => $too,
            // 'pageCount' => $pages_count,
        );   
?>