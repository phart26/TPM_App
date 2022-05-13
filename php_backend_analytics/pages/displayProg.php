<!-- Displays the order progress information for the mill that is clicked on from the active orders page -->
<?php
    $header_tilte = "Displaying Mill Progress";
    include '../Connections/connectionTPM.php';
    include 'header.php';
?>

<?php
    if(isset($_POST['reassign'])){

        $job = $_POST['job'];

        $sql = "UPDATE orders_tbl SET device = ' ' WHERE job = $job";
        if ($result= $conn -> query($sql)) {
	
        }

        $sql = "UPDATE live_shop_tbl SET mill = 0 WHERE job = $job";
        if ($result= $conn -> query($sql)) {
            header("Location: upcomingOrders.php");
        }
    }

    $job = $_GET['job'];
    $company = $_GET['company'];
    $totTub = $_GET['quantity'];


    $sql = "SELECT * FROM orders_tbl WHERE job = $job";

    //make query & get result
    if ($result= $conn -> query($sql)) {
	
	}
	
    $job_mill = mysqli_fetch_array($result);


    //write query for all orders
    $sql = "SELECT * FROM tubes_tbl WHERE job = $job";

    //make query & get result
    if ($result= $conn -> query($sql)) {
	
	}
	
    $orderACT = array();
    while($order = mysqli_fetch_array($result)){
        $orderACT[] = $order;
    }

    //getting updated number of tubes
    $currTub = sizeof($orderACT);
    $percent = !empty($totTub) ? round(($currTub/$totTub)*100) : 0;

    //calculating the number of tubes welded and inspected today
    date_default_timezone_set("US/Central");
    $weld_tod = 0;
    $insp_tod = 0;
    $insp_tot = 0;
    foreach($orderACT as $tube){
        $date_time_mill = $tube['mill_time'];
        $date_time_insp = $tube['insp_time'];
        $new_date_mill = date("Y-m-d",strtotime($date_time_mill));
        $new_date_insp = date("Y-m-d",strtotime($date_time_insp));

        if($new_date_mill == date("Y-m-d")){
            $weld_tod++;
        }
        if($new_date_insp == date("Y-m-d") && $tube['insp_check'] == 1){
            $insp_tod++;
        }
        if($tube['insp_check'] == 1){
            $insp_tot++;
        }
    }

    $timeStamp = date("Y-m-d H:i:s");
    
?>
    <div class="container-fluid px-4 pb-4">
        <div class="card mt-4">
            <div class="card-header">
                <h3 class="text-center py-0"><b> Mill <?php echo substr($job_mill['device'], 6); ?></b></h3>
            </div>
            <div class="card-body">

                <div class="row px-4 mb-4">
                    <div class="col-md-3 col-xs-hidden"></div>
                    <div class="col-md-6 col-xs-12">
                        <div class="row">
                            <div class="col-6 text-left px-0">
                                <h4 class="font-weight-bold text-secondary">Job #: <label class="text-info"><?php echo $job; ?></label></h4>                                
                            </div>
                            <div class="col-6 text-left px-0">
                                <h4 class="font-weight-bold text-secondary">Company: <label class="text-info font-weight-bold"><?= $company;?></label></h4>                                
                            </div>
                        </div>
                    </div>
                </div>
                
                <div class="row px-4 mb-4">
                    <div class="col-md-3 col-xs-hidden"></div>
                    <div class="col-md-6 col-xs-12">
                        <div class="row">
                            <div class="col-6 text-left px-0">
                                <h4 class="font-weight-bold text-secondary">Quantity: <label class="text-info"><?php echo $totTub; ?></label></h4>                                
                            </div>
                            <div class="col-6 text-left px-0">
                                <h4 class="font-weight-bold text-secondary">Tubes Left on Mill: <label class="text-info font-weight-bold"><?= $totTub > $currTub ? ($totTub - $currTub) : 0;?></label></h4>                                
                            </div>
                        </div>
                    </div>
                </div>

                <div class="row">                      
                    <div class="w-50 m-auto progress" style="height: 20px;">
                        <div class="progress-bar progress-bar-striped bg-info" role="progressbar" 
                                style="width: <?= $percent?>%;" aria-valuenow="<?= $percent?>" aria-valuemin="0" aria-valuemax="100" title="<?= $percent?>%"><?= $percent?>%</div>
                    </div>
                </div>

                <!-- >> #################################################### -->

                <div class="row px-4 my-4">
                    <div class="col-md-3 col-xs-hidden"></div>
                    <div class="col-md-6 col-xs-12">
                        <div class="row">
                            <div class="col-12 text-center px-0">
                                <h4 class="font-weight-bold text-secondary">Tubes Welded Today at:</h4>
                                <label class="text-info"><?=  $timeStamp; ?></label><br> 
                                <label class="text-danger"><?= $weld_tod?></label>
                            </div>                            
                        </div>
                    </div>
                </div>
                
                <div class="row px-4 my-4">
                    <div class="col-md-3 col-xs-hidden"></div>
                    <div class="col-md-6 col-xs-12">
                        <div class="row">
                            <div class="col-12 text-center px-0">
                                <h4 class="font-weight-bold text-secondary">Tubes Inspected Today at:</h4>
                                <label class="text-info"><?=  $timeStamp; ?></label><br>
                                <label class="text-danger"><?= $insp_tod ?></label>
                            </div>                            
                        </div>
                    </div>
                </div>

                <div class="row px-4 my-4">
                    <div class="col-md-3 col-xs-hidden"></div>
                    <div class="col-md-6 col-xs-12">
                        <div class="row">
                            <div class="col-12 text-center px-0">
                                <h4 class="font-weight-bold text-secondary">Total Tubes Welded:</h4>
                                <label class="text-danger"><?= count($orderACT) ?></label>
                            </div>                            
                        </div>
                    </div>
                </div>
                
                <div class="row px-4 my-4">
                    <div class="col-md-3 col-xs-hidden"></div>
                    <div class="col-md-6 col-xs-12">
                        <div class="row">
                            <div class="col-12 text-center px-0">
                                <h4 class="font-weight-bold text-secondary">Total Tubes Inspected:</h4>
                                <label class="text-danger"><?= $insp_tot ?></label>
                            </div>                            
                        </div>
                    </div>
                </div>

            </div>
    </div>
    
  </body>
</html>